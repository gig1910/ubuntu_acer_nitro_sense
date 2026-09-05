# RGB bridge клавиатуры

[English version](../KEYBOARD-RGB.md)

## Hardware path

Acer Control не заменяет штатный `acer_wmi`. Дополнительный `acer_control_rgb_bridge` реализует только WMI methods, которых нет в stock driver.

Проверенный keyboard WMI GUID:

```text
7A4DDFE7-5B5D-40B4-8595-4408E0CC7F56
```

Bridge публикует:

```text
/sys/kernel/acer_control_rgb/
├── capabilities
├── dynamic
├── raw_dynamic
├── zones
└── backlight_timeout
```

В rc10 module version `0.3`, установка выполняется через DKMS.

## Эффекты

| Эффект | Firmware ID | Цвет пользователя | Speed | Direction |
|---|---:|---|---|---|
| Static | 0 | по зонам | нет | нет |
| Breath | 1 | глобальный | да | нет |
| Neon | 2 | нет; firmware сама меняет цвета | да | нет |
| Wave | 3 | нет; firmware rainbow/wave | да | да |
| Shifting | 4 | глобальный | да | да |
| Zoom | 5 | глобальный | да | нет |

Brightness — аппаратное значение 0..100. Dynamic speed использует firmware levels 1..9. Direction сейчас:

```text
1 = Right to Left
2 = Left to Right
```

Анимация в UI — только визуальное объяснение выбранного hardware effect. Acer Control **не** генерирует RGB frames в software и не стримит их в клавиатуру.

## Static zones

На проверенном AN515-58 доступно четыре зоны. В GUI используется явная физическая карта key -> zone, а не простое разбиение по X: правый arrow/numpad/media block не укладывается в прямоугольные границы.

## Подавление лишних записей

Повторная запись того же dynamic effect заметно перезапускает firmware animation. Поэтому daemon сравнивает активные поля и не пишет неизменённое состояние. Slider preview имеет debounce, а Save сохраняет фактический hardware state без бессмысленного повторного применения.

## Таймаут подсветки

На проверенной машине bridge также управляет Acer backlight timeout. Firmware сообщает 30-second timeout, а sysfs attribute включает или отключает его:

```bash
cat /sys/kernel/acer_control_rgb/backlight_timeout
```

Запись/чтение `0` и `1` проверены на AN515-58. Точное поведение wake trigger на других моделях нельзя считать идентичным без тестирования.

## Secure Boot

Поскольку bridge — out-of-tree module, Secure Boot требует доверенной подписи. Installer умеет настроить DKMS на enrolled MOK. См. [Установка](INSTALLATION.md).
