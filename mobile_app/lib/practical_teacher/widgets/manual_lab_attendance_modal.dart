import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';

/// حوار تسجيل تحضير يدوي فوري في المعمل (Manual Lab Attendance Modal)
class ManualLabAttendanceModal extends StatefulWidget {
  final Function(String studentNumber, String state, String reason) onSubmit;

  const ManualLabAttendanceModal({
    super.key,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(String studentNumber, String state, String reason) onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ManualLabAttendanceModal(onSubmit: onSubmit),
    );
  }

  @override
  State<ManualLabAttendanceModal> createState() => _ManualLabAttendanceModalState();
}

class _ManualLabAttendanceModalState extends State<ManualLabAttendanceModal> {
  final _formKey = GlobalKey<FormState>();
  final _studentNumberController = TextEditingController();
  final _reasonController = TextEditingController();
  String _selectedState = 'PRESENT'; // PRESENT | LATE | EXCUSED

  @override
  void dispose() {
    _studentNumberController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop();
      widget.onSubmit(
        _studentNumberController.text.trim(),
        _selectedState,
        _reasonController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusLG),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.radiusMD),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: AppColors.primary,
              size: 22.0,
            ),
          ),
          AppSpacing.gapHorizontalMD,
          Expanded(
            child: Text(
              'تحضير يدوي لطالب بالمعمل',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الرقم الجامعي للطالب *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                controller: _studentNumberController,
                decoration: InputDecoration(
                  hintText: 'مثال: STD-2023-4019',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'الرجاء إدخال الرقم الجامعي';
                  }
                  return null;
                },
              ),
              AppSpacing.gapVerticalMD,
              const Text(
                'حالة الحضور المراد تسجيلها:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
              ),
              const SizedBox(height: 6.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 6.0,
                children: [
                  _buildStateChip('PRESENT', 'حاضر', AppColors.success),
                  _buildStateChip('LATE', 'متأخر', AppColors.warning),
                  _buildStateChip('EXCUSED', 'معذور', const Color(0xFF0284C7)),
                ],
              ),
              AppSpacing.gapVerticalMD,
              const Text(
                'مبرر التحضير اليدوي *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.0),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                controller: _reasonController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'أدخل سبب التحضير اليدوي (عطل هاتف، عذر معملي، تعثر بيومتري)...',
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'المبرر إلزامي لتوثيق الأمان والتدقيق';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton.icon(
          onPressed: _handleSubmit,
          icon: const Icon(Icons.check_rounded, size: 18.0),
          label: const Text('تأكيد التحضير'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStateChip(String key, String label, Color color) {
    final isSelected = _selectedState == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedState = key;
          });
        }
      },
      selectedColor: color,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 12.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSM),
        side: BorderSide(color: isSelected ? color : AppColors.border),
      ),
      showCheckmark: false,
    );
  }
}
