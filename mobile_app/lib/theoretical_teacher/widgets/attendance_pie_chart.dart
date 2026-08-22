import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/attendance_analytics.dart';

/// مخطط بياني دائري لتوزيع نسب الحضور والغياب (Attendance Pie Chart)
class AttendancePieChart extends StatefulWidget {
  final AttendanceAnalytics analytics;
  final String title;

  const AttendancePieChart({
    super.key,
    required this.analytics,
    this.title = 'توزيع الحضور والغياب التراكمي',
  });

  @override
  State<AttendancePieChart> createState() => _AttendancePieChartState();
}

class _AttendancePieChartState extends State<AttendancePieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = widget.analytics;

    final presentVal = a.presentPercentage;
    final absentVal = a.absentPercentage;
    final lateVal = a.latePercentage;
    final excusedVal = a.excusedPercentage;

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
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                ),
                child: Text(
                  '${a.totalLectures} محاضرة',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalLG,
          // الرسم الدائري
          SizedBox(
            height: 180.0,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 36,
                      sections: _buildSections(presentVal, absentVal, lateVal, excusedVal),
                    ),
                  ),
                ),
                // وسيلة الإيضاح (Legend)
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: dynamic ?? MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                        color: AppColors.success,
                        label: 'حاضر',
                        value: '${presentVal.toStringAsFixed(1)}%',
                        count: a.presentCount,
                      ),
                      const SizedBox(height: 6.0),
                      _buildLegendItem(
                        color: AppColors.error,
                        label: 'غائب',
                        value: '${absentVal.toStringAsFixed(1)}%',
                        count: a.absentCount,
                      ),
                      const SizedBox(height: 6.0),
                      _buildLegendItem(
                        color: AppColors.warning,
                        label: 'متأخر',
                        value: '${lateVal.toStringAsFixed(1)}%',
                        count: a.lateCount,
                      ),
                      const SizedBox(height: 6.0),
                      _buildLegendItem(
                        color: const Color(0xFF0284C7),
                        label: 'معذور',
                        value: '${excusedVal.toStringAsFixed(1)}%',
                        count: a.excusedCount,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
    double presentVal,
    double absentVal,
    double lateVal,
    double excusedVal,
  ) {
    return [
      PieChartSectionData(
        color: AppColors.success,
        value: presentVal > 0 ? presentVal : 1.0,
        title: '${presentVal.toStringAsFixed(0)}%',
        radius: _touchedIndex == 0 ? 44.0 : 36.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppColors.error,
        value: absentVal > 0 ? absentVal : 0.01,
        title: '${absentVal.toStringAsFixed(0)}%',
        radius: _touchedIndex == 1 ? 44.0 : 36.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppColors.warning,
        value: lateVal > 0 ? lateVal : 0.01,
        title: '${lateVal.toStringAsFixed(0)}%',
        radius: _touchedIndex == 2 ? 44.0 : 36.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xFF0284C7),
        value: excusedVal > 0 ? excusedVal : 0.01,
        title: '${excusedVal.toStringAsFixed(0)}%',
        radius: _touchedIndex == 3 ? 44.0 : 36.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
    required int count,
  }) {
    return Row(
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 6.0),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
            color: color,
          ),
        ),
      ],
    );
  }
}
