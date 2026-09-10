#!/usr/bin/env bash
set -e

THEME_NAME="oneshot"
THEME_DIR="/boot/grub/themes/${THEME_NAME}"
GRUB_CONFIG="/etc/default/grub"

if [ "$EUID" -ne 0 ]; then
  echo "[!] Запустите скрипт с правами root: sudo ./install.sh"
  exit 1
fi

echo "==> Создание бэкапа /etc/default/grub..."
cp -n "$GRUB_CONFIG" "${GRUB_CONFIG}.oneshot.bak"

echo "==> Копирование темы в ${THEME_DIR}..."
mkdir -p "$THEME_DIR"
cp -r theme/* "$THEME_DIR/"

echo "==> Обновление конфигурации GRUB..."
# Удаление старых строк параметров, если они уже были
sed -i '/^GRUB_THEME=/d' "$GRUB_CONFIG"
sed -i '/^GRUB_GFXMODE=/d' "$GRUB_CONFIG"

# Добавление актуальных настроек
echo "GRUB_GFXMODE=\"1920x1080\"" >> "$GRUB_CONFIG"
echo "GRUB_THEME=\"${THEME_DIR}/theme.txt\"" >> "$GRUB_CONFIG"

echo "==> Применение настроек..."
update-grub

echo "[✓] Тема OneShot успешно установлена!"
