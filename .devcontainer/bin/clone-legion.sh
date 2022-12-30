#! /usr/bin/env bash

set -x;

if [[ ! -d "/workspaces/legion/.git" ]]; then
    clone-gitlab-repo "StanfordLegion" "legion";
fi
