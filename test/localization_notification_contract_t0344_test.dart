import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

void main() {
  test('T0344 notification copy is generated from TR EN AR localization keys', () async {
    final tr = await AppLocalizations.delegate.load(const Locale('tr'));
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    final ar = await AppLocalizations.delegate.load(const Locale('ar'));

    expect(tr.notificationTitle, 'Bildirimler');
    expect(en.notificationTitle, 'Notifications');
    expect(ar.notificationTitle, 'الإشعارات');

    expect(tr.notificationStorageError, contains('kapalı kaldı'));
    expect(en.notificationStorageError, contains('remain off'));
    expect(ar.notificationStorageError, contains('مغلقة'));

    expect(tr.notificationPermissionError, contains('izin verilmedi'));
    expect(en.notificationPermissionError, contains('was not granted'));
    expect(ar.notificationPermissionError, contains('إذن الإشعارات'));
  });
}
