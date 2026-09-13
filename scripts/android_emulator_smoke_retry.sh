#!/bin/sh
set -eu

# Hosted Android emulators occasionally expose the package path before adb's
# sync service can read the just-installed base APK. The underlying smoke test
# performs byte-for-byte APK, manifest, provider, process, activity and crash
# assertions; retrying the whole smoke once does not relax any assertion.
MAX_ATTEMPTS=2
attempt=1

while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  echo "Android emulator core smoke attempt $attempt/$MAX_ATTEMPTS"
  if sh scripts/android_emulator_smoke.sh; then
    exit 0
  fi

  if [ "$attempt" -ge "$MAX_ATTEMPTS" ]; then
    echo 'Android emulator core smoke failed after bounded retry' >&2
    exit 1
  fi

  echo 'Core smoke hit a hosted-emulator transient; waiting for adb before one full retry' >&2
  adb wait-for-device || true
  sleep 3
  attempt=$((attempt + 1))
done

exit 1
