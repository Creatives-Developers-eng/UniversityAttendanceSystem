import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/tokens/tokens.dart';
import '../models/student_attendance_record.dart';

/// بطاقة تفاصيل سجل الحضور للجلسة الواحدة (Attendance History Record Card)
class AttendanceHistoryCard extends StatelessWidget {
  final StudentAttendanceRecord record;

  const AttendanceHistoryCard({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // تنسيق التاريخ والوقت باللغة العربية
    final dateStr = DateFormat('yyyy/MM/dd', 'ar').format(record.sessionDate);
    final timeStr = DateFormat('hh:mm a', 'ar').format(record.verifiedAt ?? record.sessionDate);

    // تفاصيل شارة الحالة
    Color stateColor;
    Color stateBgColor;
    IconData stateIcon;

    switch (record.attendanceState.toUpperCase()) {
      case 'PRESENT':
        stateColor = AppColors.success;
        stateBgColor = AppColors.success.withValues(alpha: 0.12);
        stateIcon = Icons.check_circle_rounded;
        break;
      case 'ABSENT':
        stateColor = AppColors.error;
        stateBgColor = AppColors.error.withValues(alpha: 0.12);
        stateIcon = Icons.cancel_rounded;
        break;
      case 'LATE':
        stateColor = AppColors.warning;
        stateBgColor = AppColors.warning.withValues(alpha: 0.12);
        stateIcon = Icons.access_time_filled_rounded;
        break;
      case 'EXCUSED':
        stateColor = const Color(0xFF0284C7);
        stateBgColor = const Color(0xFF0284C7).withValues(alpha: 0.12);
        stateIcon = Icons.verified_user_rounded;
        break;
      default:
        stateColor = AppColors.textSecondary;
        stateBgColor = AppColors.border;
        stateIcon = Icons.help_outline_rounded;
    }

    // أيقونة طريقة التحضير
    IconData methodIcon;
    switch (record.verificationMethod.toUpperCase()) {
      case 'QR':
        methodIcon = Icons.qr_code_2_rounded;
        break;
      case 'BIOMETRIC':
        methodIcon = Icons.fingerprint_rounded;
        break;
      case 'MANUAL':
        methodIcon = Icons.edit_note_rounded;
        break;
      default:
        methodIcon = Icons.how_to_reg_rounded;
    }

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        side: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      child: Padding(
        padding: AppSpacing.paddingMD,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصف العلوي: رمز المادة والشعبة وشارة الحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                      ),
                      child: Text(
                        record.courseCode,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                    AppSpacing.gapHorizontalSM,
                    Text(
                      'شعبة (${record.sectionNumber})',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                // شارة الحالة
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: stateBgColor,
                    borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(stateIcon, size: 13.0, color: stateColor),
                      const SizedBox(width: 4.0),
                      Text(
                        record.stateArabic,
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
            // اسم المقرر
            Text(
              record.courseName,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            AppSpacing.gapVerticalSM,
            const Divider(color: AppColors.border, height: 1.0),
            const SizedBox(height: 8.0),
            // الصف السفلي: التاريخ والوقت وطريقة التحضير
            Row(
              children: [
                const Icon(
                  Icons.event_note_rounded,
                  size: 14.0,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 11.0,
                    color: AppColors.textSecondary,
                  ),
                ),
                Container(
                  width: 1.0,
                  height: 12.0,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
                const Icon(
                  Icons.schedule_rounded,
                  size: 14.0,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 11.0,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                // شارة طريقة التحضير
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(methodIcon, size: 14.0, color: AppColors.primary),
                    const SizedBox(width: 4.0),
                    Text(
                      record.methodArabic,
                      style: const TextStyle(
                        fontSize: 11.0,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // المبرر أو الملاحظة إن وجدت
            if (record.note != null && record.note!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 13.0, color: AppColors.textSecondary),
                    const SizedBox(width: 6.0),
                    Expanded(
                      child: Text(
                        record.note!,
                        style: TextStyle(
                          fontSize: 11.0,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
