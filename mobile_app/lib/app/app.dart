import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'routes.dart';
import 'theme.dart';

/// الويدجت الجذري والتنفيذي الشامل لتطبيق الهاتف المحمول
/// لنظام الحضور الجامعي الذكي (University Attendance System)
class UniversityAttendanceApp extends StatelessWidget {
  final ThemeMode themeMode;
  final String? initialRoute;

  const UniversityAttendanceApp({
    super.key,
    this.themeMode = ThemeMode.system,
    this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام الحضور الجامعي الذكي',
      debugShowCheckedModeBanner: false,

      // --- نظام الثيمات الموحد (Themes) ---
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // --- دعم اللغة العربية والـ RTL (Localization) ---
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // --- نظام التوجيه والمسارات (Routing) ---
      initialRoute: initialRoute ?? AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
