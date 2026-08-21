import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/routes.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/student_profile.dart';
import '../services/student_service.dart';
import '../widgets/student_id_card.dart';

/// شاشة الملف الشخصي والبطاقة الجامعية الرقمية للطالب (Student Profile & ID View)
class StudentProfileView extends StatefulWidget {
  final StudentService? studentService;

  const StudentProfileView({
    super.key,
    this.studentService,
  });

  @override
  State<StudentProfileView> createState() => _StudentProfileViewState();
}

class _StudentProfileViewState extends State<StudentProfileView> {
  late final StudentService _service;
  ScreenStateType _state = ScreenStateType.loading;
  StudentProfile? _profile;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.studentService ?? StudentService();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final profile = await _service.getStudentProfile();
      if (!mounted) return;

      setState(() {
        _profile = profile;
        _state = ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل بيانات الملف الشخصي: $e';
      });
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.error),
            SizedBox(width: 8.0),
            Text('تسجيل الخروج'),
          ],
        ),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('تأكيد الخروج'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي والبطاقة الجامعية'),
        actions: [
          IconButton(
            onPressed: _loadProfile,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري تحميل بيانات البطاقة الجامعية...',
        emptyTitle: 'لا توجد بيانات للملف الشخصي',
        emptyMessage: 'لم يتم العثور على سجل بيانات لهذا الطالب.',
        emptyIcon: Icons.account_box_outlined,
        errorMessage: _errorMessage,
        onRetry: _loadProfile,
        child: _profile == null
            ? const SizedBox.shrink()
            : RefreshIndicator(
                onRefresh: _loadProfile,
                child: ListView(
                  padding: AppSpacing.paddingLG,
                  children: [
                    // البطاقة الجامعية الرقمية
                    StudentIdCard(profile: _profile!),
                    AppSpacing.gapVerticalLG,
                    // بيانات الحساب الأكاديمي
                    Text(
                      'البيانات الأكاديمية والشخصية',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.gapVerticalSM,
                    _buildInfoSection([
                      _buildInfoTile(
                        icon: Icons.badge_outlined,
                        title: 'الرقم الجامعي',
                        value: _profile!.studentNumber,
                      ),
                      _buildInfoTile(
                        icon: Icons.person_outline_rounded,
                        title: 'الاسم الكامل',
                        value: _profile!.fullName,
                      ),
                      _buildInfoTile(
                        icon: Icons.account_balance_outlined,
                        title: 'القسم الأكاديمي',
                        value: _profile!.departmentName,
                      ),
                      _buildInfoTile(
                        icon: Icons.calendar_today_outlined,
                        title: 'السنة الدراسية',
                        value: _profile!.academicYearName,
                      ),
                      _buildInfoTile(
                        icon: Icons.email_outlined,
                        title: 'البريد الجامعي',
                        value: _profile!.email,
                      ),
                      if (_profile!.phone != null)
                        _buildInfoTile(
                          icon: Icons.phone_outlined,
                          title: 'رقم الهاتف',
                          value: _profile!.phone!,
                        ),
                    ]),
                    AppSpacing.gapVerticalLG,
                    // تفاصيل توثيق الجهاز والأمان
                    Text(
                      'أمان وتوثيق الجهاز المعتمد',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.gapVerticalSM,
                    _buildInfoSection([
                      _buildInfoTile(
                        icon: Icons.verified_user_outlined,
                        title: 'حالة الحساب',
                        value: _profile!.accountState.name,
                        valueColor: AppColors.success,
                      ),
                      _buildInfoTile(
                        icon: Icons.phone_android_rounded,
                        title: 'حالة توثيق الهاتف',
                        value: 'موثق ومعتمد (Bound)',
                        valueColor: AppColors.success,
                      ),
                      if (_profile!.boundDeviceId != null)
                        _buildInfoTile(
                          icon: Icons.fingerprint_rounded,
                          title: 'معرف الجهاز الرقمي',
                          value: _profile!.boundDeviceId!,
                        ),
                      if (_profile!.boundAt != null)
                        _buildInfoTile(
                          icon: Icons.access_time_rounded,
                          title: 'تاريخ توثيق الجهاز',
                          value: DateFormat('yyyy/MM/dd HH:mm', 'ar').format(_profile!.boundAt!),
                        ),
                    ]),
                    AppSpacing.gapVerticalLG,
                    // زر تسجيل الخروج
                    OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                      label: const Text(
                        'تسجيل الخروج من الحساب',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                        ),
                      ),
                    ),
                    AppSpacing.gapVerticalXL,
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInfoSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20.0, color: AppColors.primary),
          AppSpacing.gapHorizontalMD,
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.0,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
