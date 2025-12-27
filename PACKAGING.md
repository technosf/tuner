# Packaging instructions for various platform

## Local Build

Building Tuner localy is described in the [development doc](DEVELOP.md).

## Packages for other platforms and distos

Other packed versions of Tuner are available, but are maintained outside of Tuner itself: Versions may be out of date.

### Arch Linux / AUR

Arch-based GNU/Linux users can find `Tuner` under the name [tuner-git](https://aur.archlinux.org/packages/tuner-git/) in the **AUR**:

```bash
yay -S tuner-git
```

Thanks to [@btd1377](https://github.com/btd1337) for supporting Tuner on Arch Linux!

### MX Linux

MX Linux users can find `Tuner` by using the MX Package Installer (currently under the MX Test Repo tab for MX-19 and the Stable Repo for MX-21)

Thanks to SwampRabbit for packaging Tuner for MX Linux!

### Pacstall

Pacstall is a totally new package manager for Ubuntu that provides an AUR-like community-driven repo for package builds. If you already use `pacstall` you can install Tuner:

```bash
pacstall -I tuner
```

If you have Ubuntu and want a clean build of Tuner on your system, consider using `pacstall` instead of Flatpak if you don't feat beta software. Get `pacstall` here:

<https://pacstall.dev>

## General

### Desktop Menu

The desktop file must be validated using this command:

```bash
desktop-file-validate [name-of-desktop-file]
```

### AppData

The AppData.xml must be validated using this command:

```bash
flatpak run org.freedesktop.appstream-glib validate [path-to-xml]

```

### Test different languages

```bash
LANGUAGE=de_DE ./com.github.louis77.tuner

```

## Flatpak

The flathub build manifest can be found here:
<https://github.com/louis77/flathub/tree/com.github.louis77.tuner>

## Pacstall

Tuner is in the pacstall repo with the lastest release (1.3.1):
<https://github.com/louis77/pacstall-programs>

## Dev Tricks

### See Debug Log

<https://docs.elementary.io/develop/writing-apps/logging>

```bash
G_MESSAGES_DEBUG=all ./com.github.louis77.tuner
```

### Available elementary Icons

Use LookBook app.

### Manually compile schemas

```bash
sudo /usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas/
```

## Release Checklist

- [ ] Create Release Tag in AppData
