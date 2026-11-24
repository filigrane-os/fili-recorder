# Cassette (fili-recorder): build and install.
#
#   make                       build the release binary
#   make test                  unit tests and the check of the bar menu
#   sudo make install          install under /usr/local (PREFIX=/usr for a system package)
#   make install DESTDIR=pkg PREFIX=/usr      stage into a directory (packagers)
#   make install-data PREFIX=~/.local         everything but the binary (launcher, icon, licences, what the shell reads)
#
# Everything the application brings to the Filigrane desktop lives here and is installed together: the program, the launcher,
# the icon, and shell/ (the module of the fili-bar, the fallback menu of the bar, the brief of Lia), which ends in
# $(DATADIR)/filigrane/shell/ where `fili-bar link-system` finds it.
#
# cxx-qt finds Qt through qmake. QMAKE overrides the search below (Qt 6 only), for example
#   make QMAKE=/opt/qt6/bin/qmake6
PREFIX ?= /usr/local
DESTDIR ?=
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share
CARGO ?= cargo
TARGET_DIR ?= $(if $(CARGO_TARGET_DIR),$(CARGO_TARGET_DIR),target)
QMAKE ?= $(firstword $(wildcard /usr/lib/qt6/bin/qmake6 /usr/lib64/qt6/bin/qmake6 /usr/lib/qt6/bin/qmake /usr/lib64/qt6/bin/qmake) $(shell command -v qmake6 qmake-qt6 2>/dev/null))
export QMAKE

.PHONY: all build dev run test install install-data uninstall

all: build

build:
	$(CARGO) build --release --locked

test:
	$(CARGO) test --release --locked
	python3 -I scripts/check-i18n.py
	python3 -I scripts/check-shell-menu.py
	python3 -I scripts/fili-api-lint --app .

install: build install-data
	install -Dm755 $(TARGET_DIR)/release/fili-recorder $(DESTDIR)$(BINDIR)/fili-recorder
	ln -sf fili-recorder $(DESTDIR)$(BINDIR)/cassette

install-data:
	install -Dm644 data/fili-recorder.desktop $(DESTDIR)$(DATADIR)/applications/fili-recorder.desktop
	install -Dm644 icons/fili-recorder.svg $(DESTDIR)$(DATADIR)/icons/hicolor/scalable/apps/fili-recorder.svg
	install -Dm644 LICENSE $(DESTDIR)$(DATADIR)/licenses/fili-recorder/LICENSE
	for f in licenses/*; do install -Dm644 $$f $(DESTDIR)$(DATADIR)/licenses/fili-recorder/$$(basename $$f); done
	mkdir -p $(DESTDIR)$(DATADIR)/filigrane/shell
	cp -r shell/. $(DESTDIR)$(DATADIR)/filigrane/shell/

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/fili-recorder $(DESTDIR)$(BINDIR)/cassette
	rm -f $(DESTDIR)$(DATADIR)/applications/fili-recorder.desktop
	rm -f $(DESTDIR)$(DATADIR)/icons/hicolor/scalable/apps/fili-recorder.svg
	rm -rf $(DESTDIR)$(DATADIR)/licenses/fili-recorder
	rm -rf $(DESTDIR)$(DATADIR)/filigrane/shell/fili-bar/recorder
	rm -f $(DESTDIR)$(DATADIR)/filigrane/shell/ctl/fili-recorder.json $(DESTDIR)$(DATADIR)/filigrane/shell/appmenu/fili-recorder.json $(DESTDIR)$(DATADIR)/filigrane/shell/lia/fili-recorder.md

# Development. `make dev` builds without link-time optimisation (target/fast); `make run` starts that build with the QML read from the source folders (this one and ../fili-ui),
# so after a change of a .qml file just run it again, no build. `make run ARGS=...`.
FILI_UI ?= ../fili-ui

dev:
	$(CARGO) build --profile fast

run:
	@test -x $(TARGET_DIR)/fast/fili-recorder || { echo "build first (make dev)" >&2; exit 1; }
	FILI_QML_DIR=$(CURDIR)/qml FILI_UI_QML=$(abspath $(FILI_UI))/qml QT_QUICK_BACKEND=software $(TARGET_DIR)/fast/fili-recorder $(ARGS)
