import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/tokens/tokens.dart';
import '../models/delegate_session.dart';

/// بطاقة استعراض الجلسة (Delegate Session Card)
class DelegateSessionCard extends StatelessWidget {
  final DelegateSession session;
  final VoidCallback? onTap;
  final VoidCallback? onSyncTap;
  final VoidCallback? onOpenSheetTap;

  const DelegateSessionCard({
    super.key,
    required this.session,
    this.onTap,
    this.onSyncTap,
    this.onOpenSheetTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rate = session.attendancePercentage;
    final isPractical = session.sectionType.name == 'practical';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingMD),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(
          color: session.isActive ? AppColors.success : AppColors.border,
          width: session.isActive ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: session.isActive
                ? AppColors.success.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.radiusMD),
          child: Padding(
            padding: AppSpacing.paddingLG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الشريط العلوي: الرمز وحالة الجلسة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                          ),
                          child: Text(
                            session.courseCode,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            color: isPractical
                                ? AppColors.secondary.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                          ),
                          child: Text(
                            isPractical ? 'عملي (شعبة ${session.sectionNumber})' : 'نظري (شعبة ${session.sectionNumber})',
                            style: TextStyle(
                              color: isPractical ? AppColors.secondary : AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 11.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // شارة حالة الجلسة
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: session.stateColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999.0),
                        border: Border.all(color: session.stateColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            session.isSynced
                                ? Icons.cloud_done_rounded
                                : session.isActive
                                    ? Icons.wifi_tethering_rounded
                                    : Icons.lock_outline_rounded,
                            size: 13.0,
                            color: session.stateColor,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            session.stateArabic,
                            style: TextStyle(
                              color: session.stateColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 11.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVerticalMD,
                // اسم المادة والأستاذ
                Text(
                  session.courseName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Icon(Icons.school_rounded, size: 14.0, color: AppColors.textSecondary),
                    const SizedBox(width: 4.0),
                    Text(
                      'المشرف: ${session.teacherName}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.0),
                    ),
                    const Spacer(),
                    const Icon(Icons.meeting_room_outlined, size: 14.0, color: AppColors.textSecondary),
                    const SizedBox(width: 4.0),
                    Text(
                      session.roomName,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.0),
                    ),
                  ],
                ),
                AppSpacing.gapVerticalMD,
                // شريط نسبة الحضور
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'نسبة الحضور: ${rate.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${session.attendedCount} من ${session.totalExpectedStudents} طالب',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                  child: LinearProgressIndicator(
                    value: session.totalExpectedStudents > 0 ? (rate / 100.0) : 0.0,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(session.stateColor),
                    minHeight: 6.0,
                  ),
                ),
                AppSpacing.gapVerticalMD,
                const Divider(color: AppColors.border, height: 1.0),
                AppSpacing.gapVerticalSM,
                // الشريط السفلي: التوقيت والإجراءات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 14.0, color: AppColors.textSecondary),
                        const SizedBox(width: 4.0),
                        Text(
                          DateFormat('yyyy/MM/dd HH:mm', 'ar').format(session.openedAt),
                          style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (onOpenSheetTap != null)
                          TextButton.icon(
                            onPressed: onOpenSheetTap,
                            icon: const Icon(Icons.list_alt_rounded, size: 16.0),
                            label: const Text('الكشف', style: TextStyle(fontSize: 12.0)),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        if (!session.isSynced && !session.isActive && onSyncTap != null) ...[
                          const SizedBox(width: 8.0),
                          ElevatedButton.icon(
                            onPressed: onSyncTap,
                            icon: const Icon(Icons.cloud_upload_rounded, size: 14.0),
                            label: const Text('مزامنة', style: TextStyle(fontSize: 11.0)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
