# Диагностика и типовые проблемы

[English version](../TROUBLESHOOTING.md)

Начинать лучше со штатного отчёта:

```bash
acer-control-diagnose
```

## Daemon недоступен

```bash
systemctl status acer-control-daemon.service --no-pager
journalctl -u acer-control-daemon.service -b --no-pager
busctl introspect org.acer.Control /org/acer/Control org.acer.Control
```

Установленный service должен запускать Python из `/usr/local/lib/acer-control`, а не из development home directory.

## В GUI нет RGB

```bash
lsmod | grep acer_control_rgb_bridge
modinfo acer_control_rgb_bridge | grep -E '^(filename|version|signer|sig_hashalgo):'
cat /sys/kernel/acer_control_rgb/capabilities
```

Для rc10 ожидается bridge version `0.3`.

При Secure Boot неподписанный или не enrolled module не загрузится:

```bash
mokutil --sb-state
sudo dmesg | grep -iE 'acer_control_rgb|verification|signature|secure boot'
```

## Не отображается keyboard timeout

Проверить bridge:

```bash
cat /sys/kernel/acer_control_rgb/backlight_timeout
```

и D-Bus:

```bash
busctl call org.acer.Control /org/acer/Control org.acer.Control GetKeyboardLighting
```

Switch появляется только если backend сообщает поддержку timeout.

## CPU temperature показывает 100 °C

Acer Control читает package sensor `coretemp` и не должен искусственно прижимать обычную температуру к 100 °C. Сначала сравнить raw hwmon:

```bash
for h in /sys/class/hwmon/hwmon*; do
  [ "$(cat "$h/name" 2>/dev/null)" = coretemp ] || continue
  for l in "$h"/temp*_label; do
    [ -e "$l" ] || continue
    base="${l%_label}"
    printf '%-18s %6.1f °C\n' "$(cat "$l")" "$(awk '{print $1/1000}' "${base}_input")"
  done
done
```

Dashboard специально рисует temperature scale до 110 °C, чтобы реальная линия 100 °C не прилипала к верхней границе.

## Custom profile редактируется, но на чистой установке не управляет fans

Это известное RC-ограничение: production PWM execution пока остаётся в legacy `/usr/local/sbin/acer-fan-control`. Новый daemon ещё не заменил этот компонент. См. [Профили вентиляторов](FAN-PROFILES.md).

## Installer падает на `apt update`

`apt-get update` запускается только если не хватает dependencies. Сломанный сторонний repository может прервать установку. Исправьте/отключите его, заранее установите packages или используйте `--no-apt`, когда зависимости уже присутствуют.
