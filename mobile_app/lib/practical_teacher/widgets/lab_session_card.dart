import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/tokens/tokens.dart';
import '../models/lab_session.dart';

/// بطاقة استعراض جلسة المعمل العملي السابقة أو المباشرة (Lab Session Card)
class LabSessionCard extends StatelessWidget {
  final LabSession session;
  final VoidCallback? onTap;

  const LabSessionCard({
    super.key,
    required this.session,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('yyyy/MM/dd', 'ar').format(session.sessionDate);

    Color stateColor;
    Color stateBg;
    IconData stateIcon;

    switch (session.sessionState) {
      case LabSessionState.active:
        stateColor = AppColors.success;
        stateBg = AppColors.success.withValues(alpha: 0.12);
        stateIcon = Icons.sensors_rounded;
        break;
      case LabSessionState.closed:
        stateColor = AppColors.warning;
        stateBg = AppColors.warning.withValues(alpha: 0.12);
        stateIcon = Icons.lock_clock_rounded;
        break;
      case LabSessionState.synced:
        stateColor = AppColors.primary;
        stateBg = AppColors.primaryLight.withValues(alpha: 0.12);
        stateIcon = Icons.cloud_done_rounded;
        break;
    }

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        side: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        child: Padding(
          padding: AppSpacing.paddingMD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي: رمز المادة والشعبة وشارة حالة الجلسة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                        ),
                        child: Text(
                          session.courseCode,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                      AppSpacing.gapHorizontalSM,
                      Text(
                        'شعبة (${session.sectionNumber})',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: stateBg,
                      borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(stateIcon, size: 12.0, color: stateColor),
                        const SizedBox(width: 4.0),
                        Text(
                          session.stateArabic,
                          style: TextStyle(
                            color: stateColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              // اسم المجموعة والمادة
              Text(
                session.groupName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2.0),
              Text(
                session.courseName,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.0,
                ),
              ),
              AppSpacing.gapVerticalMD,
              // التفاصيل: القاعة والتاريخ ونسبة الحضور
              Row(
                children: [
                  const Icon(Icons.event_note_rounded, size: 14.0, color: AppColors.textSecondary),
                  const SizedBox(width: 4.0),
                  Text(
                    dateStr,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                  Container(
                    width: 1.0,
                    height: 12.0,
                    color: AppColors.border,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  const Icon(Icons.meeting_room_outlined, size: 14.0, color: AppColors.textSecondary),
                  const SizedBox(width: 4.0),
                  Text(
                    session.roomName,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  Text(
                    'نسبة الحضور: ${session.attendancePercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (session.pendingExceptionsCount > 0) ...[
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 13.0, color: AppColors.warning),
                      const SizedBox(width: 6.0),
                      Text(
                        'يوجد ${session.pendingExceptionsCount} طلب استثناء معلق يحتاج اعتمادك',
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
