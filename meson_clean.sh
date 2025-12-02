rm -r builddir
meson setup --buildtype=debug builddir
meson compile -C builddir
#flatpak-builder --force-clean --user --sandbox --install build-dir com.github.louis77.tuner.yml

