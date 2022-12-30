#! /usr/bin/env bash

generate_conda_envs_py="legate/scripts/generate-conda-envs.py";

if [ ! -d "/workspaces/legate/.git" ]; then
    clone-github-repo "nv-legate" "legate.core" "legate";
fi

if [[ ! -f "/workspaces/$generate_conda_envs_py" ]]; then
    default_branch="$(\
        gh repo list nv-legate \
            --json name --json defaultBranchRef \
            --jq '. | map(select(.name == "legate.core")) | map(.defaultBranchRef.name)[]' \
        )";
    >&2 echo ">> $generate_conda_envs_py not found";
    >&2 echo ">> switching to branch '$default_branch'";
    (
        cd "/workspaces/legate" && git fetch upstream && git checkout "$default_branch";
    )
fi
