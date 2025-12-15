rm -r builddir
#meson setup builddir -Dtranslation=update
meson setup --buildtype=debug builddir -Dtranslation=update
meson compile -C builddir pot
#flatpak-builder --force-clean --user --sandbox --install build-dir com.github.louis77.tuner.yml

