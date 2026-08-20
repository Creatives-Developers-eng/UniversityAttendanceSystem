import 'package:flutter/material.dart';
import '../shared/tokens/tokens.dart';
import 'activation_service.dart';
import 'device_activation_dto.dart';
import 'role_guard.dart';
import 'user_session.dart';

/// واجهة إدخال رمز التفعيل وربط الجهاز بحساب المستخدم
/// مصممة وفقاً لمعايير Material 3 ومواصفة UI_UX_SYSTEM.md مع دعم كامل للـ RTL
class ActivationView extends StatefulWidget {
  final ActivationService? activationService;
  final UserSession? currentSession;
  final ValueChanged<UserSession>? onActivationComplete;

  const ActivationView({
    super.key,
    this.activationService,
    this.currentSession,
    this.onActivationComplete,
  });

  @override
  State<ActivationView> createState() => _ActivationViewState();
}

class _ActivationViewState extends State<ActivationView> {
  late final ActivationService _activationService;
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  ActivationState _state = ActivationState.idle;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _activationService = widget.activationService ?? ActivationService();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submitActivation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _state = ActivationState.loading;
      _errorMessage = null;
      _successMessage = null;
    });

    final dto = DeviceActivationDto(
      code: _codeController.text.trim(),
      deviceIdentifier: 'device-id-current',
      deviceFingerprint: 'device-fingerprint-sha256',
    );

    final result = await _activationService.activateDevice(dto);

    if (!mounted) return;

    if (result.isSuccess) {
      setState(() {
        _state = ActivationState.success;
        _successMessage = 'تم توثيق وربط الجهاز بنجاح!';
      });

      final updatedSession = (widget.currentSession ??
              const UserSession(
                userId: 'user-default',
                username: 'student',
                fullName: 'الطالب الجامعي',
                role: UserRole.student,
              ))
          .copyWith(
        deviceState: DeviceState.bound,
        deviceId: result.response?.deviceId,
      );

      widget.onActivationComplete?.call(updatedSession);

      // تأخير بسيط لإظهار حالة النجاح ثم الانتقال للوحة التحكم
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;

      final nextRoute = RoleGuard.resolveInitialRoute(updatedSession);
      Navigator.of(context).pushReplacementNamed(nextRoute);
    } else {
      setState(() {
        _state = ActivationState.error;
        _errorMessage = result.errorMessage ?? 'تعذر تفعيل الجهاز.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('توثيق وتفعيل الجهاز'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480.0),
              child: Card(
                elevation: 2.0,
                shape: AppRadius.shapeMD,
                color: isDark ? AppColors.surfaceDark : AppColors.surface,
                child: Padding(
                  padding: AppSpacing.paddingLG,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- أيقونة ورأس الواجهة ---
                        Center(
                          child: Container(
                            width: 72.0,
                            height: 72.0,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.phonelink_lock_rounded,
                              size: 38.0,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        AppSpacing.gapVerticalLG,

                        // --- العنوان والوصف ---
                        Text(
                          'تفعيل الجهاز الأكاديمي',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.gapVerticalSM,
                        Text(
                          'أدخل رمز التفعيل الممنوح لك من إدارة الكلية لربط وتوثيق حسابك بهذا الجهاز.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.gapVerticalXL,

                        // --- حقل إدخال رمز التفعيل ---
                        TextFormField(
                          controller: _codeController,
                          enabled: _state != ActivationState.loading,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            labelText: 'رمز التفعيل',
                            hintText: 'مثال: ACT-8921',
                            prefixIcon: const Icon(
                              Icons.vpn_key_rounded,
                              color: AppColors.primary,
                            ),
                            suffixIcon: _codeController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded),
                                    onPressed: () {
                                      _codeController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال رمز التفعيل';
                            }
                            if (value.trim().length < 4) {
                              return 'رمز التفعيل يجب أن يتكون من 4 خانات على الأقل';
                            }
                            return null;
                          },
                        ),
                        AppSpacing.gapVerticalMD,

                        // --- عرض رسائل الحالة (خطأ أو نجاح) ---
                        if (_state == ActivationState.error && _errorMessage != null) ...[
                          Container(
                            padding: AppSpacing.paddingMD,
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: AppRadius.borderRadiusSM,
                              border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: AppColors.error,
                                  size: 22.0,
                                ),
                                AppSpacing.gapHorizontalSM,
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.gapVerticalMD,
                        ],

                        if (_state == ActivationState.success && _successMessage != null) ...[
                          Container(
                            padding: AppSpacing.paddingMD,
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: AppRadius.borderRadiusSM,
                              border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: AppColors.success,
                                  size: 22.0,
                                ),
                                AppSpacing.gapHorizontalSM,
                                Expanded(
                                  child: Text(
                                    _successMessage!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.gapVerticalMD,
                        ],

                        // --- زر تفعيل الجهاز ---
                        ElevatedButton(
                          onPressed: _state == ActivationState.loading ? null : _submitActivation,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48.0),
                            shape: AppRadius.shapeMD,
                          ),
                          child: _state == ActivationState.loading
                              ? const SizedBox(
                                  width: 24.0,
                                  height: 24.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.verified_user_rounded, size: 20.0),
                                    SizedBox(width: 8.0),
                                    Text('تأكيد وربط الجهاز'),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
