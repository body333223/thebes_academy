import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/features/student/domain/entities/academic_entities.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';

class SummerCourseScreen extends StatefulWidget {
  const SummerCourseScreen({super.key});

  @override
  State<SummerCourseScreen> createState() => _SummerCourseScreenState();
}

class _SummerCourseScreenState extends State<SummerCourseScreen> {
  SummerCourseCategory? _selectedFilter;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.watch<StudentController>();
    final summary = controller.summerSummary;

    final filteredCourses = controller.availableSummerCourses.where((c) {
      if (_selectedFilter != null && c.category != _selectedFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = c.titleAr.toLowerCase().contains(q) || c.titleEn.toLowerCase().contains(q);
        final matchesCode = c.code.toLowerCase().contains(q);
        return matchesTitle || matchesCode;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'التسجيل الصيفي ومصاريف السمر' : 'Summer Term Registration & Fees'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1140),
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.fromLTRB(
                  context.responsiveValue(mobile: 16.0, tablet: 24.0),
                  16.0,
                  context.responsiveValue(mobile: 16.0, tablet: 24.0),
                  160.0, // Extra padding for the floating dock
                ),
                children: [
                  // 1. Summer Term Info Banner
                  _buildSummerHeroBanner(context, isArabic, isDark, summary),
                  const SizedBox(height: 18),

                  // 2. Rules & Tuition Regulations Card
                  _buildTuitionRulesCard(context, isArabic, isDark),
                  const SizedBox(height: 20),

                  // 3. Search & Filter Bar
                  _buildSearchAndFilters(context, isArabic, isDark),
                  const SizedBox(height: 16),

                  // 4. Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic ? 'المقررات الصيفية المتاحة للتسجيل' : 'Available Summer Courses',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : ThebesColors.primaryDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ThebesColors.gold.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ThebesColors.gold.withAlpha(90)),
                        ),
                        child: Text(
                          '${filteredCourses.length} ${isArabic ? "مقررات" : "courses"}',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: ThebesColors.gold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 5. Courses List
                  ...filteredCourses.map((course) {
                    final isEnrolled = controller.isCourseSelectedInSummer(course.code);
                    return _buildCourseCard(context, course, isEnrolled, controller, isArabic, isDark);
                  }),
                ],
              ),

              // 6. Floating Frosted Glass Summary Dock
              Positioned(
                bottom: 16,
                left: context.responsiveValue(mobile: 16.0, tablet: 32.0),
                right: context.responsiveValue(mobile: 16.0, tablet: 32.0),
                child: _buildFloatingSummaryDock(context, summary, controller, isArabic, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Hero Banner
  Widget _buildSummerHeroBanner(BuildContext context, bool isArabic, bool isDark, SummerRegistrationSummary summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C1F3D), Color(0xFF16325C), Color(0xFF1E427B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ThebesColors.gold.withAlpha(150), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ThebesColors.primaryDark.withAlpha(120),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orangeAccent),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wb_sunny_rounded, size: 16, color: Colors.orangeAccent),
                    const SizedBox(width: 6),
                    Text(
                      isArabic ? 'الفصل الدراسي الصيفي 2026' : 'Summer Semester 2026',
                      style: GoogleFonts.cairo(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.withAlpha(120)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: Colors.redAccent),
                    const SizedBox(width: 5),
                    Text(
                      isArabic ? 'متبقي 4 أيام على إغلاق التسجيل' : '4 Days Remaining',
                      style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isArabic ? 'بوابة التسجيل الصيفي واحتساب المصروفات' : 'Summer Course Enrollment & Fees Calculator',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isArabic
              ? 'يمكنك تسجيل مواد التخلف أو تحسين المعدل التراكمي (GPA) بحد أقصى 9 ساعات معتمدة (3 مقررات). تُحتسب مصاريف الساعة بـ 450 ج.م.'
              : 'Enroll in arrear courses or improve your CGPA up to 9 credit hours (3 courses max) at 450 EGP per credit hour.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: Colors.white.withAlpha(210),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Rules Card
  Widget _buildTuitionRulesCard(BuildContext context, bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1B2E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? ThebesColors.darkCardBorder : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThebesColors.gold.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calculate_rounded, color: ThebesColors.gold, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                isArabic ? 'ضوابط ولائحة الرسوم الصيفية المعتمدة' : 'Official Summer Tuition Regulations',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildRuleChip('💰 450 ج.م / ساعة معتمدة', isArabic ? 'تكلفة الساعة' : 'Per Credit Hour', isDark),
              _buildRuleChip('⏳ 9 ساعات كحد أقصى', isArabic ? '3 مقررات فقط' : 'Max 3 Courses', isDark),
              _buildRuleChip('🔬 350 ج.م للمقررات العملية', isArabic ? 'رسوم معامل' : 'Lab Fees', isDark),
              _buildRuleChip('🏛️ 250 ج.م رسوم إدارية', isArabic ? 'لكامل الفصل' : 'Admin Flat Fee', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRuleChip(String title, String subtitle, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13233A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ThebesColors.gold.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: ThebesColors.gold)),
          Text(subtitle, style: TextStyle(fontSize: 10, color: isDark ? Colors.grey : ThebesColors.lightTextMuted)),
        ],
      ),
    );
  }

  // 3. Search and Filters
  Widget _buildSearchAndFilters(BuildContext context, bool isArabic, bool isDark) {
    return Column(
      children: [
        // Search Input
        TextField(
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: isArabic ? 'ابحث باسم المادة أو كود المقرر (مثال: CS201)...' : 'Search course title or code...',
            prefixIcon: const Icon(Icons.search_rounded, color: ThebesColors.gold),
            filled: true,
            fillColor: isDark ? const Color(0xFF0D1B2E) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: isDark ? ThebesColors.darkCardBorder : const Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: isDark ? ThebesColors.darkCardBorder : const Color(0xFFE2E8F0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 10),

        // Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(
                label: isArabic ? 'الكل' : 'All Courses',
                isSelected: _selectedFilter == null,
                onTap: () => setState(() => _selectedFilter = null),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: isArabic ? 'مواد تخلف ورسوب (Retake)' : 'Retake',
                isSelected: _selectedFilter == SummerCourseCategory.retake,
                onTap: () => setState(() => _selectedFilter = SummerCourseCategory.retake),
                isDark: isDark,
                badgeColor: ThebesColors.error,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: isArabic ? 'تحسين تقدير (GPA)' : 'Improvement',
                isSelected: _selectedFilter == SummerCourseCategory.improvement,
                onTap: () => setState(() => _selectedFilter = SummerCourseCategory.improvement),
                isDark: isDark,
                badgeColor: ThebesColors.gold,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: isArabic ? 'تسجيل مسبق (Fast-Track)' : 'Advance',
                isSelected: _selectedFilter == SummerCourseCategory.advance,
                onTap: () => setState(() => _selectedFilter = SummerCourseCategory.advance),
                isDark: isDark,
                badgeColor: ThebesColors.emerald,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    Color? badgeColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? (badgeColor ?? ThebesColors.primary)
              : (isDark ? const Color(0xFF0D1B2E) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (badgeColor ?? ThebesColors.gold)
                : (isDark ? ThebesColors.darkCardBorder : const Color(0xFFE2E8F0)),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : ThebesColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  // 4. Course Card
  Widget _buildCourseCard(
    BuildContext context,
    SummerCourseEntity course,
    bool isEnrolled,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    Color catColor;
    switch (course.category) {
      case SummerCourseCategory.retake:
        catColor = ThebesColors.error;
        break;
      case SummerCourseCategory.improvement:
        catColor = ThebesColors.gold;
        break;
      case SummerCourseCategory.advance:
        catColor = ThebesColors.emerald;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1B2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEnrolled ? ThebesColors.gold : (isDark ? ThebesColors.darkCardBorder : const Color(0xFFE2E8F0)),
          width: isEnrolled ? 2 : 1,
        ),
        boxShadow: isEnrolled
            ? [
                BoxShadow(
                  color: ThebesColors.gold.withAlpha(40),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: catColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: catColor.withAlpha(90)),
                    ),
                    child: Text(
                      course.code,
                      style: TextStyle(fontWeight: FontWeight.w900, color: catColor, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF13233A) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      course.getCategoryLabel(isArabic),
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: catColor),
                    ),
                  ),
                ],
              ),
              // Credit Hours & Cost
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${course.tuitionTotal.toInt()} ج.م',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: ThebesColors.gold,
                    ),
                  ),
                  Text(
                    '${course.creditHours} ${isArabic ? "ساعات معتمدة" : "Credit Hours"}',
                    style: TextStyle(fontSize: 10.5, color: isDark ? Colors.grey : ThebesColors.lightTextMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Course Title
          Text(
            course.getLocalizedTitle(isArabic),
            style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          // Details: Instructor, Lab, Schedule
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_outline_rounded, size: 15, color: ThebesColors.primaryLight),
                  const SizedBox(width: 4),
                  Text(course.getLocalizedInstructor(isArabic), style: TextStyle(fontSize: 11.5, color: isDark ? Colors.grey : ThebesColors.lightTextMuted)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time_rounded, size: 15, color: ThebesColors.gold),
                  const SizedBox(width: 4),
                  Text(course.getLocalizedSchedule(isArabic), style: TextStyle(fontSize: 11.5, color: isDark ? Colors.grey : ThebesColors.lightTextMuted)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.place_outlined, size: 15, color: ThebesColors.emerald),
                  const SizedBox(width: 4),
                  Text(course.hall, style: TextStyle(fontSize: 11.5, color: isDark ? Colors.grey : ThebesColors.lightTextMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Prerequisite Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ThebesColors.emerald.withAlpha(20),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${isArabic ? "المتطلب السابق:" : "Prerequisite:"} ${course.prerequisite} (مستوفى بنجاح)',
              style: const TextStyle(fontSize: 11, color: ThebesColors.emerald, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 14),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnrolled ? ThebesColors.emerald : ThebesColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: isEnrolled ? 4 : 1,
              ),
              onPressed: () {
                final success = controller.toggleSummerCourse(course);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? 'عفواً! لقد بلغت الحد الأقصى للساعات المسموح بها في السمر (9 ساعات معتمدة).'
                            : 'Maximum credit hours allowed in summer term is 9 hours.',
                      ),
                      backgroundColor: ThebesColors.error,
                    ),
                  );
                }
              },
              icon: Icon(isEnrolled ? Icons.check_circle_rounded : Icons.add_rounded, size: 18),
              label: Text(
                isEnrolled
                    ? (isArabic ? 'المقرر مضاف لجدولك الصيفي (إزالة)' : 'Enrolled (Tap to Remove)')
                    : (isArabic ? 'إضافة إلى خطة السمر كورس' : 'Add to Summer Plan'),
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5. Floating Summary Dock
  Widget _buildFloatingSummaryDock(
    BuildContext context,
    SummerRegistrationSummary summary,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C1B30).withAlpha(245) : Colors.white.withAlpha(245),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ThebesColors.gold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hours & Meter
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${summary.totalCreditHours} / ${summary.maxCreditHoursAllowed}',
                        style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.w900, color: ThebesColors.gold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'ساعات معتمدة مسجلة' : 'Credit Hours',
                        style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white70 : ThebesColors.lightTextSecondary),
                      ),
                    ],
                  ),
                  Text(
                    '${summary.selectedCourses.length} ${isArabic ? "مقررات مختارة" : "Courses"} (متبقي ${summary.remainingHours} س)',
                    style: TextStyle(fontSize: 11, color: isDark ? Colors.grey : ThebesColors.lightTextMuted),
                  ),
                ],
              ),

              // Total Fees Display
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${summary.grandTotalFees.toInt()} ج.م',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: ThebesColors.emerald,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showFeeBreakdownDialog(context, summary, isArabic, isDark),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isArabic ? 'تفاصيل المصروفات' : 'View Breakdown',
                          style: const TextStyle(fontSize: 11, color: ThebesColors.cyanAccent, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.info_outline_rounded, size: 13, color: ThebesColors.cyanAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: summary.selectedCourses.isNotEmpty ? ThebesColors.gold : Colors.grey,
                foregroundColor: ThebesColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: summary.selectedCourses.isNotEmpty
                  ? () => _showCheckoutDialog(context, summary, controller, isArabic, isDark)
                  : null,
              icon: const Icon(Icons.payments_rounded, size: 18),
              label: Text(
                summary.isPaid
                    ? (isArabic ? 'عرض إيصال السداد المعتمد (مسدد)' : 'View Receipt (Paid)')
                    : (isArabic ? 'تأكيد التسجيل وسداد المصروفات' : 'Confirm Registration & Pay'),
                style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Breakdown Dialog
  void _showFeeBreakdownDialog(
    BuildContext context,
    SummerRegistrationSummary summary,
    bool isArabic,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isArabic ? 'تفصيل رسوم ومصروفات السمر كورس' : 'Summer Term Tuition Breakdown'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFeeRow(isArabic ? 'ساعات الدراسة (${summary.totalCreditHours} س × 450 ج.م):' : 'Credit Hours Fee:', '${summary.totalHoursTuition.toInt()} ج.م'),
            const SizedBox(height: 8),
            _buildFeeRow(isArabic ? 'رسوم المعامل والتقنية:' : 'Labs & Computing Fee:', '${summary.totalLabFees.toInt()} ج.م'),
            const SizedBox(height: 8),
            _buildFeeRow(isArabic ? 'الرسوم الإدارية المعتمدة:' : 'Administrative Flat Fee:', '${summary.administrativeFee.toInt()} ج.م'),
            const Divider(height: 24),
            _buildFeeRow(
              isArabic ? 'الإجمالي النهائي المستحق:' : 'Total Amount Due:',
              '${summary.grandTotalFees.toInt()} ج.م',
              isBold: true,
              color: ThebesColors.emerald,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12.5, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.w900 : FontWeight.bold, color: color)),
      ],
    );
  }

  // Checkout and Electronic Payment Dialog
  void _showCheckoutDialog(
    BuildContext context,
    SummerRegistrationSummary summary,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF0D1B2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(90),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  isArabic ? 'تأكيد التسجيل وسداد المصروفات الصيفية' : 'Confirm Registration & Checkout',
                  style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  isArabic
                      ? 'اختر طريقة السداد لإتمام قيد المقررات رسمياً بكنترول أكاديمية طيبة'
                      : 'Select payment method to finalize registration at Thebes Control Dept',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 18),

                // Selected courses summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF13233A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: summary.selectedCourses.map((c) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${c.code} - ${c.getLocalizedTitle(isArabic)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('${c.creditHours} س • ${c.tuitionTotal.toInt()} ج.م', style: const TextStyle(fontSize: 12, color: ThebesColors.gold, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),

                // Payment Options
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _buildPayMethodButton('فوري (Fawry Pay)', Icons.store_rounded, isDark),
                    _buildPayMethodButton('البطاقات البنكية (Visa / Master)', Icons.credit_card_rounded, isDark),
                    _buildPayMethodButton('إنستاباي (InstaPay)', Icons.bolt_rounded, isDark),
                    _buildPayMethodButton('خزينة الأكاديمية (الكاش)', Icons.account_balance_rounded, isDark),
                  ],
                ),
                const SizedBox(height: 20),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThebesColors.emerald,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      controller.submitAndPaySummerRegistration(paymentMethod: 'Electronic');
                      Navigator.pop(ctx);
                      _showReceiptDialog(context, controller.summerSummary, isArabic, isDark);
                    },
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      isArabic ? 'تأكيد السداد (${summary.grandTotalFees.toInt()} ج.م)' : 'Pay Now (${summary.grandTotalFees.toInt()} EGP)',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPayMethodButton(String title, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13233A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ThebesColors.gold.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: ThebesColors.gold),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Electronic Receipt Dialog
  void _showReceiptDialog(
    BuildContext context,
    SummerRegistrationSummary summary,
    bool isArabic,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: ThebesColors.emerald, size: 54),
            const SizedBox(height: 10),
            Text(
              isArabic ? 'تم تأكيد تسجيل وسداد السمر كورس بنجاح' : 'Registration & Payment Successful',
              style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              '${isArabic ? "رقم الإيصال الرسمي:" : "Receipt No:"} ${summary.receiptNumber}',
              style: const TextStyle(fontSize: 12, color: ThebesColors.gold, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: QrImageView(
                data: 'THEBES-SUMMER-RECEIPT:${summary.receiptNumber}:${summary.grandTotalFees}',
                version: QrVersions.auto,
                size: 130,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isArabic
                  ? 'تم إرسال نسخة من إيصال السداد المعتمد إلى بريدك الأكاديمي، وتم قيد المواد تلقائياً في حسابك.'
                  : 'Official receipt sent to your academic email. Courses enrolled at control.',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'حسناً' : 'OK'),
          ),
        ],
      ),
    );
  }
}
