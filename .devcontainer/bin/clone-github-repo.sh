#! /usr/bin/env bash

if [[ $(gh auth status &>/dev/null; echo $?) != 0 ]]; then
    gh auth login -p ssh --web;
fi

if [[ -z "$GITHUB_USER" ]]; then
    if [[ -f "$HOME/.config/gh/hosts.yml" ]]; then
        GITHUB_USER="$(grep --color=never 'user:' "$HOME/.config/gh/hosts.yml" | cut -d ':' -f2 | tr -d '[:space:]' || echo '')";
    fi
fi

if [[ -z "$GITHUB_USER" ]]; then
    exit 1;
fi

NAME="$2";
UPSTREAM="$1/$NAME";
REPO="$GITHUB_USER/$NAME";
FORK="$(gh repo list $GITHUB_USER --fork --json name --jq ". | map(select(.name == \"$NAME\")) | map(.name)[]")";

if [[ ! "$FORK" ]]; then
    ORIGIN_URL="github.com/$REPO";
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

gh repo clone "$REPO" "$HOME/$NAME";
