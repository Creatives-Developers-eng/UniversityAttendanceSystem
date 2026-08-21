import 'dart:async';
import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/delegate_session.dart';
import '../models/delegate_student_entry.dart';
import '../services/delegate_service.dart';
import '../widgets/live_attendee_tile.dart';
import '../widgets/live_qr_broadcaster_card.dart';
import '../widgets/session_controls_bar.dart';
import 'delegate_attendance_sheet.dart';

/// واجهة استضافة وبث الجلسة الحية للمندوب (Live Session View)
class LiveSessionView extends StatefulWidget {
  final DelegateSession session;
  final DelegateService? delegateService;

  const LiveSessionView({
    super.key,
    required this.session,
    this.delegateService,
  });

  @override
  State<LiveSessionView> createState() => _LiveSessionViewState();
}

class _LiveSessionViewState extends State<LiveSessionView> {
  late final DelegateService _service;
  late DelegateSession _currentSession;
  ScreenStateType _state = ScreenStateType.loading;

  List<DelegateStudentEntry> _attendees = [];
  bool _isBroadcasting = true;
  Timer? _elapsedTimer;
  Duration _elapsedDuration = Duration.zero;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.delegateService ?? DelegateService();
    _currentSession = widget.session;
    _elapsedDuration = DateTime.now().difference(_currentSession.openedAt);

