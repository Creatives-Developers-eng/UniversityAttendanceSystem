import 'package:flutter/material.dart';

/// الرموز والألوان الرسمية المعتمدة لنظام الحضور الجامعي الذكي
/// مستخرجة ومطابقة بدقة لجدول الرموز اللونية في وثيقة UI_UX_SYSTEM.md
abstract class AppColors {
  /// اللون الأساسي (Deep Indigo) للأزرار الرئيسية والأشرطة العلوية - #1E3A8A
  static const Color primary = Color(0xFF1E3A8A);

  /// اللون الأساسي الفاتح للعناصر النشطة والتحديدات - #3B82F6
  static const Color primaryLight = Color(0xFF3B82F6);

  /// اللون الثانوي (Teal Accent) للشارات والعمليات الإيجابية - #0D9488
  static const Color secondary = Color(0xFF0D9488);

  /// خلفية البطاقات والحاويات في الوضع الفاتح - #FFFFFF
  static const Color surface = Color(0xFFFFFFFF);

  /// خلفية البطاقات والحاويات في الوضع الداكن - #1F2937
  static const Color surfaceDark = Color(0xFF1F2937);

  /// الخلفية العامة للشاشات في الوضع الفاتح (Slate 50) - #F8FAFC
  static const Color background = Color(0xFFF8FAFC);

  /// الخلفية العامة للشاشات في الوضع الداكن (Slate 900) - #111827
  static const Color backgroundDark = Color(0xFF111827);

  /// النص الأساسي عالي التباين في الوضع الفاتح - #0F172A
  static const Color textPrimary = Color(0xFF0F172A);

  /// النص الثانوي والتلميحات في الوضع الفاتح - #64748B
  static const Color textSecondary = Color(0xFF64748B);

  /// النص الأساسي عالي التباين في الوضع الداكن - #F8FAFC
  static const Color textPrimaryDark = Color(0xFFF8FAFC);

  /// النص الثانوي والتلميحات في الوضع الداكن - #94A3B8
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  /// حالات الخطأ والعمليات الخطرة والحرمان - #DC2626
  static const Color error = Color(0xFFDC2626);

  /// حالات النجاح وتأكيد الحضور وتفعيل الحسابات - #16A34A
  static const Color success = Color(0xFF16A34A);

  /// التنبيهات ونسب الغياب المتوسطة - #D97706
  static const Color warning = Color(0xFFD97706);

  /// حواف البطاقات والجداول والمدخلات في الوضع الفاتح - #E2E8F0
  static const Color border = Color(0xFFE2E8F0);

  /// حواف البطاقات والجداول والمدخلات في الوضع الداكن - #374151
  static const Color borderDark = Color(0xFF374151);

  /// تأثير التوهج الخاطف للـ Focus / Press (Rainbow Glow Accent)
  static const Color focusHighlight = Color(0xFF60A5FA);

  /// الشفافية وتأثيرات التراكب الخفيفة
  static const Color overlayLight = Color(0x0A000000);
  static const Color overlayDark = Color(0x1AFFFFFF);
}
