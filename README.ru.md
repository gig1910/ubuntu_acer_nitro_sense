# Acer Control для Ubuntu на Acer Nitro

[English README](README.md)

Acer Control — экспериментальный центр управления на GTK4/libadwaita для ноутбуков Acer Nitro под Linux. Он объединяет телеметрию, переключение Acer platform profile, редактор и визуализацию профилей вентиляторов и аппаратное управление RGB-клавиатурой через привилегированный системный D-Bus daemon.

> **Статус проекта:** release candidate `0.1.0-rc10`. Разработка и аппаратная проверка сейчас ведутся прежде всего на **Acer Nitro AN515-58** с **Ubuntu 26.04**. Другие модели Acer могут использовать другие WMI-методы и поведение прошивки и считаются непроверенными до отдельного тестирования.

## Возможности

- Dashboard GTK4/libadwaita с температурами CPU/GPU, RPM вентиляторов и историей текущего запуска.
- Переключение ACPI `platform_profile` и сохранение профиля по умолчанию.
- Библиотека профилей вентиляторов: защищённые системные профили и редактируемые пользовательские копии.
- Интерактивный редактор кривых и симуляция контроллера с отображением EMA, гистерезиса и задержки снижения.
- 4-зонная RGB-клавиатура с аппаратными эффектами Static, Breath, Neon, Wave, Shifting и Zoom.
- Аппаратный таймаут подсветки клавиатуры, когда он поддерживается firmware-интерфейсом.
- Системный daemon root через D-Bus + polkit; сам GUI запускается от обычного пользователя.
- DKMS-модуль RGB WMI bridge и опциональная настройка подписи MOK для Secure Boot.
- Интерфейс EN/RU с режимом Auto по локали графической сессии.
- Самостоятельный установщик, диагностика и удаление.

## Важное ограничение RC

Текущий daemon обслуживает телеметрию, platform profiles, хранение/редактор профилей и RGB-клавиатуру. Рабочий PWM-loop, разработанный раньше, **ещё не перенесён в daemon**. Если `/usr/local/sbin/acer-fan-control` уже установлен, installer его сохраняет. На чистой системе без legacy writer пользовательские кривые можно редактировать и хранить, но они пока не исполняются. Управление вентиляторами прошивкой и Acer platform profiles продолжают работать.

Это основной архитектурный хвост перед полностью самостоятельным fan-control release.

## Быстрая установка из исходников

```bash
git clone https://github.com/gig1910/ubuntu_acer_nitro_sense.git
cd ubuntu_acer_nitro_sense
sudo ./install.sh
```

Тот же installer используется для обновления поверх предыдущей версии. Существующие `/etc/acer-control/acer-control.conf` и пользовательские профили не удаляются.

Для Secure Boot installer может использовать уже enrolled MOK или настроить DKMS signing интерактивно. Подробнее: [Установка](docs/ru/INSTALLATION.md).

## Сборка самостоятельного `.run`

```bash
./tools/build-release.sh
```

Результат появляется в `dist/`:

```text
acer-control-<version>.tar.gz
acer-control-<version>-installer.run
acer-control-<version>.SHA256SUMS
```

## Документация

- [Установка и обновление](docs/ru/INSTALLATION.md)
- [Архитектура](docs/ru/ARCHITECTURE.md)
- [Статус совместимости](docs/ru/COMPATIBILITY.md)
- [Профили вентиляторов и параметры контроллера](docs/ru/FAN-PROFILES.md)
- [RGB-клавиатура и WMI bridge](docs/ru/KEYBOARD-RGB.md)
- [D-Bus API](docs/ru/DBUS-API.md)
- [Диагностика и типовые проблемы](docs/ru/TROUBLESHOOTING.md)
- [Разработка и сборка релиза](docs/ru/DEVELOPMENT.md)
- [Текущие release notes](RELEASE-NOTES.md)

## Диагностика

После установки:

```bash
acer-control-diagnose
```

Полезные ручные проверки:

```bash
systemctl status acer-control-daemon.service
modinfo acer_control_rgb_bridge
cat /sys/kernel/acer_control_rgb/capabilities
busctl introspect org.acer.Control /org/acer/Control org.acer.Control
```

## Аппаратная область и безопасность

Программа записывает firmware-facing параметры и устанавливает внешний kernel module. Используемые методы проверены на development AN515-58, но это не означает автоматической совместимости со всеми Acer Nitro. Совпадения имени линейки недостаточно.

GUI специально не разрешает редактировать package-owned system fan profiles. `Performance` — read-only custom template: его можно скопировать в пользовательский профиль и уже копию редактировать. Firmware-профили не выдаются за редактируемую копию, потому что Acer firmware не предоставляет их внутренние кривые.

## Лицензия

Открытая лицензия для репозитория пока не выбрана. Пока файл лицензии не добавлен, действуют обычные нормы авторского права. Перед распространением проекта как полноценного open-source пакета этот вопрос нужно решить отдельно.

## Disclaimer

Проект независимый и не связан с Acer Inc. и не одобрен Acer. `Acer`, `Nitro` и связанные названия являются торговыми марками соответствующих владельцев.
