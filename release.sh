#!/bin/bash
if [[ $# -eq 0 ]]; then
  echo "Expecting argument prepair or release"
  exit -1
fi

TAG=`git describe --tags`
MODULE=`echo $TAG|cut -d- -f 1`
VERSION=`echo $TAG|cut -d- -f 2-`

echo $1ing release $VERSION
if [[ $1 == "prepair" ]]; then
  sed -i -e "s/^version '[^']+'$/version '$VERSION'/g" build.gradle
  git add build.gradle
  mkdir -p publish
  cp $MODULE/build/*.jar publish
fi
if [[ $1 == "finish" ]]; then
  echo Updating readme...
  sed -i -E "s/version is [0-9][^]\"]+/version is $VERSION/g" readme.md
  sed -i -E "s/cli-[0-9][^ ]+-blue/$TAG-blue/g" readme.md
  echo Committing changes
  git config --local user.name "rekire"
  # Hide the mail address from spam bots
  git config --local user.email "`echo "Z2l0QHJla2kucmU=" | base64 -d`"
  git add readme.md
  git checkout master
  git commit -m "Update readme for the release $VERSION"
  git push
fi
