import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';

/// شريط التحكم بالجلسة الحية (Session Controls Bar)
class SessionControlsBar extends StatelessWidget {
  final bool isBroadcasting;
  final VoidCallback onToggleBroadcast;
  final VoidCallback onEndSession;
  final VoidCallback onOpenSheet;
  final VoidCallback onManualAttendance;

  const SessionControlsBar({
    super.key,
    required this.isBroadcasting,
    required this.onToggleBroadcast,
    required this.onEndSession,
    required this.onOpenSheet,
    required this.onManualAttendance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLG),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // زر إيقاف / استئناف البث
          Expanded(
            flex: 2,
            child: OutlinedButton.icon(
              onPressed: onToggleBroadcast,
              icon: Icon(
                isBroadcasting ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 18.0,
                color: isBroadcasting ? AppColors.warning : AppColors.success,
              ),
              label: Text(
                isBroadcasting ? 'إيقاف مؤقت' : 'استئناف',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: isBroadcasting ? AppColors.warning : AppColors.success,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isBroadcasting ? AppColors.warning : AppColors.success,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
          AppSpacing.gapHorizontalSM,
          // زر كشف الطلاب
          IconButton(
            onPressed: onOpenSheet,
            icon: const Icon(Icons.list_alt_rounded, color: AppColors.primary),
            tooltip: 'كشف الطلاب الكامل',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusMD),
              ),
            ),
          ),
          AppSpacing.gapHorizontalSM,
          // زر التحضير اليدوي الاستثنائي
          IconButton(
            onPressed: onManualAttendance,
            icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.secondary),
            tooltip: 'تحضير يدوي استثنائي',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusMD),
              ),
            ),
          ),
          AppSpacing.gapHorizontalSM,
          // زر إنهاء الجلسة
          Expanded(
            flex: 3,
            child: ElevatedButton.icon(
              onPressed: onEndSession,
              icon: const Icon(Icons.stop_circle_outlined, size: 18.0),
              label: const Text(
                'إنهاء الجلسة',
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
