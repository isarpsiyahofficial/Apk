import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_integrity.dart';

void main() {
  group('ContentIntegrity', () {
    const content = 'trusted religious dataset';
    const expected =
        '7689081ce0f7c1f5002c4656cd7005953182031a915dfe1659982b3709a35345';

    test('computes deterministic SHA-256', () {
      expect(ContentIntegrity.sha256Utf8(content), expected);
    });

    test('accepts the exact release hash', () {
      expect(
        ContentIntegrity.hasValidSha256(
          content: content,
          expectedSha256: expected,
        ),
        isTrue,
      );
    });

    test('rejects modified content', () {
      expect(
        ContentIntegrity.hasValidSha256(
          content: '$content.',
          expectedSha256: expected,
        ),
        isFalse,
      );
    });

    test('rejects malformed expected hash', () {
      expect(
        ContentIntegrity.hasValidSha256(
          content: content,
          expectedSha256: 'not-a-sha256',
        ),
        isFalse,
      );
    });

    test('fails closed instead of rendering a corrupted critical dataset', () {
      expect(
        () => ContentIntegrity.requireValidSha256(
          datasetId: 'quran-arabic',
          content: 'corrupted',
          expectedSha256: expected,
        ),
        throwsA(isA<ContentIntegrityException>()),
      );
    });
  });
}
