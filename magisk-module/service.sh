#!/system/bin/sh

PKG=im.angry.openeuicc

while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 2
done

for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30; do
  pm path "$PKG" >/dev/null 2>&1 && break
  cmd package install-existing "$PKG" >/dev/null 2>&1 || true
  sleep 2
done

pm grant "$PKG" android.permission.READ_PHONE_STATE >/dev/null 2>&1 || true
pm grant "$PKG" android.permission.POST_NOTIFICATIONS >/dev/null 2>&1 || true
