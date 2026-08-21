import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/lab_student_record.dart';

/// نافذة مراجعة واعتماد طلب الاستثناء أو التحضير اليدوي (Exception Approval Modal)
class ExceptionApprovalModal extends StatefulWidget {
  final LabStudentRecord student;
  final Function(bool approved, String notes) onDecision;

  const ExceptionApprovalModal({
    super.key,
    required this.student,
    required this.onDecision,
  });

  static Future<void> show(
    BuildContext context, {
    required LabStudentRecord student,
    required Function(bool approved, String notes) onDecision,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ExceptionApprovalModal(
        student: student,
        onDecision: onDecision,
      ),
    );
  }

  @override
  State<ExceptionApprovalModal> createState() => _ExceptionApprovalModalState();
}

class _ExceptionApprovalModalState extends State<ExceptionApprovalModal> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final std = widget.student;

    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.radiusLG)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مقبض السحب
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.radiusXL),
                ),
              ),
            ),
            AppSpacing.gapVerticalMD,
            // عنوان النافذة
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                  ),
                  child: const Icon(
                    Icons.pending_actions_rounded,
                    color: AppColors.warning,
                    size: 24.0,
                  ),
                ),
                AppSpacing.gapHorizontalMD,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مراجعة طلب استثناء معملي',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      const Text(
                        'البت في صحة التحضير اليدوي أو العذر المرفوع',
                        style: TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                ),
              ],
            ),
            AppSpacing.gapVerticalLG,
            // بطاقة بيانات الطالب
            Container(
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [\n                      Text(
                        std.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                        ),
                        child: Text(
                          std.studentNumber,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapVerticalSM,
                  Row(
                    children: [
                      const Icon(Icons.school_outlined, size: 14.0, color: AppColors.textSecondary),
                      const SizedBox(width: 4.0),
                      Text(
                        '${std.departmentName} - ${std.academicLevel}',
                        style: const TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapVerticalMD,
            // المبرر أو سبب الاستثناء المرفوع
            const Text(
              'المبرر المرفوع من الطالب / المندوب:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
            ),
            const SizedBox(height: 6.0),
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB), // Amber 50
                borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                border: Border.all(color: const Color(0xFFFDE68A)), // Amber 200
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 18.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      std.manualReason ?? 'لم يتم تقديم شرح للمبرر',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF92400E),
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapVerticalMD,
            // حقل ملاحظات أستاذ المعمل
            const Text(
              'ملاحظات وتوجيهات أستاذ المعمل (اختياري):',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
            ),
            const SizedBox(height: 6.0),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'أدخل أي ملاحظات رسمية لتوثيق القرار...',
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            AppSpacing.gapVerticalLG,
            // أزرار القرار (رفض / اعتماد)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onDecision(false, _notesController.text.trim());
                    },
                    icon: const Icon(Icons.cancel_outlined, color: AppColors.error, size: 18.0),
                    label: const Text(
                      'رفض الاستثناء',
                      style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                      ),
                    ),
                  ),
                ),
                AppSpacing.gapHorizontalMD,
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onDecision(true, _notesController.text.trim());
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 18.0),
                    label: const Text(
                      'اعتماد وحفظ',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
