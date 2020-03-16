#!/bin/bash
# Script used to deploy applications to AWS Elastic Beanstalk
# Should be hooked to CircleCI deploy workflow step
#
# Does three things:
# 1. Builds Docker image & pushes it to container registry
# 2. Generates new `Dockerrun.aws.json` file which is Beanstalk task definition
# 3. Creates new Beanstalk Application version using created task definition
#
# REQUIREMENTS!
# - AWS_ACCOUNT_ID env variable
# - AWS_ACCESS_KEY_ID env variable
# - AWS_SECRET_ACCESS_KEY env variable
#
# usage: ./deploy.sh name-of-application staging us-east-1 f0478bd7c2f584b41a49405c91a439ce9d944657

set -e
start=`date +%s`

# Name of your application, should be the same as in setup
NAME=$1

# Environment name e.g. `application-name-staging`, `application-name-test`, `application-name-production``
ENVNAME=$2

# AWS Region where app should be deployed e.g. `us-east-1`, `eu-central-1`
REGION=$3

# Hash of commit for better identification
SHA1=$4

if [ -z "$NAME" ]; then
  echo -n "You did not supply an AWS Elastic Beanstalk Application name. Please enter one here:"
  read answer
  if [ -z "$answer" ]; then
    echo "Application NAME was not provided, aborting deploy!"
    exit 1
  else
    NAME=$answer
    echo Application Name: $NAME
  fi
fi

if [ -z "$ENVNAME" ]; then
  echo -n "You did not supply an AWS Elastic Beanstalk Application Environment name. Please enter one here:"
  read answer
  if [ -z "$answer" ]; then
    echo "Application ENVNAME was not provided, aborting deploy!"
    exit 1
  else
    ENVNAME=$answer
    echo Application Environment Name: $ENVNAME
  fi
fi

if [ -z "$REGION" ]; then
  echo -n "You did not supply an AWS Region name. Please enter one here:"
  read answer
  if [ -z "$answer" ]; then
    echo "Application REGION was not provided, aborting deploy!"
    exit 1
  else
    REGION=$answer
    echo Application AWS Region: $REGION
  fi
fi

if [ -z "$SHA1" ]; then
  echo -n "You did not supply a SHA1 to identify this build. Please enter one here:"
  read answer
  if [ -z "$answer" ]; then
    echo "Application SHA1 was not provided, aborting deploy!"
    exit 1
  else
    SHA1=$answer
    echo Application SHA1: $SHA1
  fi
fi

if [ -z "$AWS_ACCOUNT_ID" ]; then
  echo -n "You did not supply an AWS Account ID. Please enter one here:"
  read answer
  if [ -z "$answer" ]; then
    echo "AWS_ACCOUNT_ID was not provided, aborting deploy!"
    exit 1
  else
    AWS_ACCOUNT_ID=$answer
    echo Application AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID
  fi
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo -n "You did not supply an AWS Access Key ID. Please enter one here:"
  read answer
  if [ -z "$answer" ]; then
    echo "AWS_ACCESS_KEY_ID was not provided, aborting deploy!"
    exit 1
  else
    AWS_ACCESS_KEY_ID=$answer
    echo Application AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
  fi
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo -n "You did not supply an AWS Secret Access Key. Please enter one here:"
  read answer
  if [ -z "$answer" ]; then
    echo "AWS_SECRET_ACCESS_KEY was not provided, aborting deploy!"
    exit 1
  else
    AWS_SECRET_ACCESS_KEY=$answer
    echo Application AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
  fi
fi

EB_BUCKET=$NAME-deployments
VERSION=$ENVNAME-$SHA1-$(date +%s)
ZIP=$VERSION.zip

echo Deploying $NAME to environment $ENVNAME, region: $REGION, version: $VERSION, bucket: $EB_BUCKET

aws configure set default.region $REGION
aws configure set default.output json

# Login to AWS Elastic Container Registry
echo 'logging into aws ecr'
eval $(AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID} AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} aws ecr get-login --no-include-email --region ${REGION})

# create the ECR repo if it does not exist yet
aws ecr describe-repositories --repository-names ${NAME} || aws ecr create-repository --repository-name ${NAME}

# create S3 bucket if it does not exist yet
echo "Checking S3 bucket exists..."
#Some sort of error happened with s3 check
if aws s3 ls "s3://$EB_BUCKET" 2>&1 | grep -q 'NoSuchBucket'
then
    echo "bucket does not exist or permission is not there to view it."
    echo "creating s3 bucket"
    aws s3api create-bucket --bucket=$EB_BUCKET --region=$REGION --create-bucket-configuration LocationConstraint=$REGION
else
    echo "bucket exists, continuing on..."
fi

# Build the image
docker build -t $NAME:$VERSION --build-arg S3_BUCKET_NAME=$S3_BUCKET_NAME --build-arg AWS_ACCESS_KEY_ID=AWS_ACCESS_KEY_ID --build-arg AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY --build-arg AWS_REGION=$REGION .
# Tag it
docker tag $NAME:$VERSION $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$NAME:$VERSION
# Push to AWS Elastic Container Registry
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$NAME:$VERSION

# Replace the <AWS_ACCOUNT_ID> with your ID
sed -i='' "s/<AWS_ACCOUNT_ID>/$AWS_ACCOUNT_ID/" Dockerrun.aws.json
# Replace the <NAME> with the your name
sed -i='' "s/<NAME>/$NAME/" Dockerrun.aws.json
# Replace the <REGION> with the selected region
sed -i='' "s/<REGION>/$REGION/" Dockerrun.aws.json
# Replace the <TAG> with the your version number
sed -i='' "s/<TAG>/$VERSION/" Dockerrun.aws.json

# Zip up the Dockerrun file
zip -r $ZIP Dockerrun.aws.json

# Send zip to S3 Bucket
aws s3 cp $ZIP s3://$EB_BUCKET/$ZIP

# Create a new application version with the zipped up Dockerrun file
aws elasticbeanstalk create-application-version --application-name $NAME --version-label $VERSION --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP

# Update the environment to use the new application version
aws elasticbeanstalk update-environment --environment-name $ENVNAME --version-label $VERSION

end=`date +%s`

echo Deploy ended with success! Time elapsed: $((end-start)) seconds