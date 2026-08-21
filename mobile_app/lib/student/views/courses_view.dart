import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/student_course.dart';
import '../services/student_service.dart';
import '../widgets/course_card.dart';
import 'course_details_view.dart';

/// شاشة استعراض المقررات والشعب المسجلة للطالب (Courses & Sections View)
class CoursesView extends StatefulWidget {
  final StudentService? studentService;

  const CoursesView({
    super.key,
    this.studentService,
  });

  @override
  State<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView> {
  late final StudentService _service;
  ScreenStateType _state = ScreenStateType.loading;
  List<StudentCourse> _allCourses = [];
  List<StudentCourse> _filteredCourses = [];
  String _selectedFilter = 'ALL'; // ALL | PRACTICAL | THEORETICAL
  String _searchQuery = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.studentService ?? StudentService();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final courses = await _service.getEnrolledCourses();
      if (!mounted) return;\n
      setState(() {
        _allCourses = courses;
        _applyFilters();
        _state = courses.isEmpty ? ScreenStateType.empty : ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل قائمة المقررات المسجلة: $e';
      });
    }
  }

  void _applyFilters() {
    List<StudentCourse> result = List.from(_allCourses);

    if (_selectedFilter == 'PRACTICAL') {
      result = result.where((c) => c.isPractical).toList();
    } else if (_selectedFilter == 'THEORETICAL') {
      result = result.where((c) => c.isTheoretical).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      result = result.where((c) {
        return c.title.toLowerCase().contains(query) ||
            c.courseCode.toLowerCase().contains(query) ||
            c.teacherName.toLowerCase().contains(query);
      }).toList();
    }

    _filteredCourses = result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المقررات والشعب المسجلة'),
        actions: [
          IconButton(
            onPressed: _loadCourses,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري تحميل المقررات المسجلة...',\n        emptyTitle: 'لا توجد مقررات مسجلة',
        emptyMessage: 'لم يتم العثور على أي مقررات مسجلة لك في هذا الفصل الأكاديمي.',
        emptyIcon: Icons.menu_book_rounded,
        errorMessage: _errorMessage,
        onRetry: _loadCourses,
        child: RefreshIndicator(
          onRefresh: _loadCourses,
          child: ListView(
            padding: AppSpacing.paddingLG,
            children: [
              // حقل البحث
              TextField(
                decoration: InputDecoration(
                  hintText: 'البحث باسم المادة، الرمز، أو الأستاذ...',
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
                  enabledBorder: OutlineInputBorder(
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
              // أزرار التصفية (الكل / عملي / نظري)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('ALL', 'جميع الشعب (${_allCourses.length})'),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip(
                      'PRACTICAL',
                      'شعب عملية (${_allCourses.where((c) => c.isPractical).length})',
                    ),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip(
                      'THEORETICAL',
                      'شعب نظرية (${_allCourses.where((c) => c.isTheoretical).length})',
                    ),
                  ],
                ),
              ),
              AppSpacing.gapVerticalLG,
              // عنوان القائمة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المقررات المتاحة (${_filteredCourses.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'الفصل الحالي',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              if (_filteredCourses.isEmpty)
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
                        'لا توجد مواد مطابقة لمعايير البحث الحالية',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              else
                ..._filteredCourses.map(
                  (course) => CourseCard(
                    course: course,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailsView(
                            courseId: course.id,
                            initialCourse: course,
                            studentService: _service,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = key;
            _applyFilters();
          });
        }
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 12.0,
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
}
