#!/bin/bash

if [ $# != 1 ]; then
    echo "$0 input.json"
    echo "Convert gitleaks json output file to CSV (since stakeholders like excel...)"
    exit -1
fi

echo '"Repo", "RuleID", "Description", "StartLine", "EndLine", "StartColumn", "EndColumn", "Match", "Secret", "File", "SymlinkFile", "Commit", "Entropy", "Author", "Email", "Date", "Message", "Fingerprint"'

jq -r '.[] | [.Repo, .RuleID, .Description, .StartLine, .EndLine, .StartColumn, .EndColumn, .Match, .Secret, .File, .SymlinkFile, .Commit, .Entropy, .Author, .Email, .Date, .Message, .Fingerprint ] | @csv' $1 
