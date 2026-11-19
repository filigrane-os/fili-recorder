# Cassette (fili-recorder)

The sound recorder and player of Filigrane: a Qt Quick window (Rust, cxx-qt) like Casier. It records an input (microphone)
and an output (what the speakers play), each one optional, so a call or a meeting is recorded whole, and plays the
recordings back. It only listens, the sound itself is never touched.

- Two modes: **Recordings** (list by date and kind, search, play / pause, previous / next, seek, rename, trash) and **Record** (choose the input and the output, one mixed file or one per source, start / stop).
- Opus (default, about 29 MB an hour), MP3 or WAV; compression with GStreamer and lame at the end of the recording.
- Sound through PipeWire (`pw-record`, `pw-cat`); no resident process.
- Command line: `fili-recorder start | stop | toggle | status | set ... | folder` (also available as `cassette`).
- Menu in the fili-bar (`dotfiles/config/filigrane/appmenu/fili-recorder.json`) driven by `fili-recorder ctl --pid PID action NAME`.

Files go to `~/Music/Recordings` (`dir` in `~/.config/filigrane/fili-recorder.toml`).

## Build

```
QMAKE=/usr/lib/qt6/bin/qmake6 cargo build --release
```

Lives in filigrane-os/fili-recorder; the Filigrane distribution pins a tag (`apps/fili-recorder/upstream`). The fili-bar
menu, the `recorder` bar module, the launcher entry and the icon of the launcher stay in filigrane-os/filigrane. The
parity tests that compare the theme with the shell run with `FILI_SHELL_DIR=<filigrane>/dotfiles/config/quickshell cargo test`
and are skipped without it.
