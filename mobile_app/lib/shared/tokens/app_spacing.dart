import 'package:flutter/material.dart';

/// مقاييس المسافات الرسمية المعتمدة لنظام الحضور الجامعي الذكي
/// مستخرجة ومطابقة بدقة للقسم 3 في وثيقة UI_UX_SYSTEM.md
abstract class AppSpacing {
  /// 4.0 dp - أصغر مسافة بين العناصر المتقاربة جداً
  static const double spacingXS = 4.0;

  /// 8.0 dp - مسافة داخلية صغيرة للشارات والعناصر الثانوية
  static const double spacingSM = 8.0;

  /// 16.0 dp - المسافة القياسية للحشو الداخلي والتباعد بين المكونات
  static const double spacingMD = 16.0;

  /// 24.0 dp - مسافة بين الأقسام الرئيسية والحاويات
  static const double spacingLG = 24.0;

  /// 32.0 dp - مسافة واسعة لفصل الكتل الكبيرة وبداية الشاشات
  static const double spacingXL = 32.0;

  // --- ثوابت الحشو الداخلي (EdgeInsets) ---

  /// الحشو الافتراضي الكامل 16.0 dp
  static const EdgeInsets paddingMD = EdgeInsets.all(spacingMD);

  /// حشو صغير 8.0 dp
  static const EdgeInsets paddingSM = EdgeInsets.all(spacingSM);

  /// حشو أصغر 4.0 dp
  static const EdgeInsets paddingXS = EdgeInsets.all(spacingXS);

  /// حشو كبير 24.0 dp
  static const EdgeInsets paddingLG = EdgeInsets.all(spacingLG);

  /// حشو واسع 32.0 dp
  static const EdgeInsets paddingXL = EdgeInsets.all(spacingXL);

  /// حشو أفقي قياسي 16.0 dp
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: spacingMD);

  /// حشو عمودي قياسي 16.0 dp
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: spacingMD);

  /// حشو أفقي صغير 8.0 dp
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: spacingSM);

  /// حشو عمودي صغير 8.0 dp
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: spacingSM);

  /// حشو شاشات كامل (أفقي 16.0 وعمودي 24.0)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: spacingMD,
    vertical: spacingLG,
  );

  // --- فواصل رأسية (Vertical Gaps / SizedBox) ---
  static const SizedBox gapVerticalXS = SizedBox(height: spacingXS);
  static const SizedBox gapVerticalSM = SizedBox(height: spacingSM);
  static const SizedBox gapVerticalMD = SizedBox(height: spacingMD);
  static const SizedBox gapVerticalLG = SizedBox(height: spacingLG);
  static const SizedBox gapVerticalXL = SizedBox(height: spacingXL);

  // --- فواصل أفقية (Horizontal Gaps / SizedBox) ---
  static const SizedBox gapHorizontalXS = SizedBox(width: spacingXS);
  static const SizedBox gapHorizontalSM = SizedBox(width: spacingSM);
  static const SizedBox gapHorizontalMD = SizedBox(width: spacingMD);
  static const SizedBox gapHorizontalLG = SizedBox(width: spacingLG);
  static const SizedBox gapHorizontalXL = SizedBox(width: spacingXL);
}
