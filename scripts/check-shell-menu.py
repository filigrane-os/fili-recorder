#!/usr/bin/env python3
"""The fili-bar menu of Cassette (shell/appmenu/fili-recorder.json) stays in agreement with the window (qml/Main.qml): every
`fili-recorder ctl --pid %pid action NAME` of the menu is an action of the window, every action of the window is in the menu
(the few that have none are listed below), every announced shortcut has its `Shortcut` in the window, and the brief of Lia
(shell/lia/fili-recorder.md) exists. Usage: scripts/check-shell-menu.py (from anywhere)."""
import json, pathlib, re, sys

root = pathlib.Path(__file__).resolve().parents[1]
menu = json.loads((root / "shell/appmenu/fili-recorder.json").read_text())
qml = (root / "qml/Main.qml").read_text()
actions = set(re.findall(r'^\s+"([a-z-]+)": \{ on:', qml, re.M))
shortcuts = set(re.findall(r'Shortcut \{ sequence: "([^"]+)"', qml)) | set(re.findall(r'sequence: "([^"]+)"', qml))
# Actions reachable only from the interface (context menu of a row)
# Test hooks for the attention colours (ctl only): not commands of the user
without_menu = {"attention", "attention-clear"}
errors = []
if not (root / "shell/lia/fili-recorder.md").is_file():
    errors.append("brief of Lia missing: shell/lia/fili-recorder.md")

def entries(items):
    for e in items:
        if "children" in e:
            yield from entries(e["children"])
        elif not e.get("sep"):
            yield e

everything = list(entries(menu["app"] + menu["window"] + [m for top in menu["menus"] for m in top["children"]]))
used = set()
for e in everything:
    m = re.fullmatch(r"fili-recorder ctl --pid %pid action ([a-z-]+)", e.get("exec", ""))
    if not m or m.group(1) not in actions:
        errors.append(f"command without an action in Main.qml: {e.get('exec')}")
    else:
        used.add(m.group(1))
    k = e.get("keys")
    if k and k not in shortcuts:
        errors.append(f"shortcut without a Shortcut in Main.qml: {k}")
for a in sorted(actions - used - without_menu):
    errors.append(f"action of Main.qml missing from the menu: {a}")
if errors:
    print("not ok - menu of Cassette:")
    print("\n".join("#   " + e for e in errors))
    sys.exit(1)
print("ok - menu of Cassette agrees with Main.qml (%d actions)" % len(actions))
