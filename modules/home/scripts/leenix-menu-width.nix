{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-menu-width";

      runtimeInputs = with pkgs; [
        python3
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Calculate a content-sized Walker width from newline-separated menu labels (stdin)

        # leenix:hidden=true

        # Reads the exact labels that will be passed to Walker (one per line) and
        # prints a pixel width for `--width`. The width is driven by the LONGEST
        # displayed label:
        #   - wcwidth-style cell model (stdlib unicodedata): combining -> 0,
        #     Nerd Font PUA icons and CJK wide -> 2 cells, else 1 cell.
        #   - JetBrainsMono Nerd Font @ 18px monospace advance ~0.6em -> 11px/cell.
        #   - PUA icons count as 2 cells (~22px) since Nerd Font glyphs render at
        #     ~1em, wider than the text advance.
        #   - Chrome: box-wrapper padding (40) + item pad-left (14) + icon margin
        #     (14) + breathing (2) = 70.
        # Bounds: MIN 200 (short menus stay intentional), MAX 640 (aligned with
        # the leenix-menu Scroll max-content-width).
        #
        # Walker applies --width as a GTK width-request (a floor); the window may
        # grow to fit content up to the Scroll's max-content-width (640), so the
        # MAX here matches that cap.

        exec ${pkgs.python3}/bin/python3 -c '
import sys, unicodedata

def cell(ch):
    cp = ord(ch)
    if unicodedata.combining(ch):
        return 0
    if 0xE000 <= cp <= 0xF8FF or cp >= 0xF0000:
        return 2
    if unicodedata.east_asian_width(ch) in ("W", "F"):
        return 2
    return 1

MINW, MAXW, CELL_PX, CHROME = 200, 640, 11, 70

lines = sys.stdin.read().split("\n")
longest = 0
for line in lines:
    c = sum(cell(ch) for ch in line)
    if c > longest:
        longest = c

w = longest * CELL_PX + CHROME
w = max(MINW, min(MAXW, w))
print(w)
'
      '';
    })
  ];
}
