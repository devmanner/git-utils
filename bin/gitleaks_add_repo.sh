#!/bin/bash

for file in $(ls *.gitleaks.log); do
    r=$(echo $file | sed "s/\\.gitleaks\\.log$//g")
    repo=$(echo $r | nkf -w --url-input)

    cat $file | jq '.[] + {"Repo": "'"$repo"'"}'

done 

