import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/tokens/tokens.dart';
import '../models/delegate_student_entry.dart';

/// عنصر عرض الطالب الحاضر لحظياً في الجلسة الحية (Live Attendee Tile)
class LiveAttendeeTile extends StatelessWidget {
  final DelegateStudentEntry attendee;
  final Animation<double>? animation;

  const LiveAttendeeTile({
    super.key,
    required this.attendee,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isQr = attendee.attendanceMethod?.toUpperCase() == 'QR';
    final isBiometric = attendee.attendanceMethod?.toUpperCase() == 'BIOMETRIC';

    final Color badgeColor = isQr
        ? AppColors.success
        : isBiometric
            ? const Color(0xFF8B5CF6) // Purple
            : const Color(0xFF0284C7); // Blue

    final widgetChild = Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة الحالة / الصورة
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isQr
                  ? Icons.qr_code_scanner_rounded
                  : isBiometric
                      ? Icons.fingerprint_rounded
                      : Icons.edit_note_rounded,
              color: badgeColor,
              size: 22.0,
            ),
          ),
          AppSpacing.gapHorizontalMD,
          // بيانات الطالب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendee.fullName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  attendee.studentNumber,
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // وقت التسجيل وشارة الطريقة
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                ),
                child: Text(
                  attendee.methodArabic,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              if (attendee.markedAt != null)
                Text(
                  DateFormat('HH:mm:ss').format(attendee.markedAt!),
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: AppColors.textSecondary,
                    fontFamily: 'monospace',
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    if (animation != null) {
      return SizeTransition(
        sizeFactor: animation!,
        child: FadeTransition(
          opacity: animation!,
          child: widgetChild,
        ),
      );
    }

    return widgetChild;
  }
}
