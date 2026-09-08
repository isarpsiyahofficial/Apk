#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
SMOKE_ACTIVITY="$PACKAGE/.ShareSheetSmokeActivity"
PREFS='shared_prefs/islami_hayat_share_t0251_smoke.xml'

read_prefs() {
  adb shell run-as "$PACKAGE" cat "$PREFS" 2>/dev/null | tr -d '\r' || true
}

dump_chooser() {
  adb shell uiautomator dump /sdcard/t0251-chooser.xml >/dev/null 2>&1 || true
  adb pull /sdcard/t0251-chooser.xml /tmp/t0251-chooser.xml >/dev/null 2>&1 || true
}

wait_for_prefs() {
  EXPECTED_STATUS="$1"
  EXPECTED_DESTINATION="$2"
  ATTEMPT=1
  while [ "$ATTEMPT" -le 6 ]; do
    PREFS_TEXT="$(read_prefs)"
    if printf '%s\n' "$PREFS_TEXT" | grep -Fq ">$EXPECTED_STATUS<" && \
       printf '%s\n' "$PREFS_TEXT" | grep -Fq ">$EXPECTED_DESTINATION<"; then
      printf '%s\n' "$PREFS_TEXT"
      return 0
    fi
    sleep 1
    ATTEMPT=$((ATTEMPT + 1))
  done
  echo "T0251 expected status=$EXPECTED_STATUS destination=$EXPECTED_DESTINATION not observed" >&2
  printf '%s\n' "$PREFS_TEXT" >&2
  return 1
}

# General share must open Android's real chooser and expose only a content:// URI.
adb shell am force-stop "$PACKAGE"
adb shell am start -n "$SMOKE_ACTIVITY" --es destination general --es format square11 >/tmp/t0251-general-start.txt
sleep 2
PREFS_TEXT="$(read_prefs)"
printf '%s\n' "$PREFS_TEXT" | grep -F '>launched<'
printf '%s\n' "$PREFS_TEXT" | grep -F '>general<'

# Hosted Android images can occasionally surface a transient launcher/Quickstep
# ANR dialog over the chooser immediately after boot. Keep the real chooser test,
# but dismiss only that system overlay and retry the UI dump instead of treating
# the overlay as evidence that our share target is missing.
FOUND_SINK=0
ATTEMPT=1
while [ "$ATTEMPT" -le 6 ]; do
  dump_chooser
  if grep -Fq 'T0251 Share Sink' /tmp/t0251-chooser.xml 2>/dev/null; then
    FOUND_SINK=1
    break
  fi
  if grep -Fq "Quickstep isn't responding" /tmp/t0251-chooser.xml 2>/dev/null; then
    adb shell input keyevent 4 >/dev/null 2>&1 || true
  fi
  sleep 1
  ATTEMPT=$((ATTEMPT + 1))
done

if [ "$FOUND_SINK" -ne 1 ]; then
  echo 'T0251 Android chooser did not expose the debug share sink target' >&2
  cat /tmp/t0251-chooser.xml >&2 || true
  adb shell dumpsys activity top >&2 || true
  exit 1
fi

TARGET="$(python3 - /tmp/t0251-chooser.xml <<'PY'
import re, sys, xml.etree.ElementTree as ET
root = ET.parse(sys.argv[1]).getroot()
for node in root.iter('node'):
    text = (node.attrib.get('text') or '') + ' ' + (node.attrib.get('content-desc') or '')
    if 'T0251 Share Sink' not in text:
        continue
    m = re.fullmatch(r'\[(\d+),(\d+)\]\[(\d+),(\d+)\]', node.attrib.get('bounds') or '')
    if m:
        x1,y1,x2,y2 = map(int,m.groups())
        print((x1+x2)//2, (y1+y2)//2)
        break
PY
)"
if [ -z "$TARGET" ]; then
  echo 'T0251 chooser target coordinates could not be resolved' >&2
  exit 1
fi
set -- $TARGET
adb shell input tap "$1" "$2"
sleep 2
PREFS_TEXT="$(read_prefs)"
printf '%s\n' "$PREFS_TEXT" | grep -F '>received_png<'
printf '%s\n' "$PREFS_TEXT" | grep -F '>content<'
echo 'T0251 general Android chooser + content URI read grant PASS'

# Hosted CI does not ship Instagram or WhatsApp. Their absence must fail closed;
# never silently route a targeted request into the general chooser. Activity
# startup can be delayed for a few seconds on a just-booted hosted emulator, so
# poll the exact persisted status instead of weakening the assertion.
for CASE in 'instagramStory instagramStory916' 'whatsapp whatsappStatus916'; do
  set -- $CASE
  adb shell am force-stop "$PACKAGE"
  adb shell am start -n "$SMOKE_ACTIVITY" --es destination "$1" --es format "$2" >/dev/null
  wait_for_prefs package_unavailable "$1" >/dev/null
done

# Wrong target/format combinations are rejected before an Android intent starts.
adb shell am force-stop "$PACKAGE"
adb shell am start -n "$SMOKE_ACTIVITY" --es destination instagramStory --es format square11 >/dev/null
wait_for_prefs invalid_request instagramStory >/dev/null
echo 'T0251 targeted-app unavailable + invalid-format failure paths PASS'
