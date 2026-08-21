import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/deprivation_student.dart';

/// بطاقة متابعة الطالب المعرض للحرمان والإنذارات الأكاديمية (Deprivation Risk Card)
class DeprivationRiskCard extends StatelessWidget {
  final DeprivationStudent student;
  final Function(String warningType)? onSendWarning;

  const DeprivationRiskCard({
    super.key,
    required this.student,
    this.onSendWarning,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color badgeColor;
    Color badgeBg;
    Color borderColor;

    switch (student.riskLevel) {
      case DeprivationRiskLevel.deprived:
        badgeColor = AppColors.error;
        badgeBg = AppColors.error.withValues(alpha: 0.12);
        borderColor = AppColors.error.withValues(alpha: 0.4);
        break;
      case DeprivationRiskLevel.warningSecond:
        badgeColor = const Color(0xFFEA580C); // Orange 600
        badgeBg = const Color(0xFFEA580C).withValues(alpha: 0.12);
        borderColor = const Color(0xFFFDBA74);
        break;
      case DeprivationRiskLevel.warningFirst:
        badgeColor = AppColors.warning;
        badgeBg = AppColors.warning.withValues(alpha: 0.12);
        borderColor = const Color(0xFFFDE68A);
        break;
      case DeprivationRiskLevel.low:
        badgeColor = const Color(0xFF0284C7);
        badgeBg = const Color(0xFF0284C7).withValues(alpha: 0.12);
        borderColor = AppColors.border;
        break;
      case DeprivationRiskLevel.safe:
        badgeColor = AppColors.success;
        badgeBg = AppColors.success.withValues(alpha: 0.12);
        borderColor = AppColors.border;
        break;
    }

    return Container(
      padding: AppSpacing.paddingMD,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(color: borderColor, width: student.isAtRisk ? 1.4 : 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف الأول: الاسم، الرقم الجامعي، وشارة مستوى الخطر
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18.0,
                backgroundColor: badgeBg,
                child: Text(
                  student.fullName.isNotEmpty ? student.fullName.characters.first : 'ط',
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                  ),
                ),
              ),
              AppSpacing.gapHorizontalMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      children: [
                        Text(
                          student.studentNumber,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          '| ${student.departmentName} (شعبة ${student.sectionNumber})',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // شارة مستوى الخطر
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  student.riskLevelArabic,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.0,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalMD,
          // شريط نسبة الغياب
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'نسبة الغياب: ${student.absencePercentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                          ),
                        ),
                        Text(
                          'غائب في ${student.absentLecturesCount} من أصل ${student.totalLectures} محاضرة',
                          style: const TextStyle(
                            fontSize: 11.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                      child: LinearProgressIndicator(
                        value: (student.absencePercentage / 30.0).clamp(0.0, 1.0),
                        backgroundColor: AppColors.background,
                        color: badgeColor,
                        minHeight: 6.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // تنبيه عذر معلق إن وجد
          if (student.hasPendingExcuse) ...[
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 14.0, color: Color(0xFF16A34A)),
                  SizedBox(width: 4.0),
                  Text(
                    'يوجد عذر طبي أو أكاديمي بانتظار المراجعة',
                    style: TextStyle(fontSize: 11.0, color: Color(0xFF15803D), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
          AppSpacing.gapVerticalSM,
          const Divider(color: AppColors.border, height: 1.0),
          const SizedBox(height: 6.0),
          // الصف السفلي: حالة الإنذار وزر الإجراء
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined, size: 14.0, color: AppColors.textSecondary),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        student.warningStatus,
                        style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (onSendWarning != null && student.isAtRisk)
                ElevatedButton.icon(
                  onPressed: () {
                    if (student.isDeprived) {
                      onSendWarning!('DEPRIVATION_DECISION');
                    } else if (student.isWarningSecond) {
                      onSendWarning!('FINAL_WARNING');
                    } else {
                      onSendWarning!('FIRST_WARNING');
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 14.0),
                  label: Text(
                    student.isDeprived ? 'تثبيت الحرمان' : 'إرسال إنذار',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: student.isDeprived ? AppColors.error : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    minimumSize: const Size(60.0, 30.0),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
