#!/bin/bash

if [ $# != 2 -a $# != 3 ]; then
    echo "Usage: $0 firstname.lastname@domain.tld organisation [skip-to]"
    exit -1
fi

ID=$1
ORG=$2

if [ $# == 3 ]; then
    SKIP_TO=$3
else
    SKIP_TO=""
fi

AZURE_LIST_ALL_REPOS=$(dirname $(readlink -f $0))/azure_list_all_repos.sh

for repo in $($AZURE_LIST_ALL_REPOS $ID $ORG | sort); do
    dirname=$(basename $repo)

    if [ "$SKIP_TO" != "" ]; then
        if [ $dirname == $SKIP_TO ]; then
            SKIP_TO=""
        else
            echo "#####################################################"
            echo "# Skipping repo $repo"
            echo "#####################################################"
        fi
    fi

    if [ "$SKIP_TO" == "" ]; then
        echo "#####################################################"
        echo "# Checking repo $repo"
        echo "#####################################################"

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
            yesno=""
            while [ "$yesno" != "y" -a "$yesno" != "n" ]; do
                read -p "Accept all these leaks? (y/n) " yesno
            done
            if [ "$yesno" = "y" -o "$yesno" = "Y" ]; then
                echo "Adding all to .gitleaksignore..."
                cat $logfile | jq -r '.[].Fingerprint' >> $dirname/.gitleaksignore
            else
                echo "No action taken for $repo"
            fi
        fi
    fi
done
