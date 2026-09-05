# Acer Control 0.1.0-rc10

## Profile editing model

- Built-in system custom profiles are strictly read-only in both Profile Settings and the configuration backend.
- Curve controls, numeric controller parameters and graph gestures are disabled for package-owned system profiles.
- `Save changes` remains disabled for a system profile and explains that a user copy must be created first.
- `Create user copy` remains available for known custom templates such as `Performance`.
- User profiles (`kind=user`) remain editable, savable, duplicable and deletable.
- Firmware-controlled profiles remain read-only and non-convertible because Acer firmware does not expose their internal curves.

## UI and visualization retained from recent RCs

- Profile Settings uses independently scrolling editor/preview panes so header/footer stay visible and the window remains vertically resizable.
- Controller-dynamics preview visualizes EMA, CPU hysteresis, CPU down delay and GPU native down delay.
- Dashboard history uses a 30..110 °C visual scale so 100 °C telemetry does not stick to the top border.
- Fan-output previews use a 0..110% display scale while valid output remains capped at 100%.
- English/Russian localization and adaptive window sizing are enabled.

## Packaging

- Standalone system install under `/usr/local/lib/acer-control`.
- D-Bus/polkit/systemd integration.
- DKMS RGB bridge 0.3 with optional persistent MOK signing configuration.
- GNOME/Freedesktop desktop entries and hicolor icon set.
- Upgrade installs preserve local settings and user-created fan profiles.

## Known release-candidate limitation

Custom fan profile execution still depends on the previously developed legacy `/usr/local/sbin/acer-fan-control` PWM writer. The new daemon stores and validates profiles but does not yet own the production PWM loop on a clean installation.
