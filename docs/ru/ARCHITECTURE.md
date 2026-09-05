# Архитектура

[English version](../ARCHITECTURE.md)

Acer Control разделяет обычный desktop UI и привилегированный доступ к hardware.

```mermaid
flowchart TD
    GUI[GTK4 / libadwaita GUI\nобычный пользователь] -->|system D-Bus| DBUS[org.acer.Control]
    DBUS --> DAEMON[acer-control-daemon\nroot / systemd]
    DAEMON --> CONFIG[/etc/acer-control]
    DAEMON --> SYSFS[ACPI platform_profile\nacer_wmi hwmon]
    DAEMON --> NVIDIA[NVIDIA telemetry\nпо возможности без пробуждения suspended GPU]
    DAEMON --> KBD[Keyboard controller]
    KBD --> RGB[/sys/kernel/acer_control_rgb]
    RGB --> BRIDGE[acer_control_rgb_bridge\nDKMS kernel module]
    BRIDGE --> WMI[Acer WMI firmware methods]
    LEGACY[legacy acer-fan-control\nPWM loop - временная RC-зависимость] --> SYSFS
```

## GUI

GUI запускается от пользователя графической сессии и не пишет напрямую в `/sys`, `/etc` или WMI firmware methods. Основные окна:

- Dashboard и график runtime telemetry;
- Profile Settings с редактором fan profiles;
- Keyboard Lighting с настройкой аппаратных эффектов;
- общие настройки, включая язык UI.

Application ID: `org.acer.Control.UI`.

## Системный daemon

`acer-control-daemon.service` работает от root и владеет именем system bus `org.acer.Control`. Он выполняет:

- сбор телеметрии;
- чтение/запись ACPI platform profile и сохранение default profile;
- хранение и проверку fan profiles;
- RGB preview/save/restore;
- определение hardware capabilities.

Изменяющие операции защищены polkit action `org.acer.control.modify`.

## Конфигурация

Системная конфигурация находится в `/etc/acer-control`.

Встроенные fan profiles принадлежат пакету и защищены от изменения через API. Пользовательские профили имеют `kind=user` и могут создаваться, редактироваться и удаляться. Защита действует не только в GUI, но и в backend.

Язык интерфейса — пользовательская настройка в `~/.config/acer-control/ui.conf`.

## RGB bridge

Штатный `acer_wmi` остаётся загруженным. `acer_control_rgb_bridge` — companion GPL kernel module, вызывающий необходимые Acer WMI methods и публикующий узкий sysfs-интерфейс `/sys/kernel/acer_control_rgb`.

Persistence и подавлением лишних записей занимается daemon. Это важно: повторная запись того же dynamic effect заметно перезапускает аппаратную анимацию.

## Статус fan control в rc10

Новый daemon **ещё не владеет production PWM loop**. Старый `/usr/local/sbin/acer-fan-control` пока остаётся PWM writer на development-машине и сохраняется installer'ом. Финальная архитектура должна перенести этот policy loop в daemon, чтобы PWM писал ровно один компонент.
