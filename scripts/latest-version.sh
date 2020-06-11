#!/bin/bash

latest_version=$(curl --silent https://api.github.com/repos/swagger-api/swagger-ui/releases/latest | jq -r .tag_name)
printf '{"version":"%s"}' $latest_version
