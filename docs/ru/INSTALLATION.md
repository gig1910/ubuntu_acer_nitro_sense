# Установка и обновление

[English version](../INSTALLATION.md)

## Проверенная development-система

Сейчас release проверяется на Acer Nitro AN515-58 с Ubuntu 26.04 и стандартным Ubuntu kernel/userspace stack. Installer рассчитан на Ubuntu/Debian-подобную систему, но совместимость пакетов и совместимость аппаратного WMI-интерфейса — разные вещи.

## Установка из clone

```bash
git clone https://github.com/gig1910/ubuntu_acer_nitro_sense.git
cd ubuntu_acer_nitro_sense
sudo ./install.sh
```

Опции:

```text
--no-apt      Не устанавливать отсутствующие пакеты через apt.
-y, --yes     Принять обычные значения по умолчанию; Secure Boot signing всё равно требует отдельного выбора.
```

Installer проверяет GTK/Python, D-Bus/polkit, DKMS, toolchain и headers текущего ядра и при необходимости ставит зависимости через apt.

## Обновление

Новая версия ставится поверх установленной:

```bash
sudo ./install.sh
```

Обновляются package-owned файлы и встроенные system fan profiles, но сохраняются:

- `/etc/acer-control/acer-control.conf`;
- пользовательские fan profiles;
- legacy `/usr/local/sbin/acer-fan-control`, если он уже существует.

Зарезервированные system ID: `low-power`, `quiet`, `balanced`, `balanced-performance`, `performance`. Если файл с таким ID явно имеет `kind=user`, installer его не перезаписывает.

## Куда устанавливается

```text
/usr/local/lib/acer-control/acer_control/
/usr/local/bin/acer-control
/usr/local/bin/acer-control-settings
/usr/local/bin/acer-control-diagnose
/usr/local/sbin/acer-control-uninstall
/etc/acer-control/
/etc/systemd/system/acer-control-daemon.service
/usr/share/dbus-1/system.d/org.acer.Control.conf
/usr/share/polkit-1/actions/org.acer.control.policy
/etc/polkit-1/rules.d/49-acer-control.rules
/usr/share/applications/org.acer.Control.UI.desktop
/usr/share/applications/org.acer.Control.UI.Settings.desktop
/usr/share/icons/hicolor/*/apps/org.acer.Control.UI.png
/usr/src/acer-control-rgb-0.3/
/etc/modules-load.d/acer-control-rgb.conf
```

Application ID, desktop filename и icon name согласованы как `org.acer.Control.UI`, чтобы GNOME/Wayland связывал окно с нашей иконкой.

## Secure Boot и подпись DKMS

RGB bridge — внешний kernel module. При включённом Secure Boot модуль обычно должен быть подписан доверенным ключом.

Installer умеет использовать стандартную Ubuntu MOK-пару:

```text
/var/lib/shim-signed/mok/MOK.priv
/var/lib/shim-signed/mok/MOK.der
```

или пользовательскую пару key/certificate.

Постоянная настройка DKMS signing сохраняется в:

```text
/etc/dkms/framework.conf.d/90-acer-control-signing.conf
```

Это **глобальная настройка DKMS**, поэтому ключ может использоваться и другими DKMS-модулями. Перед изменением installer спрашивает подтверждение.

Если сертификат ещё не enrolled, можно запустить `mokutil --import`, а после reboot завершить enrollment в MokManager.

## Сборка самостоятельного installer

```bash
./tools/build-release.sh
```

Установка результата:

```bash
chmod +x dist/acer-control-*-installer.run
sudo dist/acer-control-*-installer.run
```

Только распаковать:

```bash
dist/acer-control-*-installer.run --extract ./acer-control-installer
```

## Диагностика

```bash
acer-control-diagnose
```

## Удаление

Сохранить `/etc/acer-control`:

```bash
sudo /usr/local/sbin/acer-control-uninstall
```

Удалить и конфигурацию:

```bash
sudo /usr/local/sbin/acer-control-uninstall --purge
```
