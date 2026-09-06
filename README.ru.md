# Acer Control для Ubuntu на Acer Nitro

[English README](README.md)

Acer Control — экспериментальный центр управления на GTK4/libadwaita для ноутбуков Acer Nitro под Linux. Он объединяет живую телеметрию, переключение Acer platform profile, редактор и визуализацию профилей вентиляторов и аппаратное управление RGB-клавиатурой через привилегированный системный D-Bus daemon.

> **Статус проекта:** `0.1.0-rc12`. Основная аппаратная проверка сейчас ведётся на **Acer Nitro AN515-58** с **Ubuntu 26.04**. Другие модели Acer могут использовать другие WMI-методы и поведение прошивки и считаются непроверенными до отдельного тестирования.

## Возможности

- Температуры CPU/GPU, RPM вентиляторов и история текущего запуска на 5/10 минут.
- Переключение ACPI `platform_profile` и сохранение профиля платформы по умолчанию.
- Раздельный выбор **профиля платформы** и **профиля управления вентиляторами**.
- Защищённые встроенные fan profiles и редактируемые пользовательские копии.
- Интерактивный редактор кривых и симуляция контроллера с EMA, гистерезисом и задержками снижения.
- 4-зонная RGB-клавиатура с аппаратными эффектами Static, Breath, Neon, Wave, Shifting и Zoom.
- Аппаратный таймаут подсветки клавиатуры на совместимой прошивке.
- Системный daemon root через D-Bus + polkit; GUI запускается от обычного пользователя.
- DKMS-модуль RGB WMI bridge и опциональная подпись MOK для Secure Boot.
- Интерфейс EN/RU с режимом Auto по локали графической сессии.
- Самостоятельный installer, диагностика и uninstall.

## Важное ограничение RC

Текущий daemon обслуживает телеметрию, platform profiles, хранение/редактор fan profiles и RGB-клавиатуру. Рабочий custom PWM-loop, разработанный раньше, **ещё не перенесён в daemon**. Если `/usr/local/sbin/acer-fan-control` уже установлен, installer его сохраняет. На чистой системе без legacy writer пользовательские кривые можно создавать и хранить, но они пока не исполняются. Управление вентиляторами прошивкой и Acer platform profiles продолжают работать.

Это основной архитектурный хвост перед полностью самостоятельным fan-control release.

## Установка

```bash
git clone https://github.com/gig1910/ubuntu_acer_nitro_sense.git
cd ubuntu_acer_nitro_sense
sudo ./install.sh
```

Тот же installer используется для обновления поверх предыдущей версии. Существующие `/etc/acer-control/acer-control.conf` и пользовательские профили сохраняются.

При включённом Secure Boot installer может использовать уже enrolled MOK либо настроить DKMS signing интерактивно. Подробнее: [Установка](docs/ru/INSTALLATION.md).

## Сборка самостоятельного installer

```bash
./tools/build-release.sh
```

Артефакты появляются в `dist/`:

```text
acer-control-<version>.tar.gz
acer-control-<version>-installer.run
acer-control-<version>.SHA256SUMS
```

## Документация

- [Установка и обновление](docs/ru/INSTALLATION.md)
- [Архитектура](docs/ru/ARCHITECTURE.md)
- [Совместимость](docs/ru/COMPATIBILITY.md)
- [Профили вентиляторов и параметры контроллера](docs/ru/FAN-PROFILES.md)
- [RGB-клавиатура и WMI bridge](docs/ru/KEYBOARD-RGB.md)
- [D-Bus API](docs/ru/DBUS-API.md)
- [Диагностика и типовые проблемы](docs/ru/TROUBLESHOOTING.md)
- [Разработка и сборка релиза](docs/ru/DEVELOPMENT.md)
- [Текущие release notes](RELEASE-NOTES.md)

## Диагностика

```bash
acer-control-diagnose
```

## Аппаратная область

Программа записывает firmware-facing параметры и устанавливает внешний kernel module. Используемые методы проверены на development AN515-58, но совместимость с другими Acer Nitro должна подтверждаться отдельно.

Встроенные системные fan profiles доступны только для чтения. `Performance` используется как read-only custom template: его можно скопировать в пользовательский профиль и уже копию редактировать. Firmware-профили не выдаются за редактируемые копии, потому что Acer firmware не предоставляет их внутренние кривые.

## Лицензия

Открытая лицензия пока не выбрана. До появления `LICENSE` действуют обычные нормы авторского права.

## Disclaimer

Проект независимый, не связан с Acer Inc. и не одобрен Acer. `Acer`, `Nitro` и связанные названия являются торговыми марками соответствующих владельцев.
