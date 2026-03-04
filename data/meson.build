##
## SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
## SPDX-License-Identifier: GPL-3.0-or-later
##
## @file meson.build
## @brief Data meson build file
## 
## This file defines how data files are handled for the project, including:
## - installation of the desktop file
## - installation of the appdata file
## - installation of the GSettings schema
## - subinstallation of icons
##

#
# Install desktop file
#

message('Installing desktop file...')

# Translate and install our .desktop file so the Applications Menu will see it
desktop_file = i18n.merge_file (
    input: meson.project_name () + '.desktop.in',
    output: meson.project_name () + '.desktop',
    po_dir: join_paths (meson.project_source_root(), 'po', 'extra'),
    type: 'desktop',
    install: true,
    install_dir: join_paths (get_option ('datadir'), 'applications'),
    install_tag: 'applications'
)

desktop_utils = find_program('desktop-file-validate', required: false)
if desktop_utils.found()
  test('Validate desktop file', desktop_utils, args: [desktop_file])
endif

message('Installed desktop file\n')


#
# Install appdata
#
message('Installing appdata...')

i18n = import ('i18n')

# Translate and install our .appdata.xml file so AppCenter will see it
appstream_file = i18n.merge_file (
    input: meson.project_name () + '.appdata.xml.in',
    output: meson.project_name () + '.appdata.xml',
    po_dir: join_paths (meson.project_source_root(), 'po', 'extra'),
    install: true,
    install_dir: join_paths (get_option ('datadir'), 'metainfo'),
    install_tag: 'metainfo'
)

appstream_util = find_program('appstream-util', required: false)
if appstream_util.found()
  test('Validate appstream file', appstream_util, args: ['validate', appstream_file])
endif

message('Installed appdata\n')


#
# Install schema
#
message('Installing schema...')

schemas_dir = join_paths (get_option('prefix'), get_option('datadir'), 'glib-2.0', 'schemas')
glib_compile_schemas = find_program('glib-compile-schemas')

settings_schemas = [ meson.project_name() + '.gschema.xml' ]
fs_mod = import('fs')

# Export schema XML to the build tree.
exported_schema = fs_mod.copyfile(settings_schemas[0], settings_schemas[0])

# Compile schemas in the build tree so local debug runs work without install.
custom_target(
    'export-and-compile-local-schemas',
    output: 'gschemas.compiled',
    command: [
        glib_compile_schemas,
        '--strict',
        '--targetdir',
        meson.current_build_dir(),
        meson.current_build_dir()
    ],
    depends: exported_schema,
    build_by_default: true
)

install_data(settings_schemas, install_dir: schemas_dir)

meson.add_install_script (
    glib_compile_schemas,
    schemas_dir,
    install_tag: 'schemas'
)


message('Installed schema\n')

subdir('icons')
