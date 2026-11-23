#!/bin/sh
# StopFailure hook, matcher rate_limit: when a turn ends on a usage or spend
# limit, continue the session on another account (see cc-handover).
#
# It leaves the session alone when it is not an interactive one in tmux, when
# no other account has room, and when it was already moved in the last few
# minutes. That last case means a limit the usage numbers do not show, such as
# an org spend limit, and moving again would bounce between accounts forever.
[ -n "${TMUX_PANE:-}" ] || exit 0
# A headless run (claude -p) inherits the pane of whatever started it.
[ "${CLAUDE_CODE_ENTRYPOINT:-}" = cli ] || exit 0
sid=$(jq -r '.session_id // empty')
[ -n "$sid" ] || exit 0

stamps=${TMPDIR:-/tmp}/cc-handover-on-limit
mkdir -p "$stamps"
[ -z "$(find "$stamps" -name "$sid" -mmin -5)" ] || exit 0

bin=$HOME/.local/bin
target=$("$bin/cc-usage" --best --not "${CLAUDE_CONFIG_DIR:-$HOME/.claude}")
[ -n "$target" ] || exit 0
touch "$stamps/$sid"
CLAUDE_CODE_SESSION_ID=$sid "$bin/cc-handover" "$(cat "$target/account-label")" continue
