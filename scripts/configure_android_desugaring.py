#!/usr/bin/env python3
from pathlib import Path
import re

path = Path('android/app/build.gradle.kts')
text = path.read_text(encoding='utf-8')

if 'isCoreLibraryDesugaringEnabled = true' not in text:
    compile_match = re.search(r'(?m)^\s*compileOptions\s*\{', text)
    if compile_match:
        start = compile_match.end()
        text = text[:start] + '\n        isCoreLibraryDesugaringEnabled = true' + text[start:]
    else:
        android_match = re.search(r'(?m)^android\s*\{', text)
        if not android_match:
            raise SystemExit('android block not found in generated build.gradle.kts')
        start = android_match.end()
        text = text[:start] + '''\n    compileOptions {\n        isCoreLibraryDesugaringEnabled = true\n        sourceCompatibility = JavaVersion.VERSION_11\n        targetCompatibility = JavaVersion.VERSION_11\n    }''' + text[start:]

if 'coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:' not in text:
    text += '''\n\ndependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")\n}\n'''

path.write_text(text, encoding='utf-8')
print('Android core-library desugaring configured for notification plugin.')
