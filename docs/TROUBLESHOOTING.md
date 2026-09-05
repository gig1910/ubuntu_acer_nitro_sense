# Troubleshooting

[Русская версия](ru/TROUBLESHOOTING.md)

Start with the packaged diagnostic report:

```bash
acer-control-diagnose
```

## Daemon is unavailable

```bash
systemctl status acer-control-daemon.service --no-pager
journalctl -u acer-control-daemon.service -b --no-pager
busctl introspect org.acer.Control /org/acer/Control org.acer.Control
```

The installed service should run Python from `/usr/local/lib/acer-control`, not a development home directory.

## RGB controls are missing

```bash
lsmod | grep acer_control_rgb_bridge
modinfo acer_control_rgb_bridge | grep -E '^(filename|version|signer|sig_hashalgo):'
cat /sys/kernel/acer_control_rgb/capabilities
```

Expected bridge version for rc10 is `0.3`.

With Secure Boot enabled, an unsigned or unenrolled module will not load. Check:

```bash
mokutil --sb-state
sudo dmesg | grep -iE 'acer_control_rgb|verification|signature|secure boot'
```

## Keyboard timeout does not appear in the GUI

Check the bridge directly:

```bash
cat /sys/kernel/acer_control_rgb/backlight_timeout
```

Then verify D-Bus exposes the updated lighting state:

```bash
busctl call org.acer.Control /org/acer/Control org.acer.Control GetKeyboardLighting
```

The GUI only displays the timeout switch when the backend reports it as supported.

## CPU temperature reaches 100 °C

Acer Control reads the `coretemp` package sensor; it does not intentionally clamp normal values to 100 °C. Compare the underlying hwmon sensors before blaming the UI:

```bash
for h in /sys/class/hwmon/hwmon*; do
  [ "$(cat "$h/name" 2>/dev/null)" = coretemp ] || continue
  for l in "$h"/temp*_label; do
    [ -e "$l" ] || continue
    base="${l%_label}"
    printf '%-18s %6.1f °C\n' "$(cat "$l")" "$(awk '{print $1/1000}' "${base}_input")"
  done
done
```

The Dashboard display scale intentionally extends to 110 °C so a real 100 °C sample does not visually stick to the top border.

## Custom profile is editable but does not control fans on a clean install

This is the known RC limitation: custom PWM execution still belongs to the legacy `/usr/local/sbin/acer-fan-control` component. The new daemon does not yet replace it. See [Fan profiles](FAN-PROFILES.md).

## `apt update` fails during installation

The installer runs `apt-get update` only when required packages are missing. An unrelated broken third-party repository can therefore interrupt dependency installation. Repair/disable that repository, preinstall the required packages, or rerun with `--no-apt` after dependencies are present.
