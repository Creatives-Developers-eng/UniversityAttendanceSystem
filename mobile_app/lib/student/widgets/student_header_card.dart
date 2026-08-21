import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/student_profile.dart';

/// بطاقة ترحيبية برأس لوحة التحكم للطالب (Student Header Card)
/// تلتزم بنظام التصميم M3 والألوان الرسمية بدون أي استخدام للإيموجي
class StudentHeaderCard extends StatelessWidget {
  final StudentProfile profile;
  final VoidCallback? onProfileTap;

  const StudentHeaderCard({
    super.key,
    required this.profile,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFF1E40AF),
            AppColors.primaryLight,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onProfileTap,
          borderRadius: BorderRadius.circular(AppRadius.radiusLG),
          child: Padding(
            padding: AppSpacing.paddingLG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // أيقونة الملف الشخصي
                    Container(
                      width: 56.0,
                      height: 56.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    ),
                    AppSpacing.gapHorizontalMD,
                    // بيانات الترحيب والاسم
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحباً بك،',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            profile.fullName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            profile.studentNumber,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontFamily: 'monospace',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // شارة التوثيق
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.6),
                          width: 1.0,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.white,
                            size: 14.0,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            'موثق',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVerticalLG,
                // شريط معلومات القسم والسنة
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance_rounded,
                        color: Colors.white70,
                        size: 16.0,
                      ),
                      AppSpacing.gapHorizontalSM,
                      Expanded(
                        child: Text(
                          profile.departmentName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 1.0,
                        height: 14.0,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white70,
                        size: 16.0,
                      ),
                      AppSpacing.gapHorizontalSM,
                      Text(
                        profile.academicYearName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
