#! /usr/bin/env bash

##
# Try to reopen this vscode window to the /workspaces/workspace.code-workspace file.
##

set -ux;

_exit=0;
_file="/workspaces/workspace.code-workspace";
_code="$(echo /vscode/vscode-server/bin/linux-*/*/bin/remote-cli/code)";

# Only run if in a vscode remote containers session.
if [[ "${REMOTE_CONTAINERS:-false}" == true ]]; then
    # If the window was reloaded, multiple vscode-ipc sockets will exist.
    # Try them all until one succeeds.
    for _sock in /tmp/vscode-ipc-*.sock; do
        # This is a no-op if the current window is already showing the workspace.
        VSCODE_IPC_HOOK_CLI="$_sock" "$_code" -r "$_file" 2>/dev/null;
        _exit=$?;
        if [[ $_exit == 0 ]]; then break; fi
    done
fi

exit $_exit;
