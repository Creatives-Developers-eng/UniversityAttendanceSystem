import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/attendance_stats.dart';

/// بطاقة إحصائيات ونسبة الحضور الشاملة (Attendance Rate & Stats Card)
class AttendanceRateCard extends StatelessWidget {
  final AttendanceStats stats;
  final VoidCallback? onHistoryTap;

  const AttendanceRateCard({
    super.key,
    required this.stats,
    this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rate = stats.attendancePercentage;

    // تحديد اللون والمستوى حسب النسبة
    Color rateColor;
    String statusTitle;
    IconData statusIcon;

    if (rate >= 85.0) {
      rateColor = AppColors.success;
      statusTitle = 'ممتاز ومستقر';
      statusIcon = Icons.sentiment_satisfied_alt_rounded;
    } else if (rate >= 75.0) {
      rateColor = AppColors.warning;
      statusTitle = 'تنبيه: اقتراب من الحرمان';
      statusIcon = Icons.warning_amber_rounded;
    } else {
      rateColor = AppColors.error;
      statusTitle = 'حرج: تجاوزت حد الغياب';
      statusIcon = Icons.error_outline_rounded;
    }

    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        side: const BorderSide(color: AppColors.border, width: 1.0),
      ),
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان ورابط السجل الكامل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.analytics_rounded,
                      color: AppColors.primary,
                      size: 20.0,
                    ),
                    AppSpacing.gapHorizontalSM,
                    Text(
                      'معدل الحضور العام',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (onHistoryTap != null)
                  TextButton.icon(
                    onPressed: onHistoryTap,
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 12.0),
                    label: const Text('التفاصيل'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
            AppSpacing.gapVerticalMD,
            // النسبة المئوية ومؤشر التقدم الدائري
            Row(
              children: [
                SizedBox(
                  width: 72.0,
                  height: 72.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: stats.totalSessions > 0 ? (rate / 100.0) : 1.0,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(rateColor),
                        strokeWidth: 6.0,
                        strokeCap: StrokeCap.round,
                      ),
                      Text(
                        '${rate.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          color: rateColor,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapHorizontalLG,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(statusIcon, color: rateColor, size: 18.0),
                          const SizedBox(width: 6.0),
                          Text(
                            statusTitle,
                            style: TextStyle(
                              color: rateColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'إجمالي المحاضرات: ${stats.totalSessions} محاضرة',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapVerticalLG,
            const Divider(color: AppColors.border, height: 1.0),
            AppSpacing.gapVerticalMD,
            // أرقام تفصيلية (حاضر / غائب / متأخر / معذور)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  title: 'حاضر',
                  count: stats.totalPresent,
                  color: AppColors.success,
                  icon: Icons.check_circle_outline_rounded,
                ),
                _buildDivider(),
                _buildStatItem(
                  context,
                  title: 'غائب',
                  count: stats.totalAbsent,
                  color: AppColors.error,
                  icon: Icons.highlight_off_rounded,
                ),
                _buildDivider(),
                _buildStatItem(
                  context,
                  title: 'متأخر',
                  count: stats.totalLate,
                  color: AppColors.warning,
                  icon: Icons.access_time_rounded,
                ),
                _buildDivider(),
                _buildStatItem(
                  context,
                  title: 'معذور',
                  count: stats.totalExcused,
                  color: const Color(0xFF0284C7),
                  icon: Icons.task_alt_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1.0,
      height: 28.0,
      color: AppColors.border,
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14.0),
            const SizedBox(width: 4.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
