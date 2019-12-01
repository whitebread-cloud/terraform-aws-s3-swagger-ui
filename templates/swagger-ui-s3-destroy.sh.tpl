BUCKET_PATH=${bucket_path}

PROFILE=${profile}

aws s3 rm --profile $PROFILE s3://$BUCKET_PATH --recursive
