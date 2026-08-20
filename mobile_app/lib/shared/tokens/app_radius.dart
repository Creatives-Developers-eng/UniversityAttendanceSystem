import 'package:flutter/material.dart';

/// مقاييس نصف قطر الانحناء الرسمية المعتمدة لنظام الحضور الجامعي الذكي
/// مستخرجة ومطابقة بدقة للقسم 3 في وثيقة UI_UX_SYSTEM.md
abstract class AppRadius {
  /// 8.0 dp - لحقول الإدخال والشارات (Inputs & Badges)
  static const double radiusSM = 8.0;

  /// 12.0 dp - للبطاقات والأزرار (Cards & Buttons)
  static const double radiusMD = 12.0;

  /// 16.0 dp - للحوارات والبطاقات العائمة (Dialogs & Floating Cards)
  static const double radiusLG = 16.0;

  /// 24.0 dp - للقوائم السفلية (Bottom Sheets)
  static const double radiusXL = 24.0;

  // --- كائنات Radius ---
  static const Radius rSM = Radius.circular(radiusSM);
  static const Radius rMD = Radius.circular(radiusMD);
  static const Radius rLG = Radius.circular(radiusLG);
  static const Radius rXL = Radius.circular(radiusXL);

  // --- كائنات BorderRadius ---

  /// انحناء صغير 8.0 dp (لحقول الإدخال والشارات)
  static const BorderRadius borderRadiusSM = BorderRadius.all(rSM);

  /// انحناء متوسط 12.0 dp (للبطاقات والأزرار)
  static const BorderRadius borderRadiusMD = BorderRadius.all(rMD);

  /// انحناء كبير 16.0 dp (للحوارات والبطاقات العائمة)
  static const BorderRadius borderRadiusLG = BorderRadius.all(rLG);

  /// انحناء واسع 24.0 dp (للقوائم السفلية)
  static const BorderRadius borderRadiusXL = BorderRadius.all(rXL);

  /// انحناء القوائم السفلية العلوي فقط 24.0 dp
  static const BorderRadius bottomSheetRadius = BorderRadius.vertical(top: rXL);

  // --- كائنات RoundedRectangleBorder ---

  /// إطار انحناء 8.0 dp
  static const RoundedRectangleBorder shapeSM = RoundedRectangleBorder(
    borderRadius: borderRadiusSM,
  );

  /// إطار انحناء 12.0 dp
  static const RoundedRectangleBorder shapeMD = RoundedRectangleBorder(
    borderRadius: borderRadiusMD,
  );

  /// إطار انحناء 16.0 dp
  static const RoundedRectangleBorder shapeLG = RoundedRectangleBorder(
    borderRadius: borderRadiusLG,
  );

  /// إطار انحناء 24.0 dp
  static const RoundedRectangleBorder shapeXL = RoundedRectangleBorder(
    borderRadius: borderRadiusXL,
  );
}
