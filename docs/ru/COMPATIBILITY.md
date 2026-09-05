# Статус совместимости

[English version](../COMPATIBILITY.md)

| Компонент | Проверенная система |
|---|---|
| Ноутбук | Acer Nitro AN515-58 |
| Development OS | Ubuntu 26.04 |
| GUI | GNOME/Wayland, GTK4 + libadwaita |
| RGB bridge | `acer_control_rgb_bridge` 0.3 |
| Keyboard zones | 4 |
| Secure Boot | Проверено с enrolled MOK и DKMS signing |

Другие модели Acer сейчас считаются **непроверенными**, а не автоматически совместимыми. Модель стоит добавлять в support list только после проверки readback и write поведения нужных WMI methods.
