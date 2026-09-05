# Keyboard RGB bridge

[Русская версия](ru/KEYBOARD-RGB.md)

## Hardware path

Acer Control keeps the stock `acer_wmi` module loaded and adds a small companion module, `acer_control_rgb_bridge`, for the WMI methods not exposed by the stock driver.

Tested WMI keyboard GUID:

```text
7A4DDFE7-5B5D-40B4-8595-4408E0CC7F56
```

The bridge exposes:

```text
/sys/kernel/acer_control_rgb/
├── capabilities
├── dynamic
├── raw_dynamic
├── zones
└── backlight_timeout
```

The module is version `0.3` in rc10 and is installed through DKMS.

## Effects

| Effect | Firmware ID | User color | Speed | Direction |
|---|---:|---|---|---|
| Static | 0 | per zone | no | no |
| Breath | 1 | global | yes | no |
| Neon | 2 | no; firmware cycles colors | yes | no |
| Wave | 3 | no; firmware rainbow/wave | yes | yes |
| Shifting | 4 | global | yes | yes |
| Zoom | 5 | global | yes | no |

Brightness is a hardware setting from 0 to 100. Dynamic speed uses firmware levels 1..9. Direction values currently map to:

```text
1 = Right to Left
2 = Left to Right
```

The on-screen animation is only a visual explanation of the selected firmware effect. Acer Control does **not** generate RGB frames in software and stream them to the keyboard.

## Static zones

The tested AN515-58 keyboard exposes four lighting zones. The GUI uses an explicit physical key-to-zone map rather than inferring zones only from X coordinates, because the right arrow/numpad/media block does not follow a simple rectangular split.

## No-op suppression

Writing the same dynamic effect again can visibly restart the firmware animation. The daemon therefore compares active fields and avoids unnecessary hardware writes. Slider previews are debounced, and Save persists the actual hardware state rather than blindly reapplying unchanged values.

## Backlight timeout

The bridge also supports Acer's keyboard backlight timeout control on the tested machine. The firmware reports a 30-second timeout capability and the sysfs attribute is a boolean enable/disable control:

```bash
cat /sys/kernel/acer_control_rgb/backlight_timeout
```

`0` and `1` writes/readback have been verified on the AN515-58. Exact wake-trigger semantics should not be assumed for other models without testing.

## Secure Boot

Because the bridge is out-of-tree, Secure Boot systems need a trusted module signature. The installer can configure DKMS to use an enrolled MOK. See [Installation](INSTALLATION.md).