    _startElapsedTimer();
    _loadLiveAttendees();
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    super.dispose();
  }

  void _startElapsedTimer() {
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _elapsedDuration = DateTime.now().difference(_currentSession.openedAt);
      });
    });
  }

  Future<void> _loadLiveAttendees() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final list = await _service.getLiveAttendees(_currentSession.id);
      if (!mounted) return;

      setState(() {
        _attendees = list;
        _state = ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل سجل الحضور المباشر: $e';
      });
    }
  }

  void _toggleBroadcasting() {
    setState(() {
      _isBroadcasting = !_isBroadcasting;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBroadcasting ? 'تم استئناف بث رمز الـ QR بنجاح' : 'تم إيقاف بث رمز الـ QR مؤقتاً',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showManualAttendanceDialog() {
    final studentNumberController = TextEditingController();
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary),
            SizedBox(width: 8.0),
            Text('تحضير يدوي استثنائي'),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'يُستخدم في حالات استثنائية (عطل جهاز الطالب، فشل التحقق الحيوي) ويتطلب تبريراً لإرساله للأستاذ.',
                  style: TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                ),
                AppSpacing.gapVerticalMD,
                TextFormField(
                  controller: studentNumberController,
                  decoration: const InputDecoration(
                    labelText: 'الرقم الجامعي للطالب *',
                    hintText: 'STD-2023-XXXX',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'الرجاء إدخال الرقم الجامعي';
                    }
                    return null;
                  },
                ),
                AppSpacing.gapVerticalMD,
                TextFormField(
                  controller: reasonController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'سبب التحضير اليدوي *',
                    hintText: 'مثال: نفاذ بطارية هاتف الطالب أثناء القاعة',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'المبرر إلزامي لتوثيق الاستثناء';
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
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final studentNum = studentNumberController.text.trim();
                final reason = reasonController.text.trim();
                Navigator.of(ctx).pop();

                try {
                  final entry = await _service.requestManualAttendance(
                    _currentSession.id,
                    'std-man-${DateTime.now().millisecondsSinceEpoch}',
                    'PRESENT',
                    reason,
                  );

                  if (!mounted) return;

                  setState(() {
                    _attendees.insert(0, entry);
                    _currentSession = _currentSession.copyWith(
                      attendedCount: _attendees.length,
                    );
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم تسجيل حضور الطالب ($studentNum) يدوياً بنجاح'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('فشل تسجيل التحضير اليدوي: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('تأكيد التحضير'),
          ),
        ],
      ),
    );
  }

  void _showEndSessionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.stop_circle_rounded, color: AppColors.error),
            SizedBox(width: 8.0),
            Text('إنهاء الجلسة المحلية'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('هل أنت متأكد من رغبتك في إغلاق جلسة الحضور؟'),
            AppSpacing.gapVerticalSM,
            Text(
              'تم تسجيل حضور (${_attendees.length}) طالب حتى الآن. سيتم إيقاف بث الـ QR وحفظ السجلات محلياً بانتظار المزامنة المركزية.',
              style: const TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('متابعة الجلسة'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await _service.closeSession(_currentSession.id);
                if (!mounted) return;

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إغلاق الجلسة وحفظ كشف الحضور بنجاح.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل إغلاق الجلسة: $e'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('تأكيد الإنهاء'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPractical = _currentSession.sectionType.name == 'practical';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_currentSession.courseName, style: const TextStyle(fontSize: 15.0)),
            Text(
              '${_currentSession.courseCode} | ${_currentSession.roomName} (${isPractical ? "عملي" : "نظري"})',
              style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, size: 14.0, color: AppColors.primary),
                const SizedBox(width: 4.0),
                Text(
                  _formatDuration(_elapsedDuration),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.0,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // عدادات الحضور الإحصائية السريعة
          _buildMetricsHeader(context),
          Expanded(
            child: AppStateView(
              state: _state,
              loadingMessage: 'جاري تحميل الجلسة الحية...',
              emptyTitle: 'لا توجد تسجيلات حضور بعد',
              emptyMessage: 'وجّه الطلاب لمسح رمز الـ QR المعروض لبدء تدفق الحضور.',
              emptyIcon: Icons.qr_code_scanner_rounded,
              errorMessage: _errorMessage,
              onRetry: _loadLiveAttendees,
              child: ListView(
                padding: AppSpacing.paddingLG,
                children: [
                  // بطاقة بث الـ QR الديناميكي
                  LiveQrBroadcasterCard(
                    sessionId: _currentSession.id,
                    isBroadcasting: _isBroadcasting,
                  ),
                  AppSpacing.gapVerticalLG,
                  // عنوان تدفق الحضور المباشر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.stream_rounded, color: AppColors.primary, size: 20.0),
                          AppSpacing.gapHorizontalSM,
                          Text(
                            'تدفق الحضور اللحظي (${_attendees.length})',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DelegateAttendanceSheet(
                                sectionId: _currentSession.sectionId,
                                sessionId: _currentSession.id,
                                courseCode: _currentSession.courseCode,
                                courseName: _currentSession.courseName,
                                sectionNumber: _currentSession.sectionNumber,
                                delegateService: _service,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.list_alt_rounded, size: 16.0),
                        label: const Text('الكشف الكامل'),
                      ),
                    ],
                  ),
                  AppSpacing.gapVerticalSM,
                  if (_attendees.isEmpty)
                    Container(
                      padding: AppSpacing.paddingXL,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.wifi_tethering_rounded,
                            size: 40.0,
                            color: AppColors.textSecondary,
                          ),
                          AppSpacing.gapVerticalMD,
                          Text(
                            'الخادم المحلي جاهز ويستمع لطلبات الطلاب',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._attendees.map(
                      (attendee) => LiveAttendeeTile(attendee: attendee),
                    ),
                  const SizedBox(height: 80.0), // مساحة لشريط التحكم السفلي
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: SessionControlsBar(
        isBroadcasting: _isBroadcasting,
        onToggleBroadcast: _toggleBroadcasting,
        onEndSession: _showEndSessionDialog,
        onOpenSheet: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DelegateAttendanceSheet(
                sectionId: _currentSession.sectionId,
                sessionId: _currentSession.id,
                courseCode: _currentSession.courseCode,
                courseName: _currentSession.courseName,
                sectionNumber: _currentSession.sectionNumber,
                delegateService: _service,
              ),
            ),
          );
        },
        onManualAttendance: _showManualAttendanceDialog,
      ),
    );
  }

  Widget _buildMetricsHeader(BuildContext context) {
    final attended = _attendees.length;
    final total = _currentSession.totalExpectedStudents;
    final remaining = (total - attended).clamp(0, total);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMiniMetric('الحاضرين', attended.toString(), AppColors.success),
          const SizedBox(
            height: 24.0,
            child: VerticalDivider(color: AppColors.border, width: 1.0),
          ),
          _buildMiniMetric('في الطابور', '0', AppColors.primary),
          const SizedBox(
            height: 24.0,
            child: VerticalDivider(color: AppColors.border, width: 1.0),
          ),
          _buildMiniMetric('المتبقين', remaining.toString(), AppColors.warning),
          const SizedBox(
            height: 24.0,
            child: VerticalDivider(color: AppColors.border, width: 1.0),
          ),
          _buildMiniMetric('الإجمالي', total.toString(), AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String title, String val, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2.0),
        Text(
          val,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
