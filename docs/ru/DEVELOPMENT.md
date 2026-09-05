# Разработка и сборка релиза

[English version](../DEVELOPMENT.md)

## Структура исходников

```text
acer_control/        Python GTK/D-Bus application и hardware backends
defaults/            package-owned defaults и fan profiles
kernel/rgb/          DKMS keyboard RGB bridge
packaging/           systemd, D-Bus, polkit, desktop files и launchers
po/                  gettext source translations
icons/               готовые hicolor icons
tests/               regression tests
tools/               release tooling
```

## Правила архитектуры

- GUI работает без root.
- Hardware/config writes идут через system daemon.
- Не хардкодить machine-specific paths там, где значение разумно конфигурировать или обнаруживать.
- Не заменять stock `acer_wmi` ради RGB; bridge остаётся companion module.
- Не писать неизменённый RGB state: firmware может перезапускать animation.
- Package-owned system fan profiles immutable через public API.
- Финальный fan controller должен иметь ровно одного PWM owner.

## Базовые проверки

```bash
python3 -m compileall -q acer_control

for test in tests/*_test.py; do
    PYTHONPATH=. python3 "$test"
done

bash -n install.sh
bash -n uninstall.sh
bash -n tools/build-release.sh
```

GTK-зависимые тесты требуют Python GI, GTK4 и libadwaita introspection packages.

## Локализация

English strings в source являются gettext message IDs. Русский перевод:

```text
po/ru.po
```

Runtime catalog сейчас поставляется как:

```text
acer_control/locale/ru/LC_MESSAGES/acer-control.mo
```

Preference языка — `auto`, `en` или `ru`, хранится на пользователя.

## Версия

Application version определена в:

```python
acer_control/__init__.py
```

В `install.sh` есть release version string. Они должны совпадать; release builder это проверяет.

## Release build

```bash
./tools/build-release.sh
```

Script создаёт clean staged tree, исключает Python caches, генерирует `MANIFEST.sha256`, собирает source tarball и добавляет его к self-extracting `.run` stub.

`dist/` специально исключён из Git.

## Hardware changes

Изменения WMI bridge нужно тестировать осторожно на известном hardware. После kernel update:

1. build под headers текущего ядра;
2. sign module при Secure Boot;
3. проверить signer через `modinfo`;
4. загрузить module;
5. сначала проверить `capabilities`, `dynamic`, `zones` и timeout readback, затем writes.
