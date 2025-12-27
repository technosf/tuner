# ![icon](docs/logo_01.png) Develop, Build and Contribute to Tuner [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0) <!-- omit in toc -->

Discover and Listen to your favourite internet radio stations, and add improve the code!

- [Overview](#overview)
- [Tuner Development](#tuner-development)
  - [Naming Conventions](#naming-conventions)
  - [Dependencies](#dependencies)
  - [Building the Tuner App From Source](#building-the-tuner-app-from-source)
- [Valadoc](#valadoc)
  - [Building the Tuner Flatpak](#building-the-tuner-flatpak)
  - [Readying code for a Pull Request](#readying-code-for-a-pull-request)
- [Debugging](#debugging)
  - [VSCode](#vscode)
  - [Bug Introduction Deduction](#bug-introduction-deduction)
- [Release Process](#release-process)
  - [Beta Releases](#beta-releases)
  - [Production Releases](#production-releases)

## Overview

**_Tuner_** is hosted on [Github](https://github.com/tuner-app/tuner), packaged as a Flatpak and distributed by Flathub. **_Tuner_** is writen in [Vala](https://vala.dev/), a C#/Java/JavaFX-like language with a self-hosting compiler that generates C code, uses the GObject type system and wrapping a number of GTK libraries, and utilizes GNOME internationalization and localization (_i18n_) for user-facing strings, which are translated via [Weblate](https://hosted.weblate.org/projects/tuner/). [Meson](https://mesonbuild.com/) is the build system.

## Tuner Development

Hosted on Github, the _main_ branch reflects the current stable release. The _development_ branch is the development branch and where releases are staged. Pull Requests should be made against the _development_ branch.

### Naming Conventions

Going forward, all new code should conform to the following naming conventions:

- Namespaces are named in camel case: NameSpaceName
- Classes are named in camel case: ClassName
- Method names are all lowercase and use underscores to separate words: method_name
- Constants (and values of enumerated types) are all uppercase, with underscores between words: CONSTANT_NAME
- Public properties are named in camel case: propertyName
- Private member variables are named all lowercase and use underscores to separate words prefixed with an underscore: _var_name

<!---- Signals are named all lowercase and use underscores to separate words postfixed with \_sig: propertyName_sig -->

### Dependencies

Development dependencies for Tuner are:

```bash
granite
gstreamer-1.0
gstreamer-player-1.0
gtk+-3.0
json-glib-1.0
libgee-0.8
libsoup-3.0
meson
vala
```

Install required dependencies (Debian/Ubuntu):

```bash
sudo apt install git valac meson
sudo apt install libgtk-3-dev libgee-0.8-dev libgranite-dev libgstreamer1.0-dev libgstreamer-plugins-bad1.0-dev libsoup-3.0-dev libjson-glib-dev
```

### Building the Tuner App From Source

There are two build configurations: _debug_ and _release_. The _debug_ build (manifest _com.github.louis77.tuner.debug.yml_) is recommended for development, while the _release_ build (manifest _com.github.louis77.tuner.yml_) is for distribution. Build instructions will focus on the _debug_ build. Copy the required manifest to _com.github.louis77.tuner.xml_ before building.

Clone the repo and drop into the Tuner directory:

```bash
git clone https://github.com/tuner-app/tuner.git
cd tuner
```

Configure Meson for development debug build, build Tuner with Ninja, and run the result:

```bash
meson setup --buildtype=debug builddir -Dtranslate=update
meson compile -C builddir
meson install -C builddir     # only needed once to get the gschema in place
./builddir/com.github.louis77.tuner
```

Tuner can be deployed to the local system to bypass flatpak if required, however it is _recommended to use flatpak_.To do deploy locally, run the following command:

```bash
meson configure -Dprefix=/usr
sudo ninja install
```

### Valadoc

```bash
valadoc --force \
  --pkg gtk+-3.0 --pkg glib-2.0 \
  --pkg gee-0.8 --pkg gio-2.0 \
  --pkg libsoup-3.0 --pkg json-glib-1.0 \
  --pkg gstreamer-1.0 --pkg gstreamer-player-1.0 \
  --pkg granite \
  --package-name=Tuner \
  --directory=src \
  -o apidocs \
  --verbose
  $(find src -type f -name '*.vala')
```

## Building the Tuner Flatpak

Tuner uses the **org.freedesktop.Sdk** version **25.08** with the  **Vala** extension. To build the tuner flatpak, install the freedesktop SDK, Platform and Vala extension. For example, for x86:

```bash
apt-get install flatpak-builder
flatpak install flathub org.freedesktop.Platform//x86_64//25.08
flatpak install flathub org.freedesktop.Sdk//x86_64//25.08
flatpak install flathub org.freedesktop.Sdk.Extension.vala/x86_64/25.08
```

Build the flatpak in the _user_ scope:

```bash
flatpak-builder --force-clean --user --sandbox --install build-dir com.github.louis77.tuner.debug.yml
```

Run the Tuner flatpack:

```bash
flatpak --user run com.github.louis77.tuner
```

Check the app version to ensure that it matches the version in the manifest.

## Readying code for a Pull Request

### Build Changes

If the build has changed it may be required to update repository check-in **Action** workflows in the _.github_ directory prior to check-in. For example if the _Platform_ chnges the Repository _Build and Test_ and _CI_ actions need to be updated and pushed prior to code changes are pushed. It is also good practice to check to see if the action components themselves have been superceded and need to reference new versions.

### Language Changes & Translations

Changes to strings that are internationalized require translation via [Weblate](https://hosted.weblate.org/projects/tuner/) and reintegration of the new translations into the build.

for translation by GNOME gettext require that the _.pot_ file be regenerated, checked in and pushed so

```bash
meson compile -C builddir pot
meson compile -C builddir extra-pot
```

### Code Changes

Before a pull request can be accepted, the code must pass linting. This is done by running the following command:

```bash
flatpak run --command=flatpak-builder-lint org.flatpak.Builder manifest com.github.louis77.tuner.yml
```

Linting currently produces the following issues (adddressed in ticket #140):

```json
{
    "errors": [
        "appid-uses-code-hosting-domain"
    ],
    "info": [
        "appid-uses-code-hosting-domain: github.com"
    ],
    "message": "Please consult the documentation at https://docs.flathub.org/docs/for-app-authors/linter"
}
```

Ensure that the CI checks pass before pushing your changes.

## Debugging

### VSCode

Debugging from VSCode using GDB, set up the launch.json file as follows:

```json
{
  "version": "0.2.0",
  "configurations": [    
    {
      "name": "Debug Vala with Meson",
      "type": "cppdbg",
      "request": "launch",
      "program": "${workspaceFolder}/builddir/com.github.louis77.tuner",
      "args": [],
      "stopAtEntry": false,
      "cwd": "${workspaceFolder}",
      "environment": [],
      "externalConsole": false,
      "MIMode": "gdb",
      "miDebuggerPath": "/usr/bin/gdb",
      "setupCommands": [
        {
          "description": "Enable pretty-printing for gdb",
          "text": "-enable-pretty-printing",
          "ignoreFailures": true
        }
      ],
      "preLaunchTask": "meson build"
    }
  ]
}
```

_Note:_ Variables appear as pointers, and generated code is not found. Please submit a better config if you have one.

### Bug Introduction Deduction

Knowing when a bug was introduced requires building previous versions and looking for the aberrent behavior. The following commands can be used to check out previous versions of the code:

```bash
git fetch
git tag
git checkout <tag>
```

After checking out the required version, build and run the app as described above.

## Release Process

Releasing _Tuner_ comprises cutting a release of the code in [tuner github](https://github.com/tuner-app/tuner) and then updating the [flathub repo](https://github.com/flathub/com.github.louis77.tuner) which will automatically have the flatpak generated and rolled to Flathub for distribution.

### Beta Releases

Beta releases should be tagged from the Tuner _development_ branch in with a version number format of _v1.\*.\*-beta.\*_

Once a beta release has been tagged, the Flathub _beta_ branch can be updated via a pull request with the _beta_ tag going into the manifest _.json_, and any patches and documentation updated as needed. The pull request will trigger a flathub build, but will not merge the pull request - pull requests should be merged only if they result in a successful build.

Once the beta is successfully built by flathub it will be available for installation and testing within the user community.

Once a beta roll is deamed a success its pull request can be merged, and a production release can be rolled.

### Production Releases

Production releases are generated from _development_ pull requests into _main_. The updated _main_ branch should be tagged with a version number format of _v1.\*.\*_

Once a release has been tagged, the [flathub repo](https://github.com/flathub/com.github.louis77.tuner) _main_ branch can be updated with the _release_ tag going into the manifest _.json_, and any patches and documentation updated as needed. Updates from the _main_ branch should be copied in from a direct _pull request_ of the _main_ branch. The _main_ branch **should not** come from a merge _beta_ branch to avoid triggering subsequent builds in _beta_ .

Once the main production release is built by flathub it will be available for installation and automatically distributed to user community.
