# Changelog

## v0.2.0 (2026-11-21)

- Everything Cassette brings to the desktop now lives in this repository and is installed with it (`make install`): the launcher (`data/fili-recorder.desktop`), the icon, and what the Filigrane shell reads, in `shell/`, instead of being kept in the distribution's repository: the `recorder` module of the fili-bar (`shell/fili-bar/recorder/`, with its French translations), the fallback menu of the bar (`shell/appmenu/fili-recorder.json`) and the brief of Rob for this application (`shell/rob/fili-recorder.md`). The package puts it in `/usr/share/filigrane/shell/`, `fili-bar link-system` (run at login) links it into the bar and the menus; a module, menu or brief of your own with the same name wins.
- A `Makefile` (`build`, `test`, `install`, `install-data`, `uninstall`); the CI runs `make build test`.
- `scripts/check-shell-menu.py` (run by `make test`) checks that the bar menu agrees with the actions and shortcuts of the window, and that the brief of Rob exists.

## v0.1.0 (2026-11-19)

First version in its own repository (it lived in `apps/fili-recorder` of filigrane-os/filigrane until then).

- Recording of an input and an output (mixed or separate), Opus / MP3 / WAV, playback, library, menu for the fili-bar
  driven by `fili-recorder ctl`, Debug panel.
- French catalog of the application now in `i18n/fr.json` (it was the shell's catalog).
