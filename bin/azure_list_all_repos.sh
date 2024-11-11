#!/opt/homebrew/bin/bash

PAT_FILE=~/.azure_pat_access_token

if [ ! -f $PAT_FILE ]; then
    echo "You need a PAT (Personal Access Token) stored in $PAT_FILE"
    exit -1
fi

PAT=$(cat $PAT_FILE)

if [ $# != 2 ]; then
    echo "Usage: $0 username organization"
    exit -1
fi

USER=$1
ORG=$2

HEADER='-H "Content-Type: application/json"'

CURL="curl -s -u $USER:$PAT $HEADER"

LIST_PROJS="https://dev.azure.com/$ORG/_apis/projects?api-version=2.0"

$CURL $LIST_PROJS | jq -r '.value[].name' | while read -r p; do
    proj=$(printf %s "$p" | jq -sRr @uri)
    LIST_REPOS="https://dev.azure.com/$ORG/$proj/_apis/git/repositories?api-version=7.0"
    for repo in $($CURL $LIST_REPOS | jq -r '.value[].sshUrl'); do
        echo $repo
    done
done

