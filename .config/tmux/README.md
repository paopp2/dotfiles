# tmux helpers

`session-number.sh` numbers sessions from 1 in tmux's session-name order.
The status bar passes shell-escaped socket and session IDs to it.

## Live session overview

`Ctrl+e`, then `v` opens tmux-expose with live previews, including the originating
session. The upstream version freezes that session. The local patch adds
`--live-current-session`, intended only for popup mode (running it directly in
a pane can capture the overview itself).

Restore the patched executable with an installed Rust toolchain version 1.88
or newer. This setup was tested with Rust 1.95.0:

```sh
git clone https://github.com/cesarferreira/tmux.expose.git ~/.tmux/plugins/tmux.expose
cd ~/.tmux/plugins/tmux.expose
git checkout 18ca9885a29ab5f674c64e27373c5f068b6657a2
git apply ~/.config/tmux/expose-live-current-session.patch
cargo +1.95.0 test --locked
cargo +1.95.0 install --path . --locked
```

These restore commands assume the plugin directory does not already exist.
The tmux config launches the executable directly because the upstream plugin
launcher fails on macOS's bundled Bash. Reinstalling from crates.io replaces
the patched executable and removes the custom flag.
