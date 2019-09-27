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
  ./release-$MODULE.sh

  echo Committing changes...
  # prepare the key
  chmod 600 travis_rsa
  eval `ssh-agent -s`
  ssh-add travis_rsa

  # Hide the mail address from spam bots
  git config --local user.email "`echo "Z2l0QHJla2kucmU=" | base64 -d`"
  git config --local user.name "rekire"
  git remote set-url origin git@github.com:rekire/ci-test.git
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch
  git checkout master
  git commit -m "[skip ci] Update version number to $VERSION"
  git push
  git tag -fa $TAG -m "Release $VERSION"
fi
if [[ $1 == "prepair" ]]; then
  echo travis_rsa>>.gitignore
  mkdir -p publish
  echo publish>>.gitignore
fi
if [[ $1 == "finish" ]]; then
  git push origin master --tags -f
fi
