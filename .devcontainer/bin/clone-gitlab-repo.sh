#! /usr/bin/env bash

set -x;

if [[ $(glab auth status &>/dev/null; echo $?) != 0 ]]; then
    glab auth login --hostname gitlab.com;
fi

if [[ -z "$GITLAB_USER" ]]; then
    if [[ -f "$HOME/.config/glab-cli/config.yml" ]]; then
        GITLAB_USER="$(grep --color=never 'user:' "$HOME/.config/glab-cli/config.yml" | cut -d ':' -f2 | tr -d '[:space:]' || echo '')";
    fi
fi

if [[ -z "$GITLAB_USER" ]]; then
    exit 1;
fi

NAME="$2";
UPSTREAM="$1/$NAME";
REPO="$GITLAB_USER/$NAME";
FORK="$(glab repo view "$REPO" &>/dev/null; if [ $? -eq 0 ]; then echo "$REPO"; fi;)";

if [[ -z "$FORK" ]]; then
    ORIGIN_URL="gitlab.com/$REPO";
    UPSTREAM_URL="gitlab.com/$UPSTREAM";

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

if [ ! -d "/workspaces/${3:-$NAME}/.git" ]; then
    glab repo clone "$REPO" "/workspaces/${3:-$NAME}";
fi
