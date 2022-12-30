#! /usr/bin/env bash

if [ ! -d "/workspaces/legion/.git" ]; then
    clone-gitlab-repo "StanfordLegion" "legion";
fi
