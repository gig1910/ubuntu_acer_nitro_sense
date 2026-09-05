# Development and release builds

[Русская версия](ru/DEVELOPMENT.md)

## Source layout

```text
acer_control/        Python GTK/D-Bus application and hardware backends
defaults/            package-owned default configuration and fan profiles
kernel/rgb/          DKMS keyboard RGB bridge
packaging/           systemd, D-Bus, polkit, desktop files and launchers
po/                  gettext source translations
icons/               pre-generated hicolor application icons
tests/               regression tests
tools/               release tooling
```

## Design rules

- GUI code runs unprivileged.
- Hardware/configuration writes go through the system daemon.
- Avoid hardcoded machine-specific paths when a value can reasonably be configured or discovered.
- Do not unload/replace stock `acer_wmi` to provide keyboard RGB; the bridge is a companion module.
- Avoid writing unchanged RGB state because the firmware can restart an animation on identical writes.
- Package-owned system fan profiles are immutable through the public application API.
- The final fan-controller architecture must have one PWM owner.

## Basic checks

```bash
python3 -m compileall -q acer_control

for test in tests/*_test.py; do
    PYTHONPATH=. python3 "$test"
done

bash -n install.sh
bash -n uninstall.sh
bash -n tools/build-release.sh
```

GTK-dependent tests require Python GI, GTK4 and libadwaita introspection packages.

## Localization

English strings in source are gettext message IDs. Russian source translations are kept in:

```text
po/ru.po
```

The runtime catalog is currently shipped in:

```text
acer_control/locale/ru/LC_MESSAGES/acer-control.mo
```

The UI language preference is `auto`, `en` or `ru` and is stored per user.

## Versioning

The application version is defined in:

```python
acer_control/__init__.py
```

`install.sh` has a release version string as well. Keep both synchronized. The release builder verifies the values before packaging.

## Release build

```bash
./tools/build-release.sh
```

The script creates a clean staged release tree, excludes Python caches, regenerates `MANIFEST.sha256`, builds the source tarball and prepends it to the self-extracting `.run` installer stub.

The generated `dist/` directory is intentionally ignored by Git.

## Hardware changes

Changes to the WMI bridge should be tested conservatively on known hardware. For kernel updates:

1. build with the running kernel headers;
2. sign the module when Secure Boot is enabled;
3. verify `modinfo` signer;
4. load the module;
5. inspect `capabilities`, `dynamic`, `zones` and timeout readback before testing writes.
