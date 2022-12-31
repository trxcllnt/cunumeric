#! /usr/bin/env bash

generate_conda_envs_py="legate/scripts/generate-conda-envs.py";

if [[ ! -d ~/legate/.git ]]; then
    /opt/devcontainer/bin/clone-github-repo.sh "nv-legate" "legate.core" "legate";
fi

if [[ ! -f ~/$generate_conda_envs_py ]]; then
    default_branch="$(\
        gh repo list nv-legate \
            --json name --json defaultBranchRef \
            --jq '. | map(select(.name == "legate.core")) | map(.defaultBranchRef.name)[]' \
        )";
    >&2 echo ">> ~/$generate_conda_envs_py not found";
    >&2 echo ">> switching to branch '$default_branch'";
    (
        cd ~/legate && git fetch upstream && git checkout "$default_branch";
    )
fi
