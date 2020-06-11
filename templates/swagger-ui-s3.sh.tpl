DIR_PATH=${path}

ACL=${acl}
BUCKET_PATH=${bucket_path}
OPENAPI_SPEC_PATHS=${openapi_spec_paths}
OPENAPI_SPEC_URLS=${openapi_spec_urls}
SWAGGER_UI_VERSION=${swagger_ui_version}

PROFILE=${profile}

WORK_DIR=tmp
SWAGGER_TARGET=$WORK_DIR/$(basename $BUCKET_PATH)/$(dirname $BUCKET_PATH)/swagger-ui

mkdir -p $DIR_PATH/$SWAGGER_TARGET

curl --silent -L https://github.com/swagger-api/swagger-ui/archive/$SWAGGER_UI_VERSION.tar.gz -o $DIR_PATH/$SWAGGER_TARGET.tar.gz
tar --strip-components 1 -C $DIR_PATH/$SWAGGER_TARGET -xf $DIR_PATH/$SWAGGER_TARGET.tar.gz

# Grab the count of the largest array
if [ $${#OPENAPI_SPEC_PATHS[@]} -gt $${#OPENAPI_SPEC_URLS[@]} ]; then
  max=$${#OPENAPI_SPEC_PATHS[@]}
else
  max=$${#OPENAPI_SPEC_URLS[@]}
fi

bucket_key_without_file="/"
if [[ $BUCKET_PATH == *"/"* ]]; then
  bucket_key_without_file=$${BUCKET_PATH#*/}/
fi

# Use swagger ui urls if more than one path or url with urls taking precedence
if [ $max -gt 1 ]; then
  urls_string="["
  for ((i = 0; i < $max; i++ )); do

    # Use url if specified
    if [[ ! -z $${OPENAPI_SPEC_URLS[$i]} && $${OPENAPI_SPEC_URLS[$i]} != "" ]]; then
      urls_string+="{url: \"$${OPENAPI_SPEC_URLS[$i]}\",  name: \"$(basename $${OPENAPI_SPEC_URLS[$i]})\"},"
    else
      urls_string+="{url: \"/$${bucket_key_without_file}$(basename $${OPENAPI_SPEC_PATHS[$i]})\",  name: \"$(basename $${OPENAPI_SPEC_PATHS[$i]})\"},"
    fi
  done

  urls_string="$${urls_string%?}]"
  sed -i "s@url:.*@urls: $urls_string,@" $DIR_PATH/$SWAGGER_TARGET/dist/index.html

# Use swagger ui
elif [ $${#OPENAPI_SPEC_URLS[@]} -eq 1 ]; then
  sed -i "s@url:.*@url: \"$${OPENAPI_SPEC_URLS[0]}\",@" $DIR_PATH/$SWAGGER_TARGET/dist/index.html
# Use swagger ui
elif [ $${#OPENAPI_SPEC_PATHS[@]} -eq 1 ]; then
  sed -i "s@url:.*@url: \"/$${bucket_key_without_file}$(basename $${OPENAPI_SPEC_PATHS[0]})\",@" $DIR_PATH/$SWAGGER_TARGET/dist/index.html
fi

aws s3 sync --profile $PROFILE --acl $ACL $DIR_PATH/$SWAGGER_TARGET/dist s3://$BUCKET_PATH

for path in $${OPENAPI_SPEC_PATHS[@]}; do
  aws s3 cp --profile $PROFILE --acl $ACL $path s3://$BUCKET_PATH/$(basename $path)  
done

rm -rf $DIR_PATH/$SWAGGER_TARGET.tar.gz
rm -rf $DIR_PATH/$SWAGGER_TARGET
