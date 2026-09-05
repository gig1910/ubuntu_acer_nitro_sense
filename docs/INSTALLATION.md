# Installation and upgrades

[Русская версия](ru/INSTALLATION.md)

## Supported development target

The release is currently validated on Acer Nitro AN515-58 with Ubuntu 26.04 and a standard Ubuntu kernel/userspace stack. The installer is written for Ubuntu/Debian-style systems, but hardware compatibility is a separate question from package compatibility.

## Install from a clone

```bash
git clone https://github.com/gig1910/ubuntu_acer_nitro_sense.git
cd ubuntu_acer_nitro_sense
sudo ./install.sh
```

Installer options:

```text
--no-apt      Do not install missing packages with apt.
-y, --yes     Accept non-security defaults. Secure Boot signing still requires an explicit choice.
```

The installer checks and, unless `--no-apt` is used, installs the required GTK/Python, D-Bus/polkit, DKMS, build and kernel-header packages.

## Upgrade

Run the new installer over the existing installation:

```bash
sudo ./install.sh
```

The installer replaces package-owned application files and built-in system fan profiles, but preserves:

- `/etc/acer-control/acer-control.conf`;
- user-created fan profile files;
- the legacy `/usr/local/sbin/acer-fan-control` PWM writer when it exists.

Package-owned profile IDs are `low-power`, `quiet`, `balanced`, `balanced-performance` and `performance`. A file using one of those reserved IDs is not overwritten if it is explicitly marked `kind=user`.

## Installed layout

```text
/usr/local/lib/acer-control/acer_control/
/usr/local/bin/acer-control
/usr/local/bin/acer-control-settings
/usr/local/bin/acer-control-diagnose
/usr/local/sbin/acer-control-uninstall
/etc/acer-control/
/etc/systemd/system/acer-control-daemon.service
/usr/share/dbus-1/system.d/org.acer.Control.conf
/usr/share/polkit-1/actions/org.acer.control.policy
/etc/polkit-1/rules.d/49-acer-control.rules
/usr/share/applications/org.acer.Control.UI.desktop
/usr/share/applications/org.acer.Control.UI.Settings.desktop
/usr/share/icons/hicolor/*/apps/org.acer.Control.UI.png
/usr/src/acer-control-rgb-0.3/
/etc/modules-load.d/acer-control-rgb.conf
```

The application ID, desktop filename and icon name all use `org.acer.Control.UI`, which lets GNOME/Wayland associate the running window with the installed application icon.

## Secure Boot and DKMS signing

The RGB bridge is an out-of-tree kernel module. With Secure Boot enabled, the module must normally be signed by a key trusted by the system.

The installer can reuse the standard Ubuntu MOK pair when present:

```text
/var/lib/shim-signed/mok/MOK.priv
/var/lib/shim-signed/mok/MOK.der
```

or a custom private key/certificate pair.

Persistent DKMS signing is written to:

```text
/etc/dkms/framework.conf.d/90-acer-control-signing.conf
```

This is a **system-wide DKMS setting**, so the configured key can also be used by other DKMS modules. The installer asks before changing it.

If the selected certificate is not enrolled, `mokutil --import` can start enrollment. Complete it in MokManager after reboot.

## Build the standalone installer

```bash
./tools/build-release.sh
```

Then install the generated artifact:

```bash
chmod +x dist/acer-control-*-installer.run
sudo dist/acer-control-*-installer.run
```

Extract without installing:

```bash
dist/acer-control-*-installer.run --extract ./acer-control-installer
```

## Diagnostics

```bash
acer-control-diagnose
```

## Uninstall

Preserve `/etc/acer-control`:

```bash
sudo /usr/local/sbin/acer-control-uninstall
```

Remove configuration too:

```bash
sudo /usr/local/sbin/acer-control-uninstall --purge
```
