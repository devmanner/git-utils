#!/bin/bash

if [ $# != 2 ]; then
    echo "Usage: $0 firstname.lastname@domain.tld organisation"
    exit -1
fi

ID=$1
ORG=$2

AZURE_LIST_ALL_REPOS=$(dirname $(readlink -f $0))/azure_list_all_repos.sh

for repo in $($AZURE_LIST_ALL_REPOS $ID $ORG | sort); do
    echo "#####################################################"
    echo "# Checking repo $repo"
    echo "#####################################################"


    dirname=$(basename $repo)
    if [ -d $dirname ]; then
        echo "# Pulling repo in $dirname"
        cd $dirname && git pull
        cd - > /dev/null
    else
        echo "# Cloning repo"
        git clone $repo
    fi
    logfile=$(basename $repo).gitleaks.log
    gitleaks detect -v -s $dirname -f json -r $logfile
    if [ $? = 1 ]; then
        echo "Found leaks in "$dirname
        read -p "Accept all these leaks? (Y/N) " yesno
        if [ "$yesno" = "y" -o "$yesno" = "Y" ]; then
            echo "Adding all to .gitleaksignore..."
            cat $logfile | jq -r '.[].Fingerprint' >> $dirname/.gitleaksignore
        else
            echo "No action taken for $repo"
        fi

    fi
done
