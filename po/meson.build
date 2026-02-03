#
# PO meson build file
#
# This file defines how translations are handled for the project.
# High-level responsibilities:
# - include additional translation subdirectories
# - optionally generate a POT template (when updating translations)
# - compile .po files into .mo files and install them to the locale dir
# - call Meson's i18n helper to gather and validate gettext resources
#

message('Installing translations...')

# Generate POT file if the build config `translation` option is set to 'update'
# This is intended for translators or snapshot builds where we need
# to extract strings into a .pot template using xgettext.
if get_option('translation') == 'update'

    message('Updating Project POT file...')

    pot = custom_target('pot',
        input: 'POTFILES',
        output: meson.project_name() + '.pot',
        command: [
            # xgettext scans source files (Vala in this project) listed in POTFILES
            # and produces a .pot catalog containing all translatable strings.
            'xgettext',
            '--language=Vala',
            '--files-from=@INPUT@',
            '--output=' + meson.current_source_dir() + '/' + meson.project_name() + '.pot',
            '--from-code=UTF-8',
            '--package-name=' + meson.project_name(),
            '--package-version=' + meson.project_version(),
            # Keywords used in source for marking translatable strings
            '--keyword=_',
            '--keyword=N_',
            '--keyword=C_:1c,2',
            '--keyword=NC_:1c,2',
            '--add-comments=TRANSLATORS',
            '--sort-output',
            '--width=80',
            '--foreign-user',
            # Make sure xgettext runs with project root as base dir
            '--directory=' + meson.project_source_root(),
        ]
    )

    # Make the POT target a dependency for translation-related build steps.
    # This ensures translators can regenerate the .pot before updating .po files.
    translations = [pot]
else

    message('POT generation skipped.')
    # No POT generation; start with an empty list of translation targets
    translations = []
endif

message('Merging PO files...')
# Process each language listed in `LINGUAS`
# For each entry we check for a corresponding `<lang>.po` and, if present,
# create a custom target that runs `msgfmt` to produce a binary `.mo` file.
foreach lang : run_command('cat', 'LINGUAS', check: true).stdout().strip().split('\n')
    message('Processing translation for language: ' + lang)
    po_file = lang + '.po'

    if run_command('test', '-f', po_file, check: false).returncode() == 0

        merged_po = custom_target(
            'merge-po-' + lang,
            input: [
                po_file,
                'countries/' + po_file,
            ],
            output: 'merged-' + po_file,
            command: [
                find_program('msgcat'), 
                '@INPUT@', 
                '-o', '@OUTPUT@'
            ],
        )

        message('Merged translation: merged-' + po_file)

        translations += custom_target('translation-' + lang,
            input: merged_po,
            output: lang + '.mo',
            command: [
                # Use msgfmt to validate and compile the .po into an .mo
                find_program('msgfmt'),
                '-c',  # check for printf/format string mismatches
                '-v',  # verbose output helps during debugging
                '--statistics',
                '@INPUT@',
                '-o', '@OUTPUT@'
            ],
            # Build these by default so `ninja` will compile them unless asked not to
            build_by_default: true,
            # Install the resulting .mo files into the configured locale directory
            install: true,
            install_dir: join_paths(get_option('localedir'), lang, 'LC_MESSAGES')
        )

    endif
endforeach


message('Scanning gettext resources...') 
# Let Meson/i18n scan and register gettext resources. The `preset: 'glib'`
# config tells Meson to use glib-style message catalogs and conventions.
# `--no-location` prevents adding source file locations to generated messages,
# and '-cTRANSLATORS' keeps translator comments from source.
i18n.gettext(meson.project_name(),
    args: [
        '--directory=' + meson.project_source_root(),
        '--from-code=UTF-8',
        '--no-location',
        '-cTRANSLATORS'
    ],
    preset: 'glib'
)

# - `countries/` contains country-specific translations and data
subdir('countries')# Include additional translation sources in subdirs

# - `extra/` can contain supplementary .po files or helper data
subdir('extra')

message('Installed translations')
