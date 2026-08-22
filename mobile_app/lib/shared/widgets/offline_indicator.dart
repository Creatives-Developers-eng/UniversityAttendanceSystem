import 'package:flutter/material.dart';
import '../../core/offline/connectivity_service.dart';
import '../tokens/tokens.dart';

/// ويدجت شريط تنبيه العمل دون اتصال بالإنترنت (Offline Banner)
/// يعرض تنبيهاً أنيقاً وواضحاً عندما يكون الجهاز معزولاً عن الشبكة
/// ويلتزم بمعايير UI_UX_SYSTEM.md (M3, RTL, No Emojis, Official Tokens)
class OfflineBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool isDismissible;

  const OfflineBanner({
    super.key,
    this.message = 'أنت تعمل حالياً دون اتصال بالإنترنت. البيانات المعروضة مأخوذة من التخزين المحلي.',
    this.onRetry,
    this.isDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingMD,
        vertical: AppSpacing.spacingSM + 2.0,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFFFBEB),
        border: Border(
          bottom: BorderSide(
            color: AppColors.warning.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.spacingXS + 2.0),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.radiusSM),
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 18.0,
              color: AppColors.warning,
            ),
          ),
          AppSpacing.gapHorizontalSM,
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF92400E),
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
          if (onRetry != null) ...[
            AppSpacing.gapHorizontalSM,
            InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(AppRadius.radiusSM),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingSM,
                  vertical: AppSpacing.spacingXS,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.refresh_rounded,
                      size: 16.0,
                      color: AppColors.warning,
                    ),
                    AppSpacing.gapHorizontalXS,
                    Text(
                      'إعادة فحص',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// شارة صغيرة ومدمجة لعرض حالة العمل دون اتصال في الأشرطة العلوية أو البطاقات (Offline Chip)
class OfflineChip extends StatelessWidget {
  final String label;

  const OfflineChip({
    super.key,
    this.label = 'محلي (بدون إنترنت)',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingSM,
        vertical: AppSpacing.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.radiusSM),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 14.0,
            color: AppColors.warning,
          ),
          AppSpacing.gapHorizontalXS,
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

/// ويدجت تفاعلي يراقب حالة الشبكة عبر ConnectivityService تلقائياً
/// ويعرض شريط OfflineBanner عند انقطاع الاتصال
class ReactiveOfflineWrapper extends StatelessWidget {
  final ConnectivityService connectivityService;
  final Widget child;

  const ReactiveOfflineWrapper({
    super.key,
    required this.connectivityService,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: connectivityService.isConnectedStream,
      initialData: true,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;
        return Column(
          children: [
            if (!isConnected)
              const OfflineBanner(),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
