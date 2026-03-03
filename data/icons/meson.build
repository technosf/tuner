##
## SPDX-FileCopyrightText: Copyright © 2024 technosf <https://github.com/technosf>
## SPDX-License-Identifier: GPL-3.0-or-later
##
## @file meson.build
## @brief Icon meson build file
## 
## This file defines how icon files are handled for the project
##


#
# Install icons
#
message('Installing Icons...')

#icon_sizes = ['16', '24', '32', '48', '64', '128']
# icon_sizes = ['16', '48', '128']

# foreach i : icon_sizes
#     install_data (
#         join_paths ('icons', i, meson.project_name () + '.png'),
#         install_dir: join_paths (get_option ('datadir'), 'icons','hicolor', i + 'x' + i, 'apps'),
#         install_tag: 'icons'
#     )
# endforeach

# install_data (
#     join_paths ('icons', '128', meson.project_name () + '.svg'),
#     install_dir: join_paths (get_option ('datadir'), 'icons','hicolor', 'scalable', 'apps'),
#     install_tag: 'icons'
# )

application_id = 'com.github.louis77.tuner'

scalable_dir = join_paths('hicolor', 'scalable', 'apps')
install_data(
  join_paths(scalable_dir, ('@0@.svg').format(application_id)),
  install_dir: join_paths(get_option('datadir'), 'icons', scalable_dir),
  install_tag: 'icons'
)

symbolic_dir = join_paths('hicolor', 'symbolic', 'apps')
install_data(
  join_paths(symbolic_dir, ('@0@-symbolic.svg').format(application_id)),
  install_dir: join_paths(get_option('datadir'), 'icons', symbolic_dir),
  install_tag: 'icons'
)

message('Installed icons\n')
