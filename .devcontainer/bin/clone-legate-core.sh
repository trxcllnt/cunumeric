#! /usr/bin/env bash

generate_conda_envs_py="$HOME/legate.core/scripts/generate-conda-envs.py";

if [[ ! -f "$generate_conda_envs_py" ]]; then
    clone-github-repo "nv-legate" "legate.core";
    if [[ ! -f "$generate_conda_envs_py" ]]; then
        default_branch="$(\
            gh repo list nv-legate \
                --json name --json defaultBranchRef \
                --jq '. | map(select(.name == "legate.core")) | map(.defaultBranchRef.name)[]' \
            )";
        >&2 echo ">> legate.core/scripts/generate-conda-envs.py not found";
        >&2 echo ">> checking out legate.core branch '$default_branch'";
        (
            cd "$HOME/legate.core" && git fetch upstream && git checkout "$default_branch";
        )
    fi
fi
