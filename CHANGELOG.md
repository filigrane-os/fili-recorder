# Changelog

## v0.3.1 (2026-11-23)

- The interface controls come from the shared kit `fili-ui` (v0.3.0) instead of local copies: theme, focus ring, kinetic scroll, window glyph, buttons, menu, drop-down choice, window panel, debug panel and Lia button. The look is the same; the three drop-downs of the Record page are the kit's (26 px high).
- `scripts/check-i18n.py` (run by `make test`) checks the French catalog against the texts of the code and of the kit; one missing text added, three unused ones removed.

## v0.3.0 (2026-11-22)

- The assistant is now named Lia: the header button and the menu entry say "Ask Lia", and the hidden brief is `shell/lia/<app_id>.md` (the older `rob/` is still read).
- A catalog of the commands of the window (`shell/ctl/<app_id>.json`, `fili-api show`) that follows the shared format; the assistant is driven by `fili-ai` as one client of the Filigrane contracts.

## v0.2.0 (2026-11-21)

- Everything Cassette brings to the desktop now lives in this repository and is installed with it (`make install`): the launcher (`data/fili-recorder.desktop`), the icon, and what the Filigrane shell reads, in `shell/`, instead of being kept in the distribution's repository: the `recorder` module of the fili-bar (`shell/fili-bar/recorder/`, with its French translations), the fallback menu of the bar (`shell/appmenu/fili-recorder.json`) and the brief of Rob for this application (`shell/rob/fili-recorder.md`). The package puts it in `/usr/share/filigrane/shell/`, `fili-bar link-system` (run at login) links it into the bar and the menus; a module, menu or brief of your own with the same name wins.
- A `Makefile` (`build`, `test`, `install`, `install-data`, `uninstall`); the CI runs `make build test`.
- `scripts/check-shell-menu.py` (run by `make test`) checks that the bar menu agrees with the actions and shortcuts of the window, and that the brief of Rob exists.

## v0.1.0 (2026-11-19)

First version in its own repository (it lived in `apps/fili-recorder` of filigrane-os/filigrane until then).

- Recording of an input and an output (mixed or separate), Opus / MP3 / WAV, playback, library, menu for the fili-bar
  driven by `fili-recorder ctl`, Debug panel.
- French catalog of the application now in `i18n/fr.json` (it was the shell's catalog).
