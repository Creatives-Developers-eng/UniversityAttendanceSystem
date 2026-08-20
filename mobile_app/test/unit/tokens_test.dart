import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/shared/tokens/tokens.dart';

void main() {
  group('UI_UX_SYSTEM Design Tokens Verification', () {
    test('Color tokens match UI_UX_SYSTEM.md specifications exactly', () {
      expect(AppColors.primary, const Color(0xFF1E3A8A));
      expect(AppColors.primaryLight, const Color(0xFF3B82F6));
      expect(AppColors.secondary, const Color(0xFF0D9488));
      expect(AppColors.surface, const Color(0xFFFFFFFF));
      expect(AppColors.surfaceDark, const Color(0xFF1F2937));
      expect(AppColors.background, const Color(0xFFF8FAFC));
      expect(AppColors.backgroundDark, const Color(0xFF111827));
      expect(AppColors.textPrimary, const Color(0xFF0F172A));
      expect(AppColors.textSecondary, const Color(0xFF64748B));
      expect(AppColors.error, const Color(0xFFDC2626));
      expect(AppColors.success, const Color(0xFF16A34A));
      expect(AppColors.warning, const Color(0xFFD97706));
      expect(AppColors.border, const Color(0xFFE2E8F0));
      expect(AppColors.borderDark, const Color(0xFF374151));
    });

    test('Spacing tokens match UI_UX_SYSTEM.md specifications exactly', () {
      expect(AppSpacing.spacingXS, 4.0);
      expect(AppSpacing.spacingSM, 8.0);
      expect(AppSpacing.spacingMD, 16.0);
      expect(AppSpacing.spacingLG, 24.0);
      expect(AppSpacing.spacingXL, 32.0);

      // EdgeInsets helpers
      expect(AppSpacing.paddingMD, const EdgeInsets.all(16.0));
      expect(AppSpacing.paddingSM, const EdgeInsets.all(8.0));
      expect(AppSpacing.paddingLG, const EdgeInsets.all(24.0));
    });

    test('Radius tokens match UI_UX_SYSTEM.md specifications exactly', () {
      expect(AppRadius.radiusSM, 8.0);
      expect(AppRadius.radiusMD, 12.0);
      expect(AppRadius.radiusLG, 16.0);
      expect(AppRadius.radiusXL, 24.0);

      // BorderRadius helpers
      expect(AppRadius.borderRadiusSM, BorderRadius.circular(8.0));
      expect(AppRadius.borderRadiusMD, BorderRadius.circular(12.0));
      expect(AppRadius.borderRadiusLG, BorderRadius.circular(16.0));
      expect(AppRadius.borderRadiusXL, BorderRadius.circular(24.0));
    });

    test('Typography tokens configure text themes properly', () {
      final lightTextTheme = AppTypography.createTextTheme(isDark: false);
      expect(lightTextTheme.displayLarge?.color, AppColors.textPrimary);
      expect(lightTextTheme.bodySmall?.color, AppColors.textSecondary);

      final darkTextTheme = AppTypography.createTextTheme(isDark: true);
      expect(darkTextTheme.displayLarge?.color, AppColors.textPrimaryDark);
      expect(darkTextTheme.bodySmall?.color, AppColors.textSecondaryDark);
    });
  });
}
