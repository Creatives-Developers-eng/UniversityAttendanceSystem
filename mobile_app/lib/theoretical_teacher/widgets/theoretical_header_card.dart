import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';

/// بطاقة الترويسة الرئيسية للأستاذ النظري (Theoretical Header Card)
class TheoreticalHeaderCard extends StatelessWidget {
  final Map<String, dynamic> teacherProfile;
  final VoidCallback? onRefresh;
  final VoidCallback? onAtRiskTap;

  const TheoreticalHeaderCard({
    super.key,
    required this.teacherProfile,
    this.onRefresh,
    this.onAtRiskTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = teacherProfile['full_name'] as String? ?? 'د. عبد الله محمد السقاف';
    final teacherTitle = teacherProfile['teacher_title'] as String? ?? 'أستاذ مشارك';
    final deptName = teacherProfile['department_name'] as String? ?? 'كلية الحاسوب وتكنولوجيا المعلومات';
    final activeCoursesCount = (teacherProfile['active_courses_count'] as num?)?.toInt() ?? 3;
    final totalStudents = (teacherProfile['total_students_enrolled'] as num?)?.toInt() ?? 245;
    final atRiskCount = (teacherProfile['at_risk_deprivation_count'] as num?)?.toInt() ?? 0;

    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E3A8A), // Deep Indigo
            Color(0xFF1E293B), // Slate 800
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusLG),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
            blurRadius: 16.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف العلوي: الصورة الرمزية، الاسم، المسمى، وزر التحديث
          Row(
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                ),
                child: const Icon(
                  Icons.account_balance_outlined,
                  color: Colors.white,
                  size: 26.0,
                ),
              ),
              AppSpacing.gapHorizontalMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      teacherTitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (onRefresh != null)
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                  tooltip: 'تحديث المؤشرات',
                ),
            ],
          ),
          AppSpacing.gapVerticalSM,
          Text(
            deptName,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11.5,
            ),
          ),
          AppSpacing.gapVerticalLG,
          // صف الإحصائيات السريعة (المقررات، الطلاب، الحالات الحرجة)
          Row(
            children: [
              _buildStatChip(
                label: 'المقررات',
                value: activeCoursesCount.toString(),
                icon: Icons.menu_book_rounded,
              ),
              AppSpacing.gapHorizontalMD,
              _buildStatChip(
                label: 'إجمالي الطلاب',
                value: totalStudents.toString(),
                icon: Icons.groups_rounded,
              ),
              AppSpacing.gapHorizontalMD,
              _buildAtRiskChip(
                atRiskCount: atRiskCount,
                onTap: onAtRiskTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.radiusMD),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.0, color: Colors.white70),
            const SizedBox(width: 6.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 10.5,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtRiskChip({
    required int atRiskCount,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: atRiskCount > 0
                ? const Color(0xFFEF4444).withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.radiusMD),
            border: Border.all(
              color: atRiskCount > 0
                  ? const Color(0xFFFCA5A5)
                  : Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 18.0,
                color: atRiskCount > 0 ? const Color(0xFFFCA5A5) : Colors.white70,
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'خطر الحرمان',
                      style: TextStyle(
                        color: atRiskCount > 0
                            ? const Color(0xFFFCA5A5)
                            : Colors.white.withValues(alpha: 0.75),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$atRiskCount طالب',
                      style: TextStyle(
                        color: atRiskCount > 0 ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
