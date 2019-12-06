DIR_PATH=${path}

ACL=${acl}
BUCKET_PATH=${bucket_path}
OPENAPI_SPEC_PATHS=${openapi_spec_paths}
OPENAPI_SPEC_URL=${openapi_spec_url}
SWAGGER_UI_VERSION=${swagger_ui_version}

PROFILE=${profile}

WORK_DIR=tmp
SWAGGER_TARGET=$WORK_DIR/$(basename $BUCKET_PATH)/$(dirname $BUCKET_PATH)/swagger-ui

mkdir -p $DIR_PATH/$SWAGGER_TARGET

curl --silent -L https://github.com/swagger-api/swagger-ui/archive/$SWAGGER_UI_VERSION.tar.gz -o $DIR_PATH/$SWAGGER_TARGET.tar.gz
tar --strip-components 1 -C $DIR_PATH/$SWAGGER_TARGET -xf $DIR_PATH/$SWAGGER_TARGET.tar.gz

# Use swagger ui urls if more than pme openaspi specifications
if [ $${#OPENAPI_SPEC_PATHS[@]} > 1 ]; then
  urls_string="["
  for path in $${OPENAPI_SPEC_PATHS[@]}; do
    urls_string+="{url: \"$bucket_path/$(basename $${path})\",  name: \"$(basename $${path})\"},"
  done
  urls_string="$${urls_string%?}]"
  sed -i "s@url:.*@urls: $urls_string,@" $DIR_PATH/$SWAGGER_TARGET/dist/index.html
# User swagger ui url. This should always be true unless no openapi specifications
elif [[ $${#OPENAPI_SPEC_PATHS[@]} == 1  || ! -z $OPENAPI_SPEC_URL ]]; then
  sed -i "s@url:.*@url: \"$OPENAPI_SPEC_URL\",@" $DIR_PATH/$SWAGGER_TARGET/dist/index.html
fi

aws s3 sync --profile $PROFILE --acl $ACL $DIR_PATH/$SWAGGER_TARGET/dist s3://$BUCKET_PATH

for path in $${OPENAPI_SPEC_PATHS[@]}; do
  aws s3 cp --profile $PROFILE --acl $ACL $path s3://$BUCKET_PATH/$(basename $path)  
done

rm -rf $DIR_PATH/$SWAGGER_TARGET.tar.gz
rm -rf $DIR_PATH/$SWAGGER_TARGET
