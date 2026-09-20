import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/thebes_colors.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/responsive/responsive_helper.dart';
import '../../features/student/domain/entities/academic_entities.dart';
import '../../features/student/presentation/controllers/student_controller.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.watch<StudentController>();
    final student = controller.student;
    final grades = controller.grades;
    final isTabletOrDesktop = context.isTablet || context.isDesktop;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.tr('academic_results')),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate_outlined, color: ThebesColors.gold),
            onPressed: () => _showGpaCalculator(context, locale, student.gpa, student.completedHours),
            tooltip: 'GPA Simulator',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1140),
          child: SingleChildScrollView(
            padding: context.responsiveScreenPadding,
            child: Column(
              children: [
                // 1. GPA Hero Gauge Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: ThebesColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: ThebesColors.gold, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: ThebesColors.opacity(ThebesColors.primaryDark, 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.tr('cumulative_gpa'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    student.gpa.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: context.responsiveValue(mobile: 30.0, tablet: 36.0),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const Text(
                                    ' / 4.00',
                                    style: TextStyle(
                                      color: ThebesColors.gold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThebesColors.opacity(ThebesColors.gold, 0.2),
                              border: Border.all(color: ThebesColors.gold, width: 2),
                            ),
                            child: const Icon(
                              Icons.military_tech_rounded,
                              color: ThebesColors.gold,
                              size: 38,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withAlpha(40), height: 1),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGpaMetric(
                            isArabic ? 'التقدير العام' : 'Standing',
                            isArabic ? 'امتياز (A)' : 'Excellent (A)',
                            ThebesColors.gold,
                          ),
                          _buildGpaMetric(
                            isArabic ? 'الساعات المنجزة' : 'Credit Hours',
                            '${student.completedHours} / ${student.totalRequiredHours}',
                            Colors.white,
                          ),
                          _buildGpaMetric(
                            locale.tr('honors_status'),
                            isArabic ? 'مستحق' : 'Honors',
                            ThebesColors.success,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Semester Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'مقررات الفصل الأخير (ربيع 2026)' : 'Last Term Courses (Spring 2026)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : ThebesColors.primaryDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ThebesColors.opacity(ThebesColors.primary, 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isArabic ? '${grades.length} مواد معتمدة' : '${grades.length} Courses',
                        style: const TextStyle(
                          color: ThebesColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Responsive Grades Grid or Column
                if (isTabletOrDesktop)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      return _buildGradeCard(grades[index], isArabic, isDark);
                    },
                  )
                else
                  ...grades.map((g) => _buildGradeCard(g, isArabic, isDark)),

                const SizedBox(height: 16),

                // GPA Simulator Button
                OutlinedButton.icon(
                  onPressed: () => _showGpaCalculator(context, locale, student.gpa, student.completedHours),
                  icon: const Icon(Icons.calculate_rounded, color: ThebesColors.gold),
                  label: Text(
                    isArabic ? 'حاسبة المعدل التراكمي المتوقع (GPA Simulator)' : 'Simulate Next Semester GPA',
                    style: TextStyle(
                      color: isDark ? Colors.white : ThebesColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    side: const BorderSide(color: ThebesColors.gold, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGpaMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGradeCard(GradeEntity grade, bool isArabic, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grade.courseCode,
                      style: const TextStyle(
                        color: ThebesColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      grade.getLocalizedCourse(isArabic),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : ThebesColors.primaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ThebesColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ThebesColors.gold),
                ),
                child: Column(
                  children: [
                    Text(
                      grade.gradeLetter,
                      style: const TextStyle(
                        color: ThebesColors.gold,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${grade.points} pts',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.withAlpha(50), height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScoreColumn(isArabic ? 'أعمال سنة' : 'Work', '${grade.courseworkScore.toInt()}/20', isDark),
              _buildScoreColumn(isArabic ? 'ميدتيرم' : 'Midterm', '${grade.midtermScore.toInt()}/20', isDark),
              _buildScoreColumn(isArabic ? 'عملي' : 'Lab', '${grade.practicalScore.toInt()}/10', isDark),
              _buildScoreColumn(isArabic ? 'فاينال' : 'Final', '${grade.finalExamScore.toInt()}/50', isDark),
              _buildScoreColumn(isArabic ? 'المجموع' : 'Total', '${grade.totalScore.toInt()}/100', isDark, isTotal: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(String label, String score, bool isDark, {bool isTotal = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.grey : ThebesColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          score,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: isTotal
                ? ThebesColors.gold
                : (isDark ? Colors.white70 : ThebesColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }

  void _showGpaCalculator(BuildContext context, LocaleProvider locale, double currentGpa, int completedHours) {
    final controller = context.read<StudentController>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final courses = controller.grades;

    // Default expected grade letter map for each course
    final Map<String, String> expectedLetters = {
      for (var c in courses) c.courseCode: c.gradeLetter.isEmpty ? 'A' : c.gradeLetter,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final simulatedGpa = controller.calculateSimulatedGpa(expectedLetters);
          final delta = simulatedGpa - currentGpa;
          final isPositive = delta >= 0;

          String standingText;
          Color standingColor;
          if (simulatedGpa >= 3.7) {
            standingText = isArabic ? 'امتياز مع مرتبة الشرف 🏆' : 'Excellent with Honors 🏆';
            standingColor = ThebesColors.gold;
          } else if (simulatedGpa >= 3.4) {
            standingText = isArabic ? 'جيد جداً مرتفع 🌟' : 'Very Good High 🌟';
            standingColor = ThebesColors.emerald;
          } else if (simulatedGpa >= 3.0) {
            standingText = isArabic ? 'جيد جداً 🎖️' : 'Very Good 🎖️';
            standingColor = ThebesColors.accentBlue;
          } else if (simulatedGpa >= 2.4) {
            standingText = isArabic ? 'جيد 👍' : 'Good 👍';
            standingColor = Colors.orange;
          } else {
            standingText = isArabic ? 'إنذار أكاديمي محتمل ⚠️' : 'Academic Warning Risk ⚠️';
            standingColor = ThebesColors.error;
          }

          const gradeOptions = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'D', 'F'];

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(
                color: isDark ? ThebesColors.darkCardBorder : ThebesColors.gold.withAlpha(80),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ThebesColors.gold.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calculate_rounded, color: ThebesColors.gold, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'محاكي ومخطط المعدل التراكمي' : 'GPA Simulator & Planner',
                            style: GoogleFonts.cairo(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : ThebesColors.primaryNavy,
                            ),
                          ),
                          Text(
                            isArabic
                                ? 'حدد التقدير المتوقع لكل مادة لمعرفة تأثيره الفوري'
                                : 'Select expected grades to simulate your cumulative GPA',
                            style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Hero Result Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: ThebesColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ThebesColors.gold, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'المعدل الحالي' : 'Current GPA',
                                style: GoogleFonts.cairo(fontSize: 12, color: Colors.white70),
                              ),
                              Text(
                                currentGpa.toStringAsFixed(2),
                                style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_rounded, color: ThebesColors.gold, size: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                isArabic ? 'المعدل المتوقع الجديد' : 'Simulated GPA',
                                style: GoogleFonts.cairo(fontSize: 12, color: ThebesColors.gold),
                              ),
                              Row(
                                children: [
                                  Text(
                                    simulatedGpa.toStringAsFixed(2),
                                    style: GoogleFonts.cairo(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: ThebesColors.gold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isPositive ? ThebesColors.emerald : ThebesColors.error,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${isPositive ? '+' : ''}${delta.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          standingText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            color: standingColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Courses List Header
                Text(
                  isArabic ? 'تقديرات المواد المتوقعة للفصل الحالي:' : 'Expected Course Grades for Current Term:',
                  style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Courses List
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      final currentSelected = expectedLetters[course.courseCode] ?? 'A';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? ThebesColors.darkCard : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? ThebesColors.darkCardBorder : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.getLocalizedCourse(isArabic),
                                    style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : ThebesColors.primaryNavy,
                                    ),
                                  ),
                                  Text(
                                    '${course.courseCode} • ${course.creditHours} ${isArabic ? "ساعات" : "Credit Hrs"}',
                                    style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            // Grade Selector Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: ThebesColors.gold.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ThebesColors.gold.withAlpha(120)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: currentSelected,
                                  dropdownColor: isDark ? ThebesColors.darkCard : Colors.white,
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ThebesColors.gold,
                                  ),
                                  items: gradeOptions.map((g) {
                                    return DropdownMenuItem(
                                      value: g,
                                      child: Text(g),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    if (newVal != null) {
                                      setModalState(() {
                                        expectedLetters[course.courseCode] = newVal;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThebesColors.gold,
                    foregroundColor: ThebesColors.primaryNavy,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    isArabic ? 'اعتماد المحاكاة وإغلاق' : 'Save & Close',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
