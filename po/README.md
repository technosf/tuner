<!--
SPDX-FileCopyrightText: © 2026 <https://github.com/technosf>

SPDX-License-Identifier: GPL-3.0-or-later
-->

# Translations (Portable Objects)

This document explains how translation targets in `po/` are generated, what each build step produces, and the recommended command order for common tasks. ✅

---

## Overview 🔧

- `po/` holds the project's translation build file and the subdirectories that hold the actual generated translated material which is installed by default
- `po/application/` contains the application translatable strings, catalog and linguas. They are not installed by default, but combined with other translations into `po`.
- `po/countries/` contains country and language names, catalog and linguas. They are not installed by default.
- `po/extra/` contains metadata catalog and linguas. They are not installed by default, but combined with other translations into `po`.
- The translated `.po` files in `application`, `countries` and `extra` are provided by _Weblate_ via _git_ pull requests.
- 
- Main actions in the Meson build: generate a `.pot` template (optional), compile `.po` files to binary `.mo` files, and install `.mo` files into the configured `localedir`.


## Typical command sequence (recommended) ▶️

1. Configure or prepare the build dir (if not already done):

   ```bash
   meson setup builddir -Dtranslation=update
   ```

   `setup` will fire a 

2. (Optional) Generate the POT template (only when updating strings):

   ```bash
   # Enable POT generation via Meson option, then run the pot target
   meson configure builddir -Dtranslation=update
   ninja -C builddir pot
   # Output: builddir/<project>.pot (contains extracted translatable strings)
   ```

3. Compile translations (.po → .mo):

   ```bash
   # Build all default targets (translations are built_by_default)
   ninja -C builddir
   # Or compile a specific language and show verbose command output
   ninja -C builddir -v translation-<lang>
   # Output: builddir/<lang>.mo
   ```

4. (Optional) Install compiled translations to `localedir`:

   ```bash
   # Installs the .mo files into the configured localedir (e.g. /usr/share/locale/<lang>/LC_MESSAGES/)
   ninja -C builddir install
   ```

Notes:
- Each translation target uses `msgfmt -c -v` to validate and compile `.po` files; `-v` prints validation output (warnings/errors). Use `ninja -v` to see command stdout/stderr.
- The `pot` target runs `xgettext` and produces a `.pot` file when `-Dtranslation=update` is set.

## Country catalogs (po/countries/) 🇺🇳

- These are registered via a separate gettext domain named `countries`.
- They are **not installed** by default (`install: false`). To include/install them you can:
  - Change `install: false` → `install: true` in `po/countries/meson.build`, or
  - Add `po/countries` as an `extra_po_dirs` to the main i18n call in `po/meson.build`.

## Debugging & troubleshooting ⚠️

- Missing tools: install the `gettext` package for your OS.
- No output for a language: ensure `po/LINGUAS` lists the language and `po/<lang>.po` exists.
- Check Meson's log: `builddir/meson-logs/meson-log.txt` for configure-time issues.
- To get more verbose Meson output: use `meson setup --log-level=debug` or consult `meson --help`.

---
