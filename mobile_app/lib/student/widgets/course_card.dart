import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/student_course.dart';

/// بطاقة المقرر الدراسي والشعبة للطالب (Student Course Card)
class CourseCard extends StatelessWidget {
  final StudentCourse course;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rate = course.attendancePercentage;

    // ألوان شارة نوع الشعبة
    final isPractical = course.isPractical;
    final typeBgColor = isPractical
        ? AppColors.secondary.withValues(alpha: 0.12)
        : AppColors.primary.withValues(alpha: 0.1);
    final typeTextColor = isPractical ? AppColors.secondary : AppColors.primary;

    // لون مؤشر النسبة
    Color rateColor = AppColors.success;
    if (course.isDeprived) {
      rateColor = AppColors.error;
    } else if (course.isWarning) {
      rateColor = AppColors.warning;
    }

    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        side: BorderSide(
          color: course.isDeprived
              ? AppColors.error.withValues(alpha: 0.4)
              : AppColors.border,
          width: course.isDeprived ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        child: Padding(
          padding: AppSpacing.paddingMD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي: رمز المادة ونوع الشعبة والساعات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                    ),
                    child: Text(
                      course.courseCode,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // شارة الساعات
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: AppColors.border.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                        ),
                        child: Text(
                          '${course.creditHours} ساعات',
                          style: const TextStyle(
                            fontSize: 11.0,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      AppSpacing.gapHorizontalSM,
                      // شارة الشعبة
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                        decoration: BoxDecoration(
                          color: typeBgColor,
                          borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPractical
                                  ? Icons.science_outlined
                                  : Icons.menu_book_rounded,
                              size: 12.0,
                              color: typeTextColor,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '${course.sectionTypeArabic} (${course.sectionNumber})',
                              style: TextStyle(
                                color: typeTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              // عنوان المقرر
              Text(
                course.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              // اسم الأستاذ
              Row(
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: 14.0,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      course.teacherName,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVerticalMD,
              // شريط تقدم الحضور
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'نسبة الحضور:',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${rate.toStringAsFixed(0)}% (${course.attendedSessions}/${course.totalSessions} حضور)',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: rateColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                child: LinearProgressIndicator(
                  value: course.totalSessions > 0 ? (rate / 100.0) : 1.0,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(rateColor),
                  minHeight: 6.0,
                ),
              ),
              if (course.isDeprived) ...[
                const SizedBox(height: 6.0),
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 14.0, color: AppColors.error),
                    SizedBox(width: 4.0),
                    Text(
                      'تجاوزت الحد المسموح للغياب (محروم)',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ] else if (course.isWarning) ...[
                const SizedBox(height: 6.0),
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 14.0, color: AppColors.warning),
                    SizedBox(width: 4.0),
                    Text(
                      'إنذار: اقتراب من نسبة الحرمان',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
