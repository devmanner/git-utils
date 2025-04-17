#!/bin/bash

if [ $# != 0 -a $# != 1 ]; then
    echo "Usage: $0 [skip-to]"
    echo "Scan folder structure for repos and run gitleaks on those. Use skip-to to avoid scanning all repos..."
    exit -1
fi

if [ $# == 1 ]; then
    SKIP_TO=$1
else
    SKIP_TO=""
fi

for git_dir in $(find . -type d -name '.git'); do
    dirname=$(dirname $git_dir)
    repo=$(basename $dirname)

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

        logfile=$(basename $repo).gitleaks.log
#        gitleaks detect -v -s $dirname -f json -r $logfile
        docker run -v ./$dirname:/path -v .:/output zricethezav/gitleaks:latest detect -v -r /output/$logfile --source /path
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
