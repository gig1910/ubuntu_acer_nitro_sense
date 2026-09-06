# Acer Control for Ubuntu on Acer Nitro

[Русская версия](README.ru.md)

Acer Control is an experimental GTK4/libadwaita control center for Acer Nitro laptops on Linux. It combines live telemetry, Acer platform-profile switching, fan-profile editing and visualization, and hardware keyboard RGB control behind a privileged system D-Bus daemon.

> **Project status:** `0.1.0-rc12`. Hardware validation is currently focused on **Acer Nitro AN515-58** running **Ubuntu 26.04**. Other Acer models may use different WMI methods or firmware behavior and are untested until verified.

## Highlights

- Live CPU/GPU temperatures, fan RPM and a 5/10-minute runtime history graph.
- Acer ACPI `platform_profile` switching with a persistent default profile.
- Separate **platform profile** and **fan-control profile** selectors.
- Protected built-in fan profiles plus editable user copies.
- Interactive fan-curve editor and controller simulation for EMA, hysteresis and down-delay behavior.
- 4-zone keyboard RGB control using firmware effects: Static, Breath, Neon, Wave, Shifting and Zoom.
- Keyboard idle backlight timeout support on compatible firmware.
- Root system daemon over D-Bus + polkit; the GTK GUI itself runs unprivileged.
- DKMS packaging for the RGB WMI bridge, including optional Secure Boot/MOK signing.
- English and Russian UI with Auto/system-language selection.
- Standalone installer, diagnostics command and uninstaller.

## Important RC limitation

The daemon currently handles telemetry, platform profiles, fan-profile storage/editor logic and keyboard RGB. The production custom PWM loop developed earlier has **not yet been integrated into the daemon**. If `/usr/local/sbin/acer-fan-control` already exists, the installer preserves it. On a clean system without that legacy writer, custom curves can be created and stored but are not yet executed. Firmware-controlled fan behavior and Acer platform profiles continue to work.

This is the main architectural task remaining before fan control is fully self-contained.

## Install

```bash
git clone https://github.com/gig1910/ubuntu_acer_nitro_sense.git
cd ubuntu_acer_nitro_sense
sudo ./install.sh
```

The installer also supports upgrades over an existing Acer Control installation. Existing `/etc/acer-control/acer-control.conf` and user-created fan profiles are preserved.

With Secure Boot enabled, the installer can use an already enrolled MOK pair or configure DKMS signing interactively. See [Installation](docs/INSTALLATION.md).

## Build a standalone installer

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
- [Current release notes](RELEASE-NOTES.md)

Russian documentation is available under [`docs/ru/`](docs/ru/).

## Diagnostics

```bash
acer-control-diagnose
```

Useful checks:

```bash
systemctl status acer-control-daemon.service
modinfo acer_control_rgb_bridge
cat /sys/kernel/acer_control_rgb/capabilities
busctl introspect org.acer.Control /org/acer/Control org.acer.Control
```

## Hardware scope

This software writes firmware-facing controls and installs an out-of-tree kernel module. The methods in this repository have been tested on the development AN515-58, but compatibility must not be assumed from the `Nitro` product name alone.

Built-in system fan profiles are intentionally read-only. `Performance` is a read-only custom template that can be copied to a user profile and then edited. Firmware profiles are not presented as editable copies because Acer firmware does not expose their internal fan curves.

## License

No open-source license has been selected yet. Until a license file is added, normal copyright rules apply.

## Disclaimer

This project is independent and is not affiliated with or endorsed by Acer Inc. `Acer`, `Nitro` and related names are trademarks of their respective owners.
