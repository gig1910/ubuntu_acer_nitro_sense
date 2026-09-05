# D-Bus API

[Русская версия](ru/DBUS-API.md)

Acer Control exposes a system-bus service:

```text
Bus name:   org.acer.Control
Object:     /org/acer/Control
Interface:  org.acer.Control
```

Inspect the live interface with:

```bash
busctl introspect org.acer.Control /org/acer/Control org.acer.Control
```

## Telemetry and capabilities

| Method | Signature | Purpose |
|---|---|---|
| `GetTelemetry` | `() -> a{sv}` | Current CPU/GPU/fan/platform telemetry |
| `GetCapabilities` | `() -> a{sv}` | Hardware/backend capability flags |
| `TelemetryChanged` | signal `a{sv}` | Periodic telemetry update |

## Platform profile

| Method | Purpose |
|---|---|
| `SetPlatformProfile(s)` | Runtime ACPI platform-profile change |
| `SavePlatformProfile(s)` | Save the default profile used on daemon startup |
| `GetSavedPlatformProfile()` | Read the persisted default |

Runtime selection and persisted default are intentionally separate operations.

## Fan profiles

| Method | Purpose |
|---|---|
| `ListFanProfiles()` | List profile IDs |
| `GetFanProfile(s)` | Return profile config text |
| `ValidateFanProfile(ss)` | Validate profile text without saving |
| `GetActiveFanProfile()` | Return platform profile and mapped fan profile |
| `SaveFanProfile(ss)` | Save a user profile |
| `DeleteFanProfile(s)` | Delete an allowed user profile |
| `SetActiveFanProfile(s)` | Select explicit fan profile mapping |
| `SetFollowPlatformProfile(b)` | Enable/disable platform-profile mapping |

Package-owned system profiles are protected in the backend, not only by disabled GUI controls. `SaveFanProfile` is intended for `kind=user` profiles.

## Keyboard lighting

| Method | Purpose |
|---|---|
| `GetKeyboardLighting()` | Read actual hardware state |
| `BeginKeyboardLightingPreview()` | Capture a restore baseline |
| `PreviewKeyboardLighting(a{sv})` | Apply debounced live preview state |
| `SaveKeyboardLighting(a{sv})` | Apply/persist the final state |
| `CancelKeyboardLightingPreview()` | Restore preview baseline |

The lighting state dictionary includes effect mode, speed, brightness, direction, global color, four zone colors and optional timeout capability/state.

## Authorization

Hardware/configuration mutations use polkit action:

```text
org.acer.control.modify
```

The packaged rule grants the intended local administrative user policy configured by the project. Do not make the GUI setuid/root; privileged operations belong in the daemon.
