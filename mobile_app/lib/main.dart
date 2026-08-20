import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';

/// نقطة الانطلاق الرئيسية لتطبيق الهاتف المحمول لنظام الحضور الجامعي الذكي
void main() async {
  // التأكد من تهيئة ارتباطات فلاتر
  WidgetsFlutterBinding.ensureInitialized();

  // ضبط اتجاه الشاشة عمودياً ومطابقة ألوان شريط الحالة مع الهوية
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // تشغيل التطبيق
  runApp(const UniversityAttendanceApp());
}
