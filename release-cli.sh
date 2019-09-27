#!/bin/bash
TAG=`git describe --tags`
MODULE=`echo $TAG|cut -d- -f 1`
VERSION=`echo $TAG|cut -d- -f 2-`

sed -i -E "s/^version '[^']+'$/version '$VERSION'/g" build.gradle
git add build.gradle
echo Updating readme...
sed -i -E "s/version is [0-9][^]\"]+/version is $VERSION/g" readme.md
sed -i -E "s/cli-[0-9][^ ]+-blue/$TAG-blue/g" readme.md
git add readme.md

cp build/libs/*.jar publish