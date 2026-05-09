PKG=im.angry.openeuicc

if ! command -v ui_print >/dev/null 2>&1; then
  ui_print() { echo "$1"; }
fi

abort_install() {
  if command -v abort >/dev/null 2>&1; then
    abort "$1"
  fi

  ui_print "$1"
  exit 1
}

case "${KSU_VER_CODE:-0}" in
  ''|*[!0-9]*) KSU_VER_CODE_NUM=0 ;;
  *) KSU_VER_CODE_NUM=$KSU_VER_CODE ;;
esac

if [ "${KSU:-false}" = "true" ] && [ "$KSU_VER_CODE_NUM" -ge 30000 ] && [ ! -e /data/adb/metamodule ]; then
  abort_install "KernelSU 3.x requires a metamodule such as meta-overlayfs before installing OpenEUICC."
fi

chmod 0755 "$MODPATH/uninstall.sh"
[ -f "$MODPATH/service.sh" ] && chmod 0755 "$MODPATH/service.sh"

if [ -d "$MODPATH/system/system_ext" ]; then
  find "$MODPATH/system/system_ext" -type d -exec chmod 0755 {} \;
  find "$MODPATH/system/system_ext" -type f -exec chmod 0644 {} \;
fi

if pm path "$PKG" 2>/dev/null | grep -q '^package:/data/app/'; then
  ui_print "- Removing existing data app copy"
  pm uninstall "$PKG" >/dev/null 2>&1 || true
fi

ui_print "- Reboot is required for OpenEUICC to load as a privileged app"
