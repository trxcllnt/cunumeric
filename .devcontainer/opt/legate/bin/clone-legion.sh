#! /usr/bin/env bash

if [[ ! -d ~/legion/.git ]]; then
    /opt/legate/bin/clone-gitlab-repo.sh "StanfordLegion" "legion";
fi
