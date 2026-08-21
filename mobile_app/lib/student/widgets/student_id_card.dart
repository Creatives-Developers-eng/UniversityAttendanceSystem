import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/student_profile.dart';

/// بطاقة الهوية الجامعية الذكية الرقمية للطالب (Student Digital ID Card)
class StudentIdCard extends StatelessWidget {
  final StudentProfile profile;

  const StudentIdCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF1E3A8A), // Primary Navy
            Color(0xFF172554), // Deep Indigo
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20.0,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الترويسة الجامعية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38.0,
                      height: 38.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1.0),
                      ),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    AppSpacing.gapHorizontalSM,
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'جامعة المستقبل الذكية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          'نظام الحضور الأكاديمي الموحد',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // شريحة NFC / Smart Chip
                Container(
                  width: 36.0,
                  height: 26.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.nfc_rounded,
                      color: Color(0xFF78350F),
                      size: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapVerticalLG,
            // بيانات الطالب مع الصورة التعبيرية
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // إطار الصورة
                Container(
                  width: 70.0,
                  height: 85.0,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 48.0,
                      color: Colors.white70,
                    ),
                  ),
                ),
                AppSpacing.gapHorizontalMD,
                // التفاصيل الأكاديمية
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'الرقم الجامعي: ${profile.studentNumber}',
                        style: const TextStyle(
                          color: Color(0xFF93C5FD),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        profile.departmentName,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        profile.academicYearName,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapVerticalLG,
            const Divider(color: Colors.white12, height: 1.0),
            const SizedBox(height: 10.0),
            // الجزء السفلي: حالة الجهاز والتوثيق المشفر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.phone_android_rounded,
                      color: Colors.white54,
                      size: 14.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      profile.boundDeviceId ?? 'هاتف موثق',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10.0,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.5),
                      width: 1.0,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 12.0,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        'بطاقة نشطة وموثقة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
