import 'package:flutter/material.dart';
import '../tokens/tokens.dart';

/// حالات الشاشة الإلزامية الخمس وفقاً للبند 4 في وثيقة UI_UX_SYSTEM.md
enum ScreenStateType {
  loading,
  empty,
  error,
  retry,
  success,
}

/// ويدجت موحد لعرض وإدارة الحالات الإلزامية الخمس للشاشات في التطبيق:
/// 1. حالة التحميل (Loading State)
/// 2. حالة الفراغ (Empty State)
/// 3. حالة الخطأ (Error State)
/// 4. حالة إعادة المحاولة (Retry State)
/// 5. حالة النجاح (Success State)
class AppStateView extends StatelessWidget {
  final ScreenStateType state;
  final Widget? child;
  final String? loadingMessage;
  final String? emptyTitle;
  final String? emptyMessage;
  final String? errorMessage;
  final IconData? emptyIcon;
  final IconData? errorIcon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onRetry;

  const AppStateView({
    super.key,
    required this.state,
    this.child,
    this.loadingMessage,
    this.emptyTitle,
    this.emptyMessage,
    this.errorMessage,
    this.emptyIcon,
    this.errorIcon,
    this.actionLabel,
    this.onAction,
    this.onRetry,
  });

  /// باني سريع لحالة التحميل
  const AppStateView.loading({
    super.key,
    this.loadingMessage = 'جاري تحميل البيانات...',
  })  : state = ScreenStateType.loading,
        child = null,
        emptyTitle = null,
        emptyMessage = null,
        errorMessage = null,
        emptyIcon = null,
        errorIcon = null,
        actionLabel = null,
        onAction = null,
        onRetry = null;

  /// باني سريع لحالة الفراغ
  const AppStateView.empty({
    super.key,
    this.emptyTitle = 'لا توجد بيانات',
    this.emptyMessage = 'لم يتم العثور على أي سجلات لعرضها حالياً.',
    this.emptyIcon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  })  : state = ScreenStateType.empty,
        child = null,
        loadingMessage = null,
        errorMessage = null,
        errorIcon = null,
        onRetry = null;

  /// باني سريع لحالة الخطأ وإعادة المحاولة
  const AppStateView.error({
    super.key,
    this.errorMessage = 'حدث خطأ أثناء تحميل البيانات، يرجى المحاولة مرة أخرى.',
    this.errorIcon = Icons.error_outline,
    required this.onRetry,
  })  : state = ScreenStateType.error,
        child = null,
        loadingMessage = null,
        emptyTitle = null,
        emptyMessage = null,
        emptyIcon = null,
        actionLabel = null,
        onAction = null;

  /// باني سريع لحالة النجاح
  const AppStateView.success({
    super.key,
    required Widget this.child,
  })  : state = ScreenStateType.success,
        loadingMessage = null,
        emptyTitle = null,
        emptyMessage = null,
        errorMessage = null,
        emptyIcon = null,
        errorIcon = null,
        actionLabel = null,
        onAction = null,
        onRetry = null;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ScreenStateType.loading:
        return _buildLoadingState(context);
      case ScreenStateType.empty:
        return _buildEmptyState(context);
      case ScreenStateType.error:
        return _buildErrorState(context);
      case ScreenStateType.retry:
        return _buildRetryState(context);
      case ScreenStateType.success:
        return child ?? const SizedBox.shrink();
    }
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3.0,
            ),
            AppSpacing.gapVerticalMD,
            Text(
              loadingMessage ?? 'جاري تحميل البيانات...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              emptyIcon ?? Icons.inbox_outlined,
              size: 64.0,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            AppSpacing.gapVerticalMD,
            Text(
              emptyTitle ?? 'لا توجد بيانات',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalSM,
            Text(
              emptyMessage ?? 'لم يتم العثور على أي سجلات حالياً.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.gapVerticalLG,
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              errorIcon ?? Icons.error_outline_rounded,
              size: 64.0,
              color: AppColors.error,
            ),
            AppSpacing.gapVerticalMD,
            Text(
              'تعذر إكمال العملية',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVerticalSM,
            Text(
              errorMessage ?? 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.gapVerticalLG,
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRetryState(BuildContext context) {
    return _buildErrorState(context);
  }
}
