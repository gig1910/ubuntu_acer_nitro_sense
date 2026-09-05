# Acer Control 0.1.0-rc12

## Dashboard

- Rebalanced the dashboard vertically so runtime history gets substantially more usable height.
- Moved the **Fan control profile** selector, effective-profile status and **Profile settings** button into the previously unused lower-left area below the NVIDIA GPU state.
- Kept platform-profile controls and keyboard lighting in the right column.
- Reduced vertical margins/spacing without reducing information density.
- Reduced the history graph minimum/natural height from 360 px to 260 px; it still expands to consume available height.
- Reduced the dashboard default window height from 850 px to 720 px so it remains vertically resizable on laptop workareas.

## Fan profiles

- Platform profiles and Acer Control fan-control profiles are separate selectors.
- User-created fan profiles can be selected directly from the dashboard.
- **Automatic (follow platform profile)** and manual fan-profile selection are supported and persisted.
- Built-in system custom profiles are read-only; create a user copy before editing.
- Firmware-controlled profiles remain non-convertible because Acer firmware does not expose their internal curves.

## Profile editor and visualization

- Profile Settings uses independently scrolling editor/preview panes with a fixed header/footer.
- Fan-output previews use a 0..110% display scale while valid output remains capped at 100%.
- Controller-dynamics preview visualizes rising/falling EMA behavior, CPU hysteresis, CPU down delay and GPU native down delay.
- Dashboard history uses a 30..110 °C visual scale so 100 °C telemetry does not stick to the graph border.

## Packaging and integration

- Standalone system install under `/usr/local/lib/acer-control`.
- D-Bus/polkit/systemd integration.
- DKMS RGB bridge 0.3 with optional persistent MOK signing configuration for Secure Boot.
- GNOME/Freedesktop desktop entries and application icons.
- Upgrade installs preserve local settings and user-created fan profiles while refreshing package-owned built-in profiles.
- English/Russian localization with Auto/system-language selection.

## Known release-candidate limitation

Custom fan-profile execution still depends on the previously developed legacy `/usr/local/sbin/acer-fan-control` PWM writer. The new daemon stores and validates profiles but does not yet own the production PWM loop on a clean installation.
