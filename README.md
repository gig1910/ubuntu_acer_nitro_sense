# Acer Control for Ubuntu on Acer Nitro

[Русская версия](README.ru.md)

Acer Control is a GTK4/libadwaita control center for Acer Nitro laptops on Linux. It combines live telemetry, Acer platform-profile switching, fan-profile management and visualization, and hardware keyboard RGB control behind a privileged system D-Bus daemon.

> **Project status:** `0.1.0-rc12` release candidate. Development and hardware validation are currently focused on **Acer Nitro AN515-58** running **Ubuntu 26.04**. Other Acer models may use different WMI methods or firmware behavior and must be treated as untested until verified.

## Highlights

- GTK4/libadwaita dashboard with CPU/GPU temperatures, fan RPM and runtime history.
- Dashboard temperature history uses a `30..110 °C` display range so a real `100 °C` reading does not visually stick to the graph border.
- Acer ACPI `platform_profile` switching and persistent default profile selection.
- Separate **Platform profile** and **Fan control profile** selectors.
- Fan-profile library with protected built-in profiles and editable user copies.
- Interactive fan-curve editor and controller simulation showing EMA, CPU hysteresis, CPU down delay and GPU native down delay.
- System profiles are read-only; the `Performance` custom template can be copied to a user profile before editing.
- 4-zone keyboard RGB control using hardware effects only: Static, Breath, Neon, Wave, Shifting and Zoom.
- Keyboard idle backlight timeout support when exposed by the bridge firmware interface.
- Root system daemon over D-Bus + polkit; the GUI itself runs unprivileged.
- DKMS packaging for the RGB WMI bridge, including optional Secure Boot/MOK signing setup.
- English and Russian UI with Auto/system-language selection.
- Standalone installer, upgrade path, diagnostics command and uninstaller.

## RC12 dashboard layout

RC12 rebalances the main window vertically. Fan-control profile selection now occupies the otherwise unused area below the NVIDIA GPU state, while platform-profile controls remain in the right column. This gives substantially more height to the runtime-history graph on laptop workareas and keeps the window vertically resizable.

## Platform profiles vs fan-control profiles

These are deliberately separate concepts:

- **Platform profile** controls Acer/ACPI `platform_profile`: `low-power`, `quiet`, `balanced`, `balanced-performance`, `performance`.
- **Fan control profile** selects an Acer Control fan-policy profile. Choose **Automatic (follow platform profile)** to use the configured platform→fan mapping, or select any built-in/user fan profile explicitly.

User-created fan profiles appear in the dashboard selector. Manual selection is persisted immediately, and the list is refreshed when the dashboard regains focus so a newly created user copy becomes available without restarting the application.

## Important RC limitation

The current daemon handles telemetry, platform profiles, profile storage/editor logic and keyboard RGB. The production custom PWM loop developed earlier is **not yet integrated into the daemon**. If `/usr/local/sbin/acer-fan-control` already exists, the installer preserves it; on a clean system without that legacy writer, custom fan curves can be edited and stored but are not yet executed. Firmware-controlled fan behavior and Acer platform profiles continue to work.

This is the main architectural task remaining before a fully self-contained fan-control release.

## Quick install from source

```bash
git clone https://github.com/gig1910/ubuntu_acer_nitro_sense.git
cd ubuntu_acer_nitro_sense
sudo ./install.sh
```

The same installer is used for upgrades. Existing `/etc/acer-control/acer-control.conf` and user-created fan profiles are preserved.

For Secure Boot, the installer can use an existing enrolled MOK pair or configure DKMS signing interactively. See [Installation](docs/INSTALLATION.md).

## Build a standalone `.run` installer

```bash
./tools/build-release.sh
```

Artifacts are written to `dist/`:

```text
acer-control-<version>.tar.gz
acer-control-<version>-installer.run
acer-control-<version>.SHA256SUMS
```

## Documentation

- [Installation and upgrades](docs/INSTALLATION.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Compatibility status](docs/COMPATIBILITY.md)
- [Fan profiles and controller parameters](docs/FAN-PROFILES.md)
- [Keyboard RGB bridge and hardware effects](docs/KEYBOARD-RGB.md)
- [D-Bus API](docs/DBUS-API.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Development and release builds](docs/DEVELOPMENT.md)
- [Current release notes](RELEASE-NOTES.md) · [Русский перевод](RELEASE-NOTES.ru.md)

Russian documentation: [docs/ru/](docs/ru/).

## Diagnostics

After installation:

```bash
acer-control-diagnose
```

Useful manual checks:

```bash
systemctl status acer-control-daemon.service
modinfo acer_control_rgb_bridge
cat /sys/kernel/acer_control_rgb/capabilities
busctl introspect org.acer.Control /org/acer/Control org.acer.Control
```

## Hardware scope

This software writes firmware-facing controls and installs an out-of-tree kernel module. Hardware methods have been tested on the development AN515-58, but Acer does not guarantee that the same WMI interface is meaningful on every model. Do not assume compatibility from the `Nitro` product name alone.

## License

No open-source license has been selected for this repository yet. Until a license is added, normal copyright rules apply. This should be resolved before treating the project as a generally redistributable open-source package.

## Disclaimer

This project is independent and is not affiliated with or endorsed by Acer Inc. `Acer`, `Nitro` and related names are trademarks of their respective owners.
