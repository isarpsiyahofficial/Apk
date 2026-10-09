import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_integrity.dart';
import 'package:islami_hayat/core/storage/integrity_checked_trusted_content_store.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';

final class _MemoryTrustedLoader implements TrustedContentLoader {
  _MemoryTrustedLoader(this.values);

  final Map<String, String> values;

  @override
  Future<String?> load(String datasetId) async => values[datasetId];
}

void main() {
  test('verified trusted content is returned read-only', () async {
    const datasetId = 'quran.ar.v1';
    const content = 'verified fixture';
    final store = IntegrityCheckedTrustedContentStore(
      loader: _MemoryTrustedLoader({datasetId: content}),
      expectedSha256ByDataset: {
        datasetId: ContentIntegrity.sha256Utf8(content),
      },
    );

    expect(store.domain, StorageDomain.trustedContent);
    expect(await store.read(datasetId), content);
  });

  test('tampered trusted content fails closed', () async {
    const datasetId = 'meal.tr.v1';
    final store = IntegrityCheckedTrustedContentStore(
      loader: _MemoryTrustedLoader({datasetId: 'tampered'}),
      expectedSha256ByDataset: {
        datasetId: ContentIntegrity.sha256Utf8('reviewed'),
      },
    );

    expect(
      () => store.read(datasetId),
      throwsA(isA<ContentIntegrityException>()),
    );
  });

  test('dataset without manifest entry fails closed', () async {
    const datasetId = 'prophets.tr.v1';
    final store = IntegrityCheckedTrustedContentStore(
      loader: _MemoryTrustedLoader({datasetId: 'content'}),
      expectedSha256ByDataset: const {},
    );

    expect(
      () => store.read(datasetId),
      throwsA(isA<MissingContentManifestException>()),
    );
  });

  test('missing bundled dataset returns null only when manifest exists', () async {
    const datasetId = 'history.tr.v1';
    final store = IntegrityCheckedTrustedContentStore(
      loader: _MemoryTrustedLoader(const {}),
      expectedSha256ByDataset: const {
        datasetId:
            'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      },
    );

    expect(await store.read(datasetId), isNull);
  });
}
