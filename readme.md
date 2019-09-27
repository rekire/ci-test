# CI Test [![Build Status][travis-image]][travis-url] [![Latest CLI version is 1.0.17][cli-ver-img]][cli-dl-url]

This is just a test how to manage releases with travis and tags.

## The magic

This setup publishes the artifacts from `./publish/` and uploads them to a release in GitHub. For laziness the version number is updated in 
the `build.gradle` to force that the output artifact has the correct version number in its name. The script also updates the version number
in the readme file.

## The setup

For creating the release you need to install the travis command:

 - Just follow the [instructions](install-travis) to install the cli tool.
 - Execute `travis setup release` to authenticate and create a GitHub token to push your artifacts to the release.
 - You might need to reformat your `.travus.yaml` file, since the tool is not very smart in keeping your formatting. 

For pushing the version number updates in the code base you need to create and encrypt a deployment key:

 - Run `ssh-keygen -t rsa -b 4096 -C "CI deployment key"` to create a new ssh key.
 - I chose as file name `travis_rsa` you can name the file as you like and set **no password**.
 - Copy the content of `travis_rsa.pub` to `https://github.com/<user>/<repo>/settings/keys`, make sure that you **allow write access**!
 - Run `travis encrypt-file travis_rsa` to create a encrypted version of the ssh key.
 - Follow the advices in the console output.
 - Just to repeat: _"Make sure **not** to add `travis_rsa` to the git repository"_, if you would add this file everybody grants write access to your repository!
 
In the [`release.sh`](./release.sh) file I update the version numbers and move the output to `./publish/`, you can and should adapt it as you need it.

[travis-image]: https://travis-ci.com/rekire/ci-test.svg?branch=master
[travis-url]: https://travis-ci.com/rekire/ci-test
[install-travis]: https://github.com/travis-ci/travis.rb#installation
[cli-ver-img]: https://img.shields.io/badge/cli-1.0.17-blue "Latest CLI version is 1.0.17"
[cli-dl-url]: https://www.example.com