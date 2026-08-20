import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/shared/tokens/tokens.dart';

void main() {
  group('AppTheme Verification', () {
    test('Light theme satisfies Material 3 and token specifications', () {
      final theme = AppTheme.lightTheme;

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.secondary);
      expect(theme.colorScheme.surface, AppColors.surface);
      expect(theme.colorScheme.error, AppColors.error);

      // Buttons height 48dp as required in UI_UX_SYSTEM.md
      final elevatedButtonStyle = theme.elevatedButtonTheme.style;
      final minSize = elevatedButtonStyle?.minimumSize?.resolve({});
      expect(minSize?.height, 48.0);

      final outlinedButtonStyle = theme.outlinedButtonTheme.style;
      final outlinedMinSize = outlinedButtonStyle?.minimumSize?.resolve({});
      expect(outlinedMinSize?.height, 48.0);
    });

    test('Dark theme satisfies Material 3 and token specifications', () {
      final theme = AppTheme.darkTheme;

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundDark);
      expect(theme.colorScheme.primary, AppColors.primaryLight);
      expect(theme.colorScheme.secondary, AppColors.secondary);
      expect(theme.colorScheme.surface, AppColors.surfaceDark);
      expect(theme.colorScheme.error, AppColors.error);

      // Buttons height 48dp
      final elevatedButtonStyle = theme.elevatedButtonTheme.style;
      final minSize = elevatedButtonStyle?.minimumSize?.resolve({});
      expect(minSize?.height, 48.0);
    });
  });
}
