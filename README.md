# git-utils
Some git scripts of random quality. Yes, it's very Azure specific... but that was what I needed for the time being... 

## Process for getting creds from repo into excel

Scan the code with:

    $ bin/azure_gitleak_all.sh

This will produce a gitleak JSON output file for each repo with the name:

    REPO_NAME.gitleaks.log

Merge all these files to one using:

    $ bin/gitleaks_add_repo.sh | jq -s '.' > all.json

Convert these to CSV (since stakeholders like excel) using:

    $ bin/gitleaks_json_to_excel.sh all.json > all.csv


