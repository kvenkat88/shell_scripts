#!/bin/bash

# $1 --> directory_to_create
# $2 --> Gitlab CI Token
# $3 --> Gitlab Project Name
# $4 --> subdirectory to download
# $5 --> From which branch
# usage like -- ./specific_folder_download.sh <directory_to_create> <Gitlab CI Token> <Git repo name> <Subdirectory to download> <Branch Name>

rm -rf $1
mkdir -p $1
cd $1
git init
git remote add origin -f https://gitlab-ci-token:$2@gitlab.com/xyz-92618-group/engineering/$3.git
git config core.sparsecheckout true
echo "$4/*" >> .git/info/sparse-checkout
git pull --depth=2 origin $5
