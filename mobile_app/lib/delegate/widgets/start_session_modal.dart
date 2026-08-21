import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../models/delegate_section.dart';

/// نافذة منبثقة لبدء جلسة حضور جديدة للشعبة (Start Session Modal)
class StartSessionModal extends StatefulWidget {
  final List<DelegateSection> sections;
  final Function(DelegateSection selectedSection, String roomName) onStartSession;

  const StartSessionModal({
    super.key,
    required this.sections,
    required this.onStartSession,
  });

  static Future<void> show(
    BuildContext context, {
    required List<DelegateSection> sections,
    required Function(DelegateSection selectedSection, String roomName) onStartSession,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StartSessionModal(
        sections: sections,
        onStartSession: onStartSession,
      ),
    );
  }

  @override
  State<StartSessionModal> createState() => _StartSessionModalState();
}

class _StartSessionModalState extends State<StartSessionModal> {
  late DelegateSection? _selectedSection;
  final TextEditingController _roomController = TextEditingController();
  String _sessionType = 'REGULAR'; // REGULAR | LAB | COMPENSATORY

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.sections.isNotEmpty ? widget.sections.first : null;
    if (_selectedSection != null) {
      _roomController.text = _selectedSection!.roomName;
    }
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: mediaQuery.viewInsets.bottom + 24.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.radiusXL)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط السحب العلوي
          Center(
            child: Container(
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999.0),
              ),
            ),
          ),
          AppSpacing.gapVerticalLG,
          // العنوان
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                ),
                child: const Icon(
                  Icons.wifi_tethering_rounded,
                  color: AppColors.primary,
                  size: 24.0,
                ),
              ),
              AppSpacing.gapHorizontalMD,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'بدء جلسة حضور جديدة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'تشغيل الخادم المحلي وبث الـ QR في القاعة',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.gapVerticalLG,
          // اختيار الشعبة
          Text(
            'اختر الشعبة والمقرر',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          AppSpacing.gapVerticalSM,
          if (widget.sections.isEmpty)
            Container(
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                border: Border.all(color: AppColors.error),
              ),
              child: const Text(
                'لا توجد شعب مفوض بها حالياً.',
                style: TextStyle(color: AppColors.error),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<DelegateSection>(
                  value: _selectedSection,
                  isExpanded: true,
                  items: widget.sections.map((sec) {
                    return DropdownMenuItem<DelegateSection>(
                      value: sec,
                      child: Text(
                        '${sec.courseCode} - ${sec.courseName} (${sec.sectionTypeArabic} شعبة ${sec.sectionNumber})',
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (sec) {
                    if (sec != null) {
                      setState(() {
                        _selectedSection = sec;
                        _roomController.text = sec.roomName;
                      });
                    }
                  },
                ),
              ),
            ),
          AppSpacing.gapVerticalMD,
          // تحديد القاعة
          Text(
            'مكان انعقاد الجلسة (القاعة / المعمل)',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          AppSpacing.gapVerticalSM,
          TextField(
            controller: _roomController,
            decoration: InputDecoration(
              hintText: 'مثال: معمل الحاسوب 3 أو مدرج (B)',
              prefixIcon: const Icon(Icons.meeting_room_outlined),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          AppSpacing.gapVerticalMD,
          // نوع الجلسة
          Text(
            'تصنيف الجلسة',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          AppSpacing.gapVerticalSM,
          Row(
            children: [
              _buildTypeChip('REGULAR', 'محاضرة دورية'),
              AppSpacing.gapHorizontalSM,
              _buildTypeChip('LAB', 'معمل عملي'),
              AppSpacing.gapHorizontalSM,
              _buildTypeChip('COMPENSATORY', 'جلسة تعويضية'),
            ],
          ),
          AppSpacing.gapVerticalXL,
          // زر تأكيد البدء
          SizedBox(
            width: double.infinity,
            height: 52.0,
            child: ElevatedButton.icon(
              onPressed: _selectedSection == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      widget.onStartSession(
                        _selectedSection!,
                        _roomController.text.trim(),
                      );
                    },
              icon: const Icon(Icons.play_arrow_rounded, size: 24.0),
              label: const Text(
                'بدء الجلسة وتشغيل الخادم المحلي',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String key, String label) {
    final isSelected = _sessionType == key;
    return Expanded(
      child: ChoiceChip(
        label: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
        selected: isSelected,
        onSelected: (val) {
          if (val) {
            setState(() {
              _sessionType = key;
            });
          }
        },
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSM),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}
