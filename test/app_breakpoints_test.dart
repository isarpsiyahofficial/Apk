import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/responsive/app_breakpoints.dart';

void main() {
  group('AppBreakpoints', () {
    test('uses compact layout through 599px', () {
      expect(AppBreakpoints.isCompact(320), isTrue);
      expect(AppBreakpoints.isCompact(599), isTrue);
      expect(AppBreakpoints.isCompact(600), isFalse);
    });

    test('uses medium layout from 600 through 839px', () {
      expect(AppBreakpoints.isMedium(600), isTrue);
      expect(AppBreakpoints.isMedium(839), isTrue);
      expect(AppBreakpoints.isMedium(840), isFalse);
    });

    test('switches to navigation rail at tablet and wide emulator widths', () {
      expect(AppBreakpoints.useNavigationRail(839), isFalse);
      expect(AppBreakpoints.useNavigationRail(840), isTrue);
      expect(AppBreakpoints.useNavigationRail(1280), isTrue);
      expect(AppBreakpoints.useNavigationRail(1920), isTrue);
    });
  });
}
