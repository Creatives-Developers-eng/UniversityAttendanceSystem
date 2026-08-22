import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/theory_course.dart';

/// بطاقة استعراض المقرر النظري والشعب التابعة له (Theory Course Card)
class TheoryCourseCard extends StatelessWidget {
  final TheoryCourse course;
  final VoidCallback? onReportsTap;
  final VoidCallback? onDeprivationListTap;

  const TheoryCourseCard({
    super.key,
    required this.course,
    this.onReportsTap,
    this.onDeprivationListTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color rateColor = AppColors.success;
    if (course.averageAttendanceRate < 75.0) {
      rateColor = AppColors.error;
    } else if (course.averageAttendanceRate < 85.0) {
      rateColor = AppColors.warning;
    }

    return Container(
      padding: AppSpacing.paddingLG,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLG),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف العلوي: رمز المادة والشعب
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                ),
                child: Text(
                  course.courseCode,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '${course.sections.length} شعب (${course.sections.map((s) => "ش$s").join(", ")})',
                      style: const TextStyle(
                        fontSize: 11.0,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '${course.creditHours} ساعات',
                      style: const TextStyle(
                        fontSize: 11.0,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.gapVerticalSM,
          // اسم المقرر
          Text(
            course.courseName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            course.departmentName,
            style: const TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
          ),
          AppSpacing.gapVerticalMD,
          // شريط معدل الحضور الفصلي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'معدل الحضور العام: ',
                    style: TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                  ),
                  Text(
                    course.formattedAttendanceRate,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: rateColor,
                    ),
                  ),
                ],
              ),
              Text(
                '${course.totalStudents} طالب مسجل',
                style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.radiusSM),
            child: LinearProgressIndicator(
              value: (course.averageAttendanceRate / 100.0).clamp(0.0, 1.0),
              backgroundColor: AppColors.background,
              color: rateColor,
              minHeight: 6.0,
            ),
          ),
          AppSpacing.gapVerticalMD,
          // شارة الطلاب المعرضين للحرمان إن وجدوا
          if (course.atRiskStudentsCount > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 16.0, color: AppColors.error),
                  const SizedBox(width: 6.0),
                  Expanded(
                    child: Text(
                      'يوجد ${course.atRiskStudentsCount} طلاب تجاوزوا نسبة الغياب المسموحة',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF991B1B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (onDeprivationListTap != null)
                    InkWell(
                      onTap: onDeprivationListTap,
                      child: const Text(
                        'كشف الحرمان',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AppSpacing.gapVerticalMD,
          ],
          const Divider(color: AppColors.border, height: 1.0),
          const SizedBox(height: 8.0),
          // أزرار العمليات (استعراض التقارير، قائمة الحرمان)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReportsTap,
                  icon: const Icon(Icons.analytics_outlined, size: 18.0),
                  label: const Text(
                    'التقارير والإحصائيات',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
