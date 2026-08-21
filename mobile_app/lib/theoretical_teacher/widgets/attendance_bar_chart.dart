import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/attendance_analytics.dart';

/// مخطط أعمدة بياني لمتابعة اتجاهات ونسب الحضور الأسبوعية (Attendance Bar Chart)
class AttendanceBarChart extends StatelessWidget {
  final List<WeeklyTrendItem> weeklyTrends;
  final String title;

  const AttendanceBarChart({
    super.key,
    required this.weeklyTrends,
    this.title = 'معدل الحضور الأسبوعي (%)',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (weeklyTrends.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: AppSpacing.paddingLG,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.trending_up_rounded, size: 16.0, color: AppColors.success),
                  SizedBox(width: 4.0),
                  Text(
                    'معدل فصلي مستقر',
                    style: TextStyle(
                      fontSize: 11.0,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.gapVerticalLG,
          SizedBox(
            height: 190.0,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: const Color(0xFF1E293B),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = weeklyTrends[groupIndex];
                      return BarTooltipItem(
                        '${item.weekLabel}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                        children: [
                          TextSpan(
                            text: 'الحضور: ${rod.toY.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Color(0xFF86EFAC),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < weeklyTrends.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              'أ${weeklyTrends[index].weekNumber}',
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 25,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: weeklyTrends.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  Color barColor = AppColors.primary;
                  if (item.attendanceRate < 80.0) {
                    barColor = AppColors.warning;
                  } else if (item.attendanceRate >= 90.0) {
                    barColor = const Color(0xFF0F766E);
                  }

                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: item.attendanceRate,
                        color: barColor,
                        width: 14.0,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: AppColors.background,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
