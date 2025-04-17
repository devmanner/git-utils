#!/bin/bash

for file in $(find . -name '*.gitleaks.log' -type f); do
    r=$(echo $(basename $file) | sed "s/\\.gitleaks\\.log$//g")
    repo=$(echo $r | nkf -w --url-input)

    cat $file | jq '.[] + {"Repo": "'"$repo"'"}'
done 

