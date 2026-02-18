# Generate Application translations
#
# Application translations (regional variants or extra locale data)
# live under `po/application/` and are kept separate from the main `po/` 
# directory to modularize the translation process by Weblate components.
#
#     meson compile -C builddir application-pot
#
# Notes on options used:
# - `--directory` sets the base directory to the project root for tools.
# - `--from-code=UTF-8` enforces UTF-8 encoding for source .po files.
# - `--no-location` omits source-file locations in generated message catalogs.
#


message('Application translation extraction...')

i18n.gettext ('application',
    args: [
        '--directory=' + meson.project_source_root(),
        '--from-code=UTF-8',
        '--no-location',
        '-cTRANSLATORS'
    ],
    install: false
)
