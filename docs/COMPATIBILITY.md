# Compatibility status

[Русская версия](ru/COMPATIBILITY.md)

| Component | Validated target |
|---|---|
| Laptop | Acer Nitro AN515-58 |
| Development OS | Ubuntu 26.04 |
| GUI | GNOME/Wayland, GTK4 + libadwaita |
| RGB bridge | `acer_control_rgb_bridge` 0.3 |
| Keyboard zones | 4 |
| Secure Boot | Tested with an enrolled MOK and DKMS signing |

Other Acer models are currently **untested**, not implicitly supported. A model should be added to the compatibility list only after readback and write behavior have been verified for the relevant WMI methods.
