# Профили вентиляторов и параметры контроллера

[English version](../FAN-PROFILES.md)

## Типы профилей

Acer Control поставляет пять зарезервированных system profile ID:

| ID | Имя | Режим | Редактирование |
|---|---|---|---|
| `low-power` | Низкое энергопотребление | firmware | нет |
| `quiet` | Тихий | firmware | нет |
| `balanced` | Сбалансированный | firmware | нет |
| `balanced-performance` | Сбалансированная производительность | firmware | нет |
| `performance` | Производительность | custom template | сначала копия |

System profiles принадлежат пакету и read-only. Firmware-профили нельзя честно превратить в редактируемую копию: Acer firmware не отдаёт их внутренние fan curves. `Performance` — известный custom template, поэтому из него можно создать пользовательскую копию. Профиль `kind=user` уже можно редактировать, сохранять и удалять.

## CPU curve

Точка кривой задаётся как `temperature:fan_percent`, например:

```text
70:40,80:50,86:60,90:70,94:80,96:90,98:100
```

На preview ось выхода специально идёт до 110%, хотя допустимый fan value ограничен 100%. Благодаря этому линия 100% визуально не прилипает к верхней рамке.

## EMA alpha up/down

EMA сглаживает температуру перед использованием в policy:

```text
filtered = alpha * new_sample + (1 - alpha) * previous_filtered
```

Чем выше alpha, тем быстрее реакция. Для роста и снижения используются отдельные значения — можно быстро реагировать на нагрев и иначе вести себя при охлаждении.

График динамики показывает и исходную температуру, и отфильтрованные CPU/GPU значения.

## Гистерезис

CPU hysteresis предотвращает постоянное переключение между уровнями возле порога кривой. При охлаждении температура должна опуститься ниже порога с дополнительным запасом, прежде чем будет разрешён меньший target. Чем больше hysteresis, тем шире область удержания.

На графике подсвечиваются интервалы, когда старый CPU output удерживается именно гистерезисом.

## Задержка снижения

`down_delay` удерживает текущий CPU target ещё заданное время после того, как снижение уже разрешено. Краткий провал температуры поэтому не приводит к немедленному снижению охлаждения.

У GPU есть `native_down_delay` с аналогичным смыслом для его native temperature/utilization path.

## Аварийная температура

`emergency_temp` — CPU safety threshold для custom policy. Это аварийная граница, а не обычная точка кривой.

## GPU assist от уровня CPU fan

Кривая `[gpu-assist]` задаёт зависимость уровня CPU fan -> дополнительный/минимальный GPU fan. Так второй вентилятор может помогать, когда CPU уже требует заметного охлаждения.

Для возможных CPU fan levels mapping должен быть определён или однозначно интерполироваться. Editor validation сообщает о пробелах.

## Native GPU policy

GPU section содержит:

- `temp_curve`: GPU temperature -> fan target;
- `util_curve`: GPU utilization -> fan target;
- `temp_ema_alpha_up` / `temp_ema_alpha_down`;
- `native_down_delay`;
- `util_load_threshold`;
- `power_load_threshold`;
- `telemetry_failsafe`;
- `nvidia_smi_timeout`.

NVIDIA polling по возможности не должен будить runtime-suspended discrete GPU только ради telemetry.

## Визуализация контроллера

Третий preview нужен именно для понимания параметров по графику, а не по абстрактным цифрам. Он моделирует нагрев, удержание и охлаждение и показывает:

- входную температуру;
- CPU/GPU EMA;
- запрошенные CPU/GPU targets;
- output после hold logic;
- области hysteresis и down delay.

Это simulation preview, а не live hardware trace.

## Ограничение RC

В `0.1.0-rc10` Acer Control хранит и проверяет custom user profiles, но на чистой установке daemon ещё не исполняет production PWM loop. Подробнее: [Архитектура](ARCHITECTURE.md).
