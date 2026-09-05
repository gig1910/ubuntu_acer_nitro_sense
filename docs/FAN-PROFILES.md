# Fan profiles and controller parameters

[Русская версия](ru/FAN-PROFILES.md)

## Profile classes

Acer Control currently ships five reserved system profile IDs:

| ID | Display name | Mode | Editable? |
|---|---|---|---|
| `low-power` | Low Power | firmware | no |
| `quiet` | Quiet | firmware | no |
| `balanced` | Balanced | firmware | no |
| `balanced-performance` | Balanced Performance | firmware | no |
| `performance` | Performance | custom template | copy first |

System profiles are package-owned and read-only. Firmware profiles cannot be truthfully converted into editable copies because Acer firmware does not expose their internal fan curves. `Performance` is a known custom template and can be duplicated. The resulting `kind=user` profile is editable, savable and deletable.

## CPU curve

A curve point is `temperature:fan_percent`, for example:

```text
70:40,80:50,86:60,90:70,94:80,96:90,98:100
```

The editor intentionally draws the fan-output axis to 110% while valid values stop at 100%, so a 100% plateau remains visually separated from the top border.

## EMA alpha up/down

EMA smooths the measured temperature before it drives the policy:

```text
filtered = alpha * new_sample + (1 - alpha) * previous_filtered
```

A higher alpha reacts faster. Separate values are used for rising and falling temperature so the controller can respond aggressively to heating but relax differently while cooling.

The controller-dynamics graph visualizes both the raw input temperature and filtered CPU/GPU temperatures.

## Hysteresis

CPU hysteresis prevents rapid fan-level toggling near a curve threshold. When the temperature falls, the controller requires additional cooling below the threshold before allowing the lower target. A larger hysteresis creates a wider hold region.

The dynamics graph marks time intervals where hysteresis is holding the previous CPU output.

## Down delay

`down_delay` keeps the current CPU fan target for a configured period after a lower target becomes eligible. It avoids immediately reducing cooling after a short temperature dip.

The GPU side has `native_down_delay` with the analogous purpose for its native temperature/utilization path.

## Emergency temperature

`emergency_temp` is the CPU safety threshold used by the custom policy. It should remain a high-temperature escape condition rather than a normal curve-control point.

## GPU assist from CPU fan level

The `[gpu-assist]` curve maps CPU fan level to a minimum/assisted GPU fan level. This lets the second fan contribute when the CPU side is already demanding substantial cooling.

Every CPU fan level that the controller may emit should have a defined/interpolatable mapping. The editor validation reports gaps that would make the mapping ambiguous.

## GPU native policy

The GPU section contains:

- `temp_curve`: GPU temperature -> fan target;
- `util_curve`: GPU utilization -> fan target;
- `temp_ema_alpha_up` / `temp_ema_alpha_down`;
- `native_down_delay`;
- `util_load_threshold`;
- `power_load_threshold`;
- `telemetry_failsafe`;
- `nvidia_smi_timeout`.

NVIDIA polling is designed to avoid waking a runtime-suspended discrete GPU merely to collect telemetry when possible.

## Controller visualization

The third preview is meant to make these parameters understandable without requiring the user to reason from raw numbers. It simulates a heating/holding/cooling scenario and displays:

- input temperature;
- CPU/GPU EMA temperature;
- requested CPU/GPU targets;
- outputs after hold logic;
- highlighted hysteresis and down-delay intervals.

It is a visualization, not a live hardware trace.

## RC limitation

In `0.1.0-rc10`, Acer Control stores and validates custom user profiles, but the daemon does not yet execute the production PWM loop on a clean installation. See [Architecture](ARCHITECTURE.md).
