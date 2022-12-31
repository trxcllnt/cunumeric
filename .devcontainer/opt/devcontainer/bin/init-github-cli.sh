#! /usr/bin/env bash

if [[ "${CODESPACES:-false}" == true ]]; then
    gh config set git_protocol https;
fi

if [[ $(gh auth status &>/dev/null; echo $?) != 0 ]]; then
    if [[ -n "$GH_TOKEN" ]]; then
        GITHUB_TOKEN= gh auth login --web --scopes user:email;
    else
        gh auth login --web --scopes user:email;
    fi
    gh auth setup-git --hostname github.com;
fi

if [[ -z "$GITHUB_USER" ]]; then
    if [[ -f ~/.config/gh/hosts.yml ]]; then
        GITHUB_USER="$(grep --color=never 'user:' ~/.config/gh/hosts.yml | cut -d ':' -f2 | tr -d '[:space:]' || echo '')";
    fi
fi

if [[ -z "$GITHUB_USER" ]]; then
    GITHUB_USER="$(gh api user --jq '.login')";
fi

if [[ -z "$GITHUB_USER" ]]; then
    exit 1;
fi

export GITHUB_USER;
