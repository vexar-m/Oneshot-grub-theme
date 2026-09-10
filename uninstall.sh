#!/usr/bin/env bash
set -e

THEME_DIR="/boot/grub/themes/oneshot"
GRUB_CONFIG="/etc/default/grub"

if [ "$EUID" -ne 0 ]; then
  echo "[!] Запустите скрипт с правами root: sudo ./uninstall.sh"
  exit 1
fi

echo "==> Удаление темы..."
rm -rf "$THEME_DIR"

echo "==> Восстановление конфигурации..."
if [ -f "${GRUB_CONFIG}.oneshot.bak" ]; then
  mv "${GRUB_CONFIG}.oneshot.bak" "$GRUB_CONFIG"
else
  sed -i '/^GRUB_THEME=/d' "$GRUB_CONFIG"
fi

update-grub

echo "[✓] Тема успешно удалена, исходный GRUB восстановлен!"
