#
# po/meson.build
#

msgcat = find_program('msgcat')
msgfmt = find_program('msgfmt')

pkg = meson.project_name()

linguas = run_command('cat', 'LINGUAS', check: true).stdout().strip().split('\n')

install_targets = []

foreach lang : linguas

  merged_po = custom_target(
    'merged-po-' + lang,
    input: [
      join_paths('application', lang + '.po'),
      join_paths('countries',   lang + '.po'),
    ],
    output: 'merged-' + lang + '.po',
    command: [ msgcat, '@INPUT@', '-o', '@OUTPUT@' ],
  )
  translations = [merged_po]

  translations += custom_target('translation-' + lang,
    input: merged_po,
    output: pkg + '.' + lang + '.mo',
    command: [
        find_program('msgfmt'),
        '-c',  # check for format string issues
        '-v',  # verbose output
        '@INPUT@',
        '-o', '@OUTPUT@'
    ],
    build_by_default: true,
    install: true,
    install_dir: join_paths(get_option('localedir'), lang, 'LC_MESSAGES')
)

endforeach
