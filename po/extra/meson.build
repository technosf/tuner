# Install metadata translations
#
# Metadata translations used by Flatpak and other packaging systems
# live under `po/extra/` and are kept separate from the main `po/` 
# catalogs to modularize the translation process by Weblate components.
#
#     meson compile -C builddir extra-pot
#
# Notes on options used:
# - `--directory` sets the base directory to the project root for tools.
# - `--from-code=UTF-8` enforces UTF-8 encoding for source .po files.
# - `--no-location` omits source-file locations in generated message catalogs.
#

message('Extra translations...')

i18n.gettext ('extra',
    args: [
        '--directory=' + meson.project_source_root(),
        '--from-code=UTF-8',
        '--no-location',
        '-cTRANSLATORS'
    ],
    install: false
)
