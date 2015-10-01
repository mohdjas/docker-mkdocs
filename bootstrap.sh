#!/bin/bash

MKDOCS_HOME=/mkdocs

if [[ -d $MKDOCS_HOME ]]; then
    MKDOCS_UID=1001
    MKDOCS_GID=1001
    MKDOCS_USER=mkdocs

    echo "Bind mount $MKDOCS_HOME found."
    MKDOCS_UID=$(ls -nd $MKDOCS_HOME | awk '{ print $3 }')
    MKDOCS_GID=$(ls -nd $MKDOCS_HOME | awk '{ print $4 }')

    # set up mkdocs user to have same user as owner of the bind mount
    addgroup --gid $MKDOCS_GID $MKDOCS_USER &> /dev/null
    adduser --uid $MKDOCS_UID --gid $MKDOCS_GID $MKDOCS_USER --home $MKDOCS_HOME --no-create-home --disabled-password --gecos '' &> /dev/null
    su - $MKDOCS_USER -c "cd $MKDOCS_HOME; mkdocs serve --dev-addr=0.0.0.0:8000"
else
    cat <<USAGE
Docker mkdocs container.  This container has one mode of operation:
- Generate the site in a mounted volume.  To trigger this behavior, just mount
a 'mkdocs' compatible site source to /mkdocs (i.e. '-v \`pwd\`:/mkdocs').
USAGE
    exit
fi