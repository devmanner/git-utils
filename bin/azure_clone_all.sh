#!/bin/bash

if [ $# != 3 ]; then
    echo "Usage: $0 repo-url firstname.lastname@domain.tld organisation"
    echo "repo-url defaults to dev.azure.com"
    exit -1
fi

REPO_URL=$1
ID=$2
ORG=$3

AZURE_LIST_ALL_REPOS=$(dirname $(readlink -f $0))/azure_list_all_repos.sh
#for repo in $($AZURE_LIST_ALL_REPOS $REPO_URL $ID $ORG | sort); do
for repo in $(cat repos.txt); do
    dirname=$(basename $repo)
    proj=$(basename $(dirname $(dirname $repo)));

    mkdir -p $proj

    echo "#####################################################"
    echo "# Checking repo $repo in project: $proj"
    echo "#####################################################"

    if [ -d $proj/$dirname ]; then
        echo "# Pulling repo in $proj/$dirname"
        cd $proj/$dirname && git pull
        cd - > /dev/null
    else
        echo "# Cloning repo"
        cd $proj && git clone $repo && cd -
    fi
done
