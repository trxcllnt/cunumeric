#! /usr/bin/env bash

git config --global codespaces-theme.hide-status 1;
git config --global devcontainers-theme.hide-status 1;
git config --global devcontainers-theme.show-dirty 0;

if [[ -z "$(git config --get user.name)" ]]; then
    . /opt/devcontainer/bin/init-github-cli.sh || exit $?;
    git_user_name="$(gh api user --jq '.name')";
    if [[ -z $git_user_name ]]; then
        read -p "Git user.name: " git_user_name </dev/tty;
    fi
    git config --global user.name "${git_user_name:-anon}";
fi

if [[ -z "$(git config --get user.email)" ]]; then
    . /opt/devcontainer/bin/init-github-cli.sh || exit $?;
    git_user_email="$(gh api user/emails --jq '. | map(select(.primary == true)) | map(.email)[]')";
    if [[ -z $git_user_email ]]; then
        read -p "Git user.email: " git_user_email </dev/tty;
    fi
    git config --global user.email "${git_user_email:-users.noreply.github.com}";
fi
