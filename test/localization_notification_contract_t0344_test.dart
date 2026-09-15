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

    expect(
      tr.notificationStorageError,
      'Bildirim ayarları kaydedilemedi. Kaydedilemeyen kategoriler kapalı kaldı.',
    );
    expect(
      en.notificationStorageError,
      'Notification settings could not be saved. Unsaved categories remain off.',
    );
    expect(
      ar.notificationStorageError,
      'تعذّر حفظ إعدادات الإشعارات. بقيت الفئات غير المحفوظة مغلقة.',
    );

    expect(
      tr.notificationPermissionError,
      'Bildirim izni verilmedi. Bu hatırlatma kapalı kaldı.',
    );
    expect(
      en.notificationPermissionError,
      'Notification permission was not granted. This reminder stayed off.',
    );
    expect(
      ar.notificationPermissionError,
      'لم يتم منح إذن الإشعارات. بقي هذا النوع من التذكيرات مغلقًا.',
    );
  });
}
