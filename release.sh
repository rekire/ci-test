#!/bin/bash
if [[ $# -eq 0 ]]; then
  echo "Expecting argument prepair or release"
  exit -1
fi

TAG=`git describe --tags`
MODULE=`echo $TAG|cut -d- -f 1`
VERSION=`echo $TAG|cut -d- -f 2-`

echo $1ing release $VERSION
if [[ $1 == "update" ]]; then
  sed -i -E "s/^version '[^']+'$/version '$VERSION'/g" build.gradle
  git add build.gradle
fi
if [[ $1 == "prepair" ]]; then
  mkdir -p publish
  cp build/libs/*.jar publish
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

  # prepare the key
  chmod 600 travis_rsa
  eval `ssh-agent -s`
  ssh-add travis_rsa

  git remote set-url origin git@github.com:rekire/ci-test.git
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch
  git checkout master
  git commit -m "Update version number to $VERSION"
  git push
  git tag -fa $TAG -m "Move tag for updated readme"
  git push origin master --tags -f
fi
