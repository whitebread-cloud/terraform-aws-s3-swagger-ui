DIR_PATH=${path}

ACL=${acl}
BUCKET=${bucket}
CUSTOM_OPENAPI_SPEC_PATH=${openapi_specification_path}
PROFILE=${profile}
VERSION=${version}


SWAGGER_TARGET=swagger-ui
OPENAPI_SPEC_FILE_NAME=api.yml

curl --silent -L https://github.com/swagger-api/swagger-ui/archive/$VERSION.tar.gz -o $DIR_PATH/$SWAGGER_TARGET.tar.gz
mkdir -p $DIR_PATH/$SWAGGER_TARGET
tar --strip-components 1 -C $DIR_PATH/$SWAGGER_TARGET -xf $DIR_PATH/$SWAGGER_TARGET.tar.gz
cp $CUSTOM_OPENAPI_SPEC_PATH $DIR_PATH/$SWAGGER_TARGET/dist/$OPENAPI_SPEC_FILE_NAME
sed -i "s/url:.*/url: \"$OPENAPI_SPEC_FILE_NAME\",/" $DIR_PATH/$SWAGGER_TARGET/dist/index.html
aws s3 sync --profile $PROFILE --acl $ACL $DIR_PATH/$SWAGGER_TARGET/dist s3://$BUCKET --delete
rm -rf $DIR_PATH/$SWAGGER_TARGET.tar.gz
rm -rf $DIR_PATH/$SWAGGER_TARGET
