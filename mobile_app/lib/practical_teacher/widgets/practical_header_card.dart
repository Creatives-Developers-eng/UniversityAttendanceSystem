import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';

/// بطاقة الترويسة الرئيسية لأستاذ المعمل العملي (Practical Teacher Header Card)
class PracticalHeaderCard extends StatelessWidget {
  final Map<String, dynamic> teacherProfile;
  final VoidCallback? onExceptionsTap;
  final VoidCallback? onRefresh;

  const PracticalHeaderCard({
    super.key,
    required this.teacherProfile,
    this.onExceptionsTap,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = teacherProfile['full_name'] as String? ?? 'أستاذ المعمل';
    final teacherTitle = teacherProfile['teacher_title'] as String? ?? 'أستاذ عملي / معيد';
    final departmentName = teacherProfile['department_name'] as String? ?? 'كلية الحاسوب وتكنولوجيا المعلومات';
    final activeLabsCount = teacherProfile['active_labs_count'] as int? ?? 0;
    final totalStudents = teacherProfile['total_students_supervised'] as int? ?? 0;
    final pendingExceptions = teacherProfile['pending_exceptions_count'] as int? ?? 0;

    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F766E), // Teal 700
            Color(0xFF0D9488), // Teal 600
            Color(0xFF115E59), // Teal 800
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusLG),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.28),
            blurRadius: 16.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف العلوي: الأيقونة وشارة الإشراف وزر التحديث
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppRadius.radiusXL),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.science_rounded,
                      color: Colors.white,
                      size: 14.0,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      'المعامل والتطبيقات العملية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (onRefresh != null)
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20.0),
                  tooltip: 'تحديث البيانات',
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          AppSpacing.gapVerticalMD,
          // الاسم واللقب الأكاديمي
          Text(
            fullName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 19.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                color: Colors.white70,
                size: 14.0,
              ),
              const SizedBox(width: 4.0),
              Text(
                teacherTitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.0),
          Row(
            children: [
              const Icon(
                Icons.account_balance_outlined,
                color: Colors.white60,
                size: 14.0,
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  departmentName,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalLG,
          const Divider(color: Colors.white24, height: 1.0),
          AppSpacing.gapVerticalMD,
          // شريط الإحصائيات السريع (المعامل النشطة / الطلاب الخاضعين للإشراف / طلبات الاستثناءات)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatChip(
                icon: Icons.biotech_rounded,
                title: 'الشعب والمعامل',
                value: '$activeLabsCount معامل',
              ),
              Container(width: 1.0, height: 24.0, color: Colors.white24),
              _buildStatChip(
                icon: Icons.groups_rounded,
                title: 'الطلاب المسجلين',
                value: '$totalStudents طالب',
              ),
              Container(width: 1.0, height: 24.0, color: Colors.white24),
              InkWell(
                onTap: onExceptionsTap,
                borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: pendingExceptions > 0
                        ? AppColors.warning.withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                    border: Border.all(
                      color: pendingExceptions > 0
                          ? AppColors.warning.withValues(alpha: 0.6)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        pendingExceptions > 0
                            ? Icons.pending_actions_rounded
                            : Icons.task_alt_rounded,
                        color: pendingExceptions > 0 ? const Color(0xFFFDE047) : Colors.white,
                        size: 15.0,
                      ),
                      const SizedBox(width: 4.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الاستثناءات',
                            style: TextStyle(color: Colors.white70, fontSize: 10.0),
                          ),
                          Text(
                            pendingExceptions > 0 ? '$pendingExceptions معلقة' : 'لا يوجد معلق',
                            style: TextStyle(
                              color: pendingExceptions > 0 ? const Color(0xFFFDE047) : Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16.0),
        const SizedBox(width: 6.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
