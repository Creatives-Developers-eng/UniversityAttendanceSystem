import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/lab_group.dart';

/// بطاقة استعراض مجموعة المعمل العملي (Lab Group Card)
class LabGroupCard extends StatelessWidget {
  final LabGroup group;
  final VoidCallback? onRosterTap;
  final VoidCallback? onStartSessionTap;

  const LabGroupCard({
    super.key,
    required this.group,
    this.onRosterTap,
    this.onStartSessionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rate = group.attendancePercentage;

    Color groupBadgeColor = const Color(0xFF0F766E); // Teal
    IconData groupIcon = Icons.computer_rounded;

    switch (group.groupType) {
      case LabGroupType.networkLab:
        groupBadgeColor = const Color(0xFF0284C7); // Sky blue
        groupIcon = Icons.lan_rounded;
        break;
      case LabGroupType.databaseLab:
        groupBadgeColor = const Color(0xFF7C3AED); // Purple
        groupIcon = Icons.storage_rounded;
        break;
      case LabGroupType.hardwareLab:
        groupBadgeColor = const Color(0xFFD97706); // Amber
        groupIcon = Icons.memory_rounded;
        break;
      case LabGroupType.softwareLab:
        groupBadgeColor = const Color(0xFF0F766E);
        groupIcon = Icons.code_rounded;
        break;
    }

    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        side: BorderSide(
          color: group.isLiveNow
              ? AppColors.primary
              : AppColors.border,
          width: group.isLiveNow ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: AppSpacing.paddingMD,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصف العلوي: رمز المقرر ونوع المعمل وشارة البث المباشر
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
                        group.courseCode,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    AppSpacing.gapHorizontalSM,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                      decoration: BoxDecoration(
                        color: groupBadgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(groupIcon, size: 12.0, color: groupBadgeColor),
                          const SizedBox(width: 4.0),
                          Text(
                            group.groupTypeArabic,
                            style: TextStyle(
                              color: groupBadgeColor,
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (group.isLiveNow)\n                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sensors_rounded, size: 12.0, color: AppColors.success),
                        SizedBox(width: 4.0),
                        Text(
                          'جلسة جارية',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            AppSpacing.gapVerticalSM,
            // اسم المجموعة والمقرر
            Text(
              group.groupName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              '${group.courseName} (شعبة ${group.sectionNumber})',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
            ),
            AppSpacing.gapVerticalMD,
            // تفاصيل القاعة والموعد والمندوب
            Row(
              children: [
                const Icon(Icons.meeting_room_outlined, size: 14.0, color: AppColors.textSecondary),
                const SizedBox(width: 4.0),
                Text(
                  group.roomName,
                  style: const TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                ),
                Container(
                  width: 1.0,
                  height: 12.0,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
                const Icon(Icons.schedule_rounded, size: 14.0, color: AppColors.textSecondary),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    group.scheduleTime,
                    style: const TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (group.delegateName != null) ...[
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.person_pin_circle_outlined, size: 14.0, color: AppColors.primary),
                  const SizedBox(width: 4.0),
                  Text(
                    'مندوب المعمل: ${group.delegateName}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            AppSpacing.gapVerticalMD,
            // مؤشر الحضور وسعة المجموعة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'نسبة حضور المجموعة: ${rate.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${group.attendedStudents} من ${group.totalStudents} طالب',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.radiusSM),
              child: LinearProgressIndicator(
                value: group.totalStudents > 0 ? (group.attendedStudents / group.totalStudents) : 0.0,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  group.isLiveNow ? AppColors.primary : groupBadgeColor,
                ),
                minHeight: 6.0,
              ),
            ),
            AppSpacing.gapVerticalMD,
            const Divider(color: AppColors.border, height: 1.0),
            const SizedBox(height: 8.0),
            // أزرار الإجراءات السريعة (كشف الحضور / فتح الجلسة)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRosterTap,
                    icon: const Icon(Icons.list_alt_rounded, size: 16.0),
                    label: const Text('كشف الحضور والطلاب'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                AppSpacing.gapHorizontalSM,
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onStartSessionTap,
                    icon: Icon(
                      group.isLiveNow ? Icons.sensors_rounded : Icons.play_arrow_rounded,
                      size: 16.0,
                    ),
                    label: Text(group.isLiveNow ? 'متابعة الجلسة' : 'بدء الجلسة'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      backgroundColor: group.isLiveNow ? AppColors.primary : groupBadgeColor,
                      foregroundColor: Colors.white,
                    ),
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
