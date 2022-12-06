#! /usr/bin/env bash

if [[ ! -f /workspaces/legate.core/scripts/generate-conda-envs.py ]]; then

    GHHOSTS="$HOME/.config/gh/hosts.yml";

    if [[ ! -f "$GHHOSTS" ]]; then gh auth login; fi

    GH_USER="$(grep --color=never 'user:' "$GHHOSTS" | cut -d ':' -f2 | tr -d '[:space:]')";

    if [[ -z "$GH_USER" ]]; then
        exit 1;
    fi

    REPO="$GH_USER/legate.core";
    FORK="$(gh repo list $GH_USER --fork --json name --jq ". | map(select(.name == \"legate.core\")) | map(.name)[]")";

    if [[ ! "$FORK" ]]; then
        UPSTREAM="nv-legate/legate.core";
        ORIGIN_URL="github.com/$GH_USER/legate.core";
        UPSTREAM_URL="github.com/$UPSTREAM";

        while true; do

            read -p "\`$UPSTREAM_URL\` not found.
Fork \`$UPSTREAM_URL\` into \`$ORIGIN_URL\` now (y/n)? " CHOICE </dev/tty

            case $CHOICE in
                [Nn]* ) REPO="$UPSTREAM"; break;;
                [Yy]* ) gh repo fork "$UPSTREAM" --clone=false; break;;
                * ) echo "Please answer 'y' or 'n'";;
            esac
        done;
    fi

    gh repo clone "$REPO" /workspaces/legate.core;
fi
