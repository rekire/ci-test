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
  mkdir -p publish
  ./release-$MODULE.sh
  if [[ ! -f stable.zip ]]; then
    wget https://github.com/chocolatey/choco/archive/stable.zip
    unzip stable.zip
    #rm stable.zip
  fi
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
  sudo apt install apt-transport-https ca-certificates
  echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
  sudo apt update
  sudo apt-get -y install mono
  ls -l choco-stable
  cd choco-stable
  chmod +x build.sh
  chmod +x zip.sh
  ./build.sh
  ls -l build_output/chocolatey
  build_output/chocolatey/choco -v
fi

if [[ $1 == "prepair" ]]; then
  echo Setup deployment keys...
  # prepare the key
  chmod 600 travis_rsa
  eval `ssh-agent -s`
  ssh-add travis_rsa

  echo Committing changes...
  # Hide the mail address from spam bots
  git config --local user.email "`echo "Z2l0QHJla2kucmU=" | base64 -d`"
  git config --local user.name "rekire"
  git remote set-url origin git@github.com:rekire/ci-test.git
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch
  echo travis_rsa>>.gitignore
  echo publish>>.gitignore
  git checkout master
  git commit -m "[skip ci] Update version number to $VERSION"
  git push
  git tag -fa $TAG -m "Release $VERSION"
  git push origin master --tags -f

  ls -l publish
  ls -l build/libs/
  sed -i '' publish/*
fi
