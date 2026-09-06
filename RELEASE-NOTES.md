# 0.1.0-rc12

## Fixed

- Rebalanced the dashboard vertically so the history graph gets substantially more usable height.
- Moved the **Fan control profile** selector, effective-profile status and **Profile settings** button into the previously unused lower-left area below the NVIDIA GPU state.
- Kept platform-profile controls and keyboard lighting in the right column.
- Reduced dashboard vertical margins/spacing without changing the information density.
- Reduced the history graph minimum/natural height from 360 px to 260 px; the graph still expands to consume available height in larger or maximized windows.
- Reduced the dashboard default window height from 850 px to 720 px so it remains vertically resizable on laptop workareas with limited usable height.

## Preserved from rc11

- Platform profiles and Acer Control fan-control profiles are separate selectors.
- User-created fan profiles can be selected directly from the dashboard.
- **Automatic (follow platform profile)** and manual fan-profile selection remain available.
- Built-in system custom profiles are read-only; create a user copy before editing.
- Profile Settings keeps independent scrolling panes and a fixed header/footer.
- Controller dynamics simulation visualizes EMA, hysteresis and down-delay behavior.
- Dashboard temperature display scale remains 30..110 °C.
- RU/EN localization, DKMS/Secure Boot support and adaptive window sizing remain enabled.
