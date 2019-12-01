DIR_PATH=${path}

ACL=${acl}
BUCKET_PATH=${bucket_path}
OPENAPI_SPEC_PATH=${openapi_spec_path}
OPENAPI_SPEC_URL=${openapi_spec_url}
SWAGGER_UI_VERSION=${swagger_ui_version}

PROFILE=${profile}

WORK_DIR=tmp
SWAGGER_TARGET=$WORK_DIR/$(basename $BUCKET_PATH)/$(dirname $BUCKET_PATH)/swagger-ui

mkdir -p $DIR_PATH/$SWAGGER_TARGET

curl --silent -L https://github.com/swagger-api/swagger-ui/archive/$SWAGGER_UI_VERSION.tar.gz -o $DIR_PATH/$SWAGGER_TARGET.tar.gz
tar --strip-components 1 -C $DIR_PATH/$SWAGGER_TARGET -xf $DIR_PATH/$SWAGGER_TARGET.tar.gz

if [[ ! -z $OPENAPI_SPEC_PATH || ! -z $OPENAPI_SPEC_URL ]]; then
  sed -i "s@url:.*@url: \"$OPENAPI_SPEC_URL\",@" $DIR_PATH/$SWAGGER_TARGET/dist/index.html
fi

aws s3 sync --profile $PROFILE --acl $ACL $DIR_PATH/$SWAGGER_TARGET/dist s3://$BUCKET_PATH --delete

if [ ! -z $OPENAPI_SPEC_PATH ]; then
  aws s3 cp --profile $PROFILE --acl $ACL $OPENAPI_SPEC_PATH s3://$BUCKET_PATH/$(basename $OPENAPI_SPEC_PATH)
fi

rm -rf $DIR_PATH/$SWAGGER_TARGET.tar.gz
rm -rf $DIR_PATH/$SWAGGER_TARGET
