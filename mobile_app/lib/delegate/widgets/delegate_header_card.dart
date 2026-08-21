import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';

/// بطاقة الترويسة الرئيسية الخاصة بمندوب الدفعة (Delegate Header Card)
class DelegateHeaderCard extends StatelessWidget {
  final String delegateName;
  final String delegateStudentNumber;
  final int activeSectionsCount;
  final VoidCallback? onProfileTap;

  const DelegateHeaderCard({
    super.key,
    required this.delegateName,
    required this.delegateStudentNumber,
    required this.activeSectionsCount,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E3A8A), // Deep Indigo Blue
            AppColors.primary,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // شارة المندوب المعتمد
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999.0),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      size: 14.0,
                      color: AppColors.primaryLight,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      'مندوب الدفعة المعتمد',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // مؤشر حالة الخادم المحلي
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999.0),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sensors_rounded,
                      size: 12.0,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'محلي جاهز',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalMD,
          Row(
            children: [
              CircleAvatar(
                radius: 26.0,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.person_rounded,
                  size: 32.0,
                  color: Colors.white,
                ),
              ),
              AppSpacing.gapHorizontalMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delegateName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'الرقم الجامعي: $delegateStudentNumber',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalMD,
          const Divider(color: Colors.white24, height: 1.0),
          AppSpacing.gapVerticalSM,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الشعب المفوض بإدارتها: $activeSectionsCount شعب',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.wifi_tethering_rounded, size: 14.0, color: AppColors.primaryLight),
                  SizedBox(width: 4.0),
                  Text(
                    'الخادم الداخلي متاح',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
