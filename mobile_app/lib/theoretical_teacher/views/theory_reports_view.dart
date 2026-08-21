import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/attendance_analytics.dart';
import '../models/deprivation_student.dart';
import '../models/theory_course.dart';
import '../services/theoretical_teacher_service.dart';
import '../widgets/attendance_bar_chart.dart';
import '../widgets/attendance_pie_chart.dart';
import '../widgets/deprivation_risk_card.dart';

/// شاشة التقارير والتحليلات الإحصائية للمقرر النظري وكشوفات الحرمان (Theory Reports View)
class TheoryReportsView extends StatefulWidget {
  final TheoryCourse course;
  final TheoreticalTeacherService? theoreticalService;

  const TheoryReportsView({
    super.key,
    required this.course,
    this.theoreticalService,
  });

  @override
  State<TheoryReportsView> createState() => _TheoryReportsViewState();
}

class _TheoryReportsViewState extends State<TheoryReportsView> with SingleTickerProviderStateMixin {
  late final TheoreticalTeacherService _service;
  late final TabController _tabController;

  ScreenStateType _state = ScreenStateType.loading;
  AttendanceAnalytics? _analytics;
  List<DeprivationStudent> _allStudents = [];
  List<DeprivationStudent> _filteredStudents = [];

  String _selectedSection = 'ALL';
  String _selectedRisk = 'ALL'; // ALL | AT_RISK | WARNING_FIRST | WARNING_SECOND | DEPRIVED
  String _searchQuery = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.theoreticalService ?? TheoreticalTeacherService();
    _tabController = TabController(length: 2, vsync: this);
    _loadReportsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReportsData() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final analyticsFuture = _service.getCourseAnalytics(widget.course.id);
      final studentsFuture = _service.getDeprivationStudents(widget.course.id);

      final results = await Future.wait([analyticsFuture, studentsFuture]);

      final analytics = results[0] as AttendanceAnalytics;
      final students = results[1] as List<DeprivationStudent>;

      if (!mounted) return;

