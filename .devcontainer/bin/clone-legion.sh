#! /usr/bin/env bash

if [[ ! -f "$HOME/legion/CMakeLists.txt" ]]; then
    clone-gitlab-repo "StanfordLegion" "legion";
fi
