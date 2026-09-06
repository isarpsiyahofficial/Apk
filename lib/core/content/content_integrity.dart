import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Cryptographic integrity contract for bundled religious content.
///
/// The application must fail closed when a critical dataset does not match the
/// SHA-256 recorded at release time. This prevents corrupted or accidentally
/// modified Qur'an, translation, dua, dhikr, history and prophet datasets from
/// being rendered as trusted production content.
final class ContentIntegrity {
  const ContentIntegrity._();

  static String sha256Utf8(String content) {
    return sha256.convert(utf8.encode(content)).toString();
  }

  /// Hash raw asset bytes without newline, Unicode, BOM or text normalization.
  static String sha256Bytes(Uint8List bytes) {
    return sha256.convert(bytes).toString();
  }

  static bool hasValidSha256({
    required String content,
    required String expectedSha256,
  }) {
    final normalizedExpected = expectedSha256.trim().toLowerCase();
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(normalizedExpected)) {
      return false;
    }
    return sha256Utf8(content) == normalizedExpected;
  }

  static bool hasValidByteSha256({
    required Uint8List bytes,
    required String expectedSha256,
  }) {
    final normalizedExpected = expectedSha256.trim().toLowerCase();
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(normalizedExpected)) {
      return false;
    }
    return sha256Bytes(bytes) == normalizedExpected;
  }

  static void requireValidSha256({
    required String datasetId,
    required String content,
    required String expectedSha256,
  }) {
    if (!hasValidSha256(
      content: content,
      expectedSha256: expectedSha256,
    )) {
      throw ContentIntegrityException(datasetId);
    }
  }

  static void requireValidByteSha256({
    required String datasetId,
    required Uint8List bytes,
    required String expectedSha256,
  }) {
    if (!hasValidByteSha256(
      bytes: bytes,
      expectedSha256: expectedSha256,
    )) {
      throw ContentIntegrityException(datasetId);
    }
  }
}

final class ContentIntegrityException implements Exception {
  const ContentIntegrityException(this.datasetId);

  final String datasetId;

  @override
  String toString() =>
      'ContentIntegrityException: trusted dataset "$datasetId" failed SHA-256 verification.';
}
