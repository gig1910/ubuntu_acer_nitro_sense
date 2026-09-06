# 0.1.0-rc12

## Исправлено

- Перебалансирован Dashboard по высоте: график истории получил больше полезного пространства.
- Selector профиля управления вентиляторами, фактически активный fan profile и кнопка настроек перенесены в свободную область под состоянием NVIDIA GPU.
- Platform-profile controls и подсветка клавиатуры оставлены справа.
- Уменьшены вертикальные отступы и минимальная высота history graph; окно снова нормально уменьшается по высоте.

## Сохранено из rc11

- Platform profiles и Acer Control fan-control profiles являются разными селекторами.
- Пользовательские fan profiles можно выбирать прямо на Dashboard.
- Есть режим **Автоматически (следовать профилю платформы)** и ручной выбор.
- Встроенные system custom profiles read-only; для редактирования сначала создаётся пользовательская копия.
- Profile Settings использует независимый scroll для панелей и фиксированные header/footer.
- Симуляция controller dynamics показывает EMA, hysteresis и down-delay.
- Шкала температуры Dashboard остаётся 30..110 °C.
- RU/EN localization, DKMS/Secure Boot и adaptive window sizing сохранены.
