# Generate Country and Language translations
#
# Country-specific translations (regional variants or extra locale data)
# live under `po/countries/` and are kept separate from the main `po/` 
# directory to modularize the translation process by Weblate components.
#
#     meson compile -C builddir countries-pot
#
# Notes on options used:
# - `--directory` sets the base directory to the project root for tools.
# - `--from-code=UTF-8` enforces UTF-8 encoding for source .po files.
# - `--no-location` omits source-file locations in generated message catalogs.
#


message('Country translation extraction...')

i18n.gettext ('countries',
    args: [
        '--directory=' + meson.project_source_root(),
        '--from-code=UTF-8',
        '--no-location',
        '-cTRANSLATORS'
    ],
    install: false
)
