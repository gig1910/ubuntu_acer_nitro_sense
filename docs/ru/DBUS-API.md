# D-Bus API

[English version](../DBUS-API.md)

Acer Control использует system bus service:

```text
Bus name:   org.acer.Control
Object:     /org/acer/Control
Interface:  org.acer.Control
```

Текущий интерфейс можно посмотреть так:

```bash
busctl introspect org.acer.Control /org/acer/Control org.acer.Control
```

## Телеметрия и capabilities

| Method | Signature | Назначение |
|---|---|---|
| `GetTelemetry` | `() -> a{sv}` | Текущая CPU/GPU/fan/platform telemetry |
| `GetCapabilities` | `() -> a{sv}` | Флаги hardware/backend capabilities |
| `TelemetryChanged` | signal `a{sv}` | Периодическое обновление telemetry |

## Platform profile

| Method | Назначение |
|---|---|
| `SetPlatformProfile(s)` | Runtime изменение ACPI platform profile |
| `SavePlatformProfile(s)` | Сохранить default, восстанавливаемый daemon'ом |
| `GetSavedPlatformProfile()` | Получить сохранённый default |

Runtime выбор и persisted default специально разделены.

## Fan profiles

| Method | Назначение |
|---|---|
| `ListFanProfiles()` | Список profile IDs |
| `GetFanProfile(s)` | Получить config text |
| `ValidateFanProfile(ss)` | Проверить без сохранения |
| `GetActiveFanProfile()` | Получить platform profile и mapped fan profile |
| `SaveFanProfile(ss)` | Сохранить user profile |
| `DeleteFanProfile(s)` | Удалить разрешённый user profile |
| `SetActiveFanProfile(s)` | Выбрать явный fan-profile mapping |
| `SetFollowPlatformProfile(b)` | Включить/выключить mapping по platform profile |

Package-owned system profiles защищены backend'ом, а не только disabled GUI controls. `SaveFanProfile` предназначен для `kind=user`.

## Keyboard lighting

| Method | Назначение |
|---|---|
| `GetKeyboardLighting()` | Прочитать фактический hardware state |
| `BeginKeyboardLightingPreview()` | Зафиксировать baseline для отмены |
| `PreviewKeyboardLighting(a{sv})` | Применить live preview |
| `SaveKeyboardLighting(a{sv})` | Применить и сохранить итог |
| `CancelKeyboardLightingPreview()` | Вернуть baseline |

Lighting state содержит mode, speed, brightness, direction, global color, четыре zone colors и optional timeout capability/state.

## Authorization

Изменяющие hardware/config операции используют polkit action:

```text
org.acer.control.modify
```

GUI не должен запускаться root/setuid; привилегированные операции находятся в daemon.
