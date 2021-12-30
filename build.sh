#!/bin/sh

# Basic constants
SELF_FULL_PATH=$(realpath $0)
BASEDIR=$(dirname ${SELF_FULL_PATH})
DOCKER_BUILD_CMD='docker build'

# Configuration
IMAGE='route53_ddns:1.0'
BASE_AWS_DIR="${BASEDIR}/aws"

# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
export AWS_CONFIG_FILE="${BASE_AWS_DIR}/config"
export AWS_SHARED_CREDENTIALS_FILE="${BASE_AWS_DIR}/credentials"

# Configure if missing any file
[ -f $AWS_CONFIG_FILE ] || aws configure
[ -f $AWS_SHARED_CREDENTIALS_FILE ] || aws configure

# Details in the Dockerfile
$DOCKER_BUILD_CMD -t $IMAGE .
