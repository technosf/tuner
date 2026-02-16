rm -r builddir build-dir .flatpak-builder
#meson setup builddir -Dtranslation=update
meson setup --buildtype=debug builddir -Dtranslation=update
meson compile -C builddir pot
meson compile -C builddir countries-pot
meson compile -C builddir extra-pot
#flatpak-builder --force-clean --user --sandbox --install build-dir com.github.louis77.tuner.yml