      setState(() {
        _analytics = analytics;
        _allStudents = students;
        _applyFilters();
        _state = ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل تقارير المقرر: $e';
      });
    }
  }

  void _applyFilters() {
    List<DeprivationStudent> result = List.from(_allStudents);

    if (_selectedSection != 'ALL') {
      result = result.where((s) => s.sectionNumber == _selectedSection).toList();
    }

    if (_selectedRisk != 'ALL') {
      switch (_selectedRisk) {
        case 'AT_RISK':
          result = result.where((s) => s.isAtRisk).toList();
          break;
        case 'WARNING_FIRST':
          result = result.where((s) => s.riskLevel == DeprivationRiskLevel.warningFirst).toList();
          break;
        case 'WARNING_SECOND':
          result = result.where((s) => s.riskLevel == DeprivationRiskLevel.warningSecond).toList();
          break;
        case 'DEPRIVED':
          result = result.where((s) => s.riskLevel == DeprivationRiskLevel.deprived).toList();
          break;
      }
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      result = result.where((s) {
        return s.fullName.toLowerCase().contains(q) ||
            s.studentNumber.toLowerCase().contains(q) ||
            s.departmentName.toLowerCase().contains(q);
      }).toList();
    }

    _filteredStudents = result;
  }

  Future<void> _handleSendWarning(DeprivationStudent student, String warningType) async {
    try {
      await _service.sendDeprivationWarning(widget.course.id, student.studentId, warningType);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال الإشعار وتحديث سجل الطالب: ${student.fullName}'),
          backgroundColor: AppColors.success,
        ),
      );
      _loadReportsData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل إرسال الإنذار: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleExportReport(String format) async {
    try {
      final filename = await _service.exportAttendanceReport(widget.course.id, format);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم استخراج وتصدير التقرير بنجاح: $filename'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل تصدير التقرير: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    return Scaffold(
      appBar: AppBar(
        title: Text('تقارير ${course.courseCode}'),
        actions: [
          IconButton(
            onPressed: () => _showExportBottomSheet(context),
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'تصدير التقرير',
          ),
          IconButton(
            onPressed: _loadReportsData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
          tabs: const [
            Tab(
              icon: Icon(Icons.insights_rounded, size: 20.0),
              text: 'التحليلات والمخططات',
            ),
            Tab(
              icon: Icon(Icons.warning_amber_rounded, size: 20.0),
              text: 'كشف الحرمان والإنذارات',
            ),
          ],
        ),
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري توليد التقارير الإحصائية للمقرر...',
        errorMessage: _errorMessage,
        onRetry: _loadReportsData,
        child: TabBarView(
          controller: _tabController,
          children: [
            // التبويب الأول: التحليلات والرسوم البيانية
            _buildAnalyticsTab(context),
            // التبويب الثاني: كشف الحرمان والإنذارات
            _buildDeprivationTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab(BuildContext context) {
    final a = _analytics;
    if (a == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: _loadReportsData,
      child: ListView(
        padding: AppSpacing.paddingLG,
        children: [
          // بطاقة معلومات المقرر العلوية
          _buildCourseHeaderBanner(),
          AppSpacing.gapVerticalLG,
          // بطاقات العدادات الأربعة
          _buildMetricsGrid(a),
          AppSpacing.gapVerticalLG,
          // المخطط الدائري
          AttendancePieChart(analytics: a),
          AppSpacing.gapVerticalLG,
          // مخطط الأعمدة الأسبوعي
          AttendanceBarChart(weeklyTrends: a.weeklyTrends),
          AppSpacing.gapVerticalXL,
        ],
      ),
    );
  }

  Widget _buildDeprivationTab(BuildContext context) {
    final theme = Theme.of(context);
    final totalAtRisk = _allStudents.where((s) => s.isAtRisk).length;
    final totalDeprived = _allStudents.where((s) => s.isDeprived).length;

    return RefreshIndicator(
      onRefresh: _loadReportsData,
      child: ListView(
        padding: AppSpacing.paddingLG,
        children: [
          // بنر ملخص الحرمان
          Container(
            padding: AppSpacing.paddingMD,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(AppRadius.radiusMD),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.error, size: 22.0),
                AppSpacing.gapHorizontalMD,
                Expanded(
                  child: Text(
                    'إجمالي الطلاب في منطقة الخطر ($totalAtRisk) | قرارات الحرمان النهائي ($totalDeprived)',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapVerticalMD,
          // حقل البحث
          TextField(
            decoration: InputDecoration(
              hintText: 'البحث باسم الطالب أو الرقم الجامعي...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _applyFilters();
                        });
                      },
                      icon: const Icon(Icons.clear_rounded),
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
                _applyFilters();
              });
            },
          ),
          AppSpacing.gapVerticalMD,
          // فلترة الشعب ومستوى الخطر
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSectionFilterChip('ALL', 'كافة الشعب'),
                ...widget.course.sections.map((sec) => Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: _buildSectionFilterChip(sec, 'شعبة $sec'),
                    )),
                const SizedBox(width: 8.0),
                Container(width: 1.0, height: 20.0, color: AppColors.border),
                const SizedBox(width: 8.0),
                _buildRiskFilterChip('ALL', 'الكل (${_allStudents.length})'),
                AppSpacing.gapHorizontalSM,
                _buildRiskFilterChip('AT_RISK', 'المعرضين للحرمان ($totalAtRisk)'),
                AppSpacing.gapHorizontalSM,
                _buildRiskFilterChip('WARNING_SECOND', 'إنذار ثانٍ حرج'),
                AppSpacing.gapHorizontalSM,
                _buildRiskFilterChip('DEPRIVED', 'حرمان نهائي ($totalDeprived)'),
              ],
            ),
          ),
          AppSpacing.gapVerticalLG,
          // ترويسة القائمة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الطلاب المسجلين (${_filteredStudents.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'نظام الإنذارات الأكاديمية',
                style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
              ),
            ],
          ),
          AppSpacing.gapVerticalSM,
          if (_filteredStudents.isEmpty)
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
                  Icon(Icons.search_off_rounded, size: 48.0, color: AppColors.textSecondary),
                  AppSpacing.gapVerticalMD,
                  Text(
                    'لا يوجد طلاب مطابقين لمعايير التصفية الحالية',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          else
            ..._filteredStudents.map(
              (std) => DeprivationRiskCard(
                student: std,
                onSendWarning: (type) => _handleSendWarning(std, type),
              ),
            ),
          AppSpacing.gapVerticalXL,
        ],
      ),
    );
  }

  Widget _buildCourseHeaderBanner() {
    final c = widget.course;
    return Container(
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                c.courseName,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16.0),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                ),
                child: Text(
                  c.courseCode,
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            '${c.departmentName} | ${c.creditHours} ساعات معتمدة | ${c.totalLecturesDelivered} محاضرة منجزة',
            style: const TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(AttendanceAnalytics a) {
    return Row(
      children: [
        _buildMetricBox('نسبة الحضور', '${a.presentPercentage.toStringAsFixed(1)}%', AppColors.success),
        AppSpacing.gapHorizontalSM,
        _buildMetricBox('نسبة الغياب', '${a.absentPercentage.toStringAsFixed(1)}%', AppColors.error),
        AppSpacing.gapHorizontalSM,
        _buildMetricBox('متأخرين', a.lateCount.toString(), AppColors.warning),
        AppSpacing.gapHorizontalSM,
        _buildMetricBox('معذورين', a.excusedCount.toString(), const Color(0xFF0284C7)),
      ],
    );
  }

  Widget _buildMetricBox(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusMD),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 3.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionFilterChip(String key, String label) {
    final isSelected = _selectedSection == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedSection = key;
            _applyFilters();
          });
        }
      },
      selectedColor: const Color(0xFF1E293B),
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 11.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSM),
        side: BorderSide(
          color: isSelected ? const Color(0xFF1E293B) : AppColors.border,
        ),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildRiskFilterChip(String key, String label) {
    final isSelected = _selectedRisk == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedRisk = key;
            _applyFilters();
          });
        }
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 11.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSM),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      showCheckmark: false,
    );
  }

  void _showExportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.radiusLG)),
      ),
      builder: (ctx) => Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تصدير تقرير الحضور والغياب',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            const Text(
              'اختر الصيغة المناسبة لتصدير الكشوفات الرسمية',
              style: TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
            ),
            AppSpacing.gapVerticalLG,
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.error),
              title: const Text('تقرير PDF رسمي معتمد (لشؤون الطلاب)'),
              subtitle: const Text('يتضمن إحصائيات المحاضرات وقائمة الحرمان'),
              onTap: () {
                Navigator.of(ctx).pop();
                _handleExportReport('pdf');
              },
            ),
            const Divider(height: 1.0),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined, color: AppColors.success),
              title: const Text('كشف إكسل Excel تفصيلي (XLSX)'),
              subtitle: const Text('جدول بيانات رقمي كامل لجميع الطلاب والشعب'),
              onTap: () {
                Navigator.of(ctx).pop();
                _handleExportReport('xlsx');
              },
            ),
          ],
        ),
      ),
    );
  }
}
