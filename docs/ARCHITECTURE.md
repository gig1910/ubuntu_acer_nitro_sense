# Architecture

[Русская версия](ru/ARCHITECTURE.md)

Acer Control separates the unprivileged desktop UI from privileged hardware access.

```mermaid
flowchart TD
    GUI[GTK4 / libadwaita GUI\nnormal user] -->|system D-Bus| DBUS[org.acer.Control]
    DBUS --> DAEMON[acer-control-daemon\nroot / systemd]
    DAEMON --> CONFIG[/etc/acer-control]
    DAEMON --> SYSFS[ACPI platform_profile\nacer_wmi hwmon]
    DAEMON --> NVIDIA[NVIDIA telemetry\nwithout waking suspended GPU when possible]
    DAEMON --> KBD[Keyboard controller]
    KBD --> RGB[/sys/kernel/acer_control_rgb]
    RGB --> BRIDGE[acer_control_rgb_bridge\nDKMS kernel module]
    BRIDGE --> WMI[Acer WMI firmware methods]
    LEGACY[legacy acer-fan-control\nPWM loop - temporary RC dependency] --> SYSFS
```

## GUI

The GUI runs as the logged-in desktop user. It does not write `/sys`, `/etc` or firmware methods directly. Main windows include:

- Dashboard and runtime telemetry graph;
- Profile Settings fan-profile editor;
- Keyboard Lighting settings and hardware-effect preview;
- application settings, including UI language.

The application ID is `org.acer.Control.UI`.

## System daemon

`acer-control-daemon.service` runs as root and owns the system-bus name `org.acer.Control`. It provides:

- telemetry sampling;
- ACPI platform-profile read/write and persistent default selection;
- fan-profile storage/validation operations;
- keyboard RGB state, preview, save and restore;
- capability detection.

Mutating operations are protected through polkit (`org.acer.control.modify`).

## Configuration ownership

System configuration lives under `/etc/acer-control`.

Built-in fan profiles are package-owned and immutable through the application API. User profiles are `kind=user` and may be created, edited and deleted. This protects known-good templates from accidental changes and from D-Bus clients bypassing the GUI.

UI language is per-user and stored under `~/.config/acer-control/ui.conf`.

## RGB bridge

The stock `acer_wmi` driver remains loaded. `acer_control_rgb_bridge` is a companion GPL kernel module that invokes the Acer WMI methods needed for keyboard lighting and exposes a narrow sysfs interface under `/sys/kernel/acer_control_rgb`.

The daemon owns persistence and no-op suppression. This matters because rewriting an unchanged dynamic effect can visibly restart the firmware animation.

## Fan control status in rc10

The new daemon does **not yet own the production PWM loop**. The older `/usr/local/sbin/acer-fan-control` remains the PWM writer on the development machine and is preserved by the installer. The intended final architecture is to move that policy loop into the daemon so there is exactly one PWM owner.
