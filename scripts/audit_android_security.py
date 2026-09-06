#!/usr/bin/env python3
from pathlib import Path
import sys
import xml.etree.ElementTree as ET

ANDROID_NS = "http://schemas.android.com/apk/res/android"
A = f"{{{ANDROID_NS}}}"

manifest_path = Path("android/app/src/main/AndroidManifest.xml")
backup_rules = Path("android/app/src/main/res/xml/backup_rules.xml")
data_rules = Path("android/app/src/main/res/xml/data_extraction_rules.xml")

for path in (manifest_path, backup_rules, data_rules):
    if not path.exists():
        raise SystemExit(f"Missing required Android hardening file: {path}")

root = ET.parse(manifest_path).getroot()
app = root.find("application")
if app is None:
    raise SystemExit("AndroidManifest.xml has no <application>")

if app.get(A + "allowBackup") != "false":
    raise SystemExit("android:allowBackup must be false")
if app.get(A + "fullBackupContent") != "@xml/backup_rules":
    raise SystemExit("android:fullBackupContent must point to @xml/backup_rules")
if app.get(A + "dataExtractionRules") != "@xml/data_extraction_rules":
    raise SystemExit("android:dataExtractionRules must point to @xml/data_extraction_rules")

forbidden_permissions = {
    "android.permission.ACCESS_FINE_LOCATION",
    "android.permission.ACCESS_COARSE_LOCATION",
    "android.permission.RECORD_AUDIO",
    "android.permission.CAMERA",
    "android.permission.READ_CONTACTS",
    "android.permission.WRITE_CONTACTS",
    "android.permission.GET_ACCOUNTS",
}
requested = {
    node.get(A + "name")
    for node in root.findall("uses-permission")
    if node.get(A + "name")
}
forbidden_found = sorted(requested & forbidden_permissions)
if forbidden_found:
    raise SystemExit("Forbidden Android permissions present: " + ", ".join(forbidden_found))

backup_text = backup_rules.read_text(encoding="utf-8")
data_text = data_rules.read_text(encoding="utf-8")
for domain in ("root", "file", "database", "sharedpref", "external"):
    needle = f'domain="{domain}" path="."'
    if needle not in backup_text:
        raise SystemExit(f"backup_rules.xml does not exclude domain: {domain}")
    if data_text.count(needle) < 2:
        raise SystemExit(
            f"data_extraction_rules.xml must exclude {domain} from both cloud-backup and device-transfer"
        )

print("Android security audit PASS")
print("allowBackup=false; cloud/device-transfer exclusions present; forbidden sensitive permissions absent")
