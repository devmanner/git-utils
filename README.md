# git-utils
Some git scripts of random quality. Yes, it's very Azure specific... but that was what I needed for the time being... 

## azure_*.sh scripts

Wrote them to clone all azure repos (if you happen to come across a PAT-token...) into a folder structure with PROJECT/REPO.

## Process for getting creds from repo into excel

Scan all the repos I can found in the durrent directory tree (maybe you cloned that with azure_clone_all.sh) with:

    $ bin/gitleaks_all.sh

This will produce gitleak JSON output files for each repo with the name:

    REPO_NAME.gitleaks.log

Merge all these files to one using:

    $ bin/gitleaks_add_repo.sh | jq -s '.' > all.json

Convert these to CSV (since stakeholders like excel) using:

    $ bin/gitleaks_json_to_excel.sh all.json > all.csv
