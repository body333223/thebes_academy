import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/features/student/domain/entities/academic_entities.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';

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
      backgroundColor: isDark ? ThebesColors.darkBackground : const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          locale.tr('academic_results'),
          style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate_outlined, color: Colors.white),
            onPressed: () => _showGpaCalculator(context, locale, student.gpa, student.completedHours),
            tooltip: 'GPA Simulator',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1140),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: context.responsiveScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Modern Academic GPA Hero Card
                _buildGpaHeroCard(context, student, isArabic, isDark, locale),
                const SizedBox(height: 24),

                // 2. Semester Selector & Course List Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'سجل درجات الفصل الدراسي' : 'Term Academic Record',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : ThebesColors.navy,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ThebesColors.cobaltPale,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ThebesColors.cobalt.withAlpha(50)),
                      ),
                      child: Text(
                        isArabic ? '${grades.length} مقررات' : '${grades.length} Courses',
                        style: GoogleFonts.cairo(
                          color: ThebesColors.cobalt,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 3. Responsive Course Grades Grid or List
                if (isTabletOrDesktop)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.1,
                    ),
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      return _buildGradeCard(grades[index], isArabic, isDark);
                    },
                  )
                else
                  ...grades.map((g) => _buildGradeCard(g, isArabic, isDark)),

                const SizedBox(height: 20),

                // 4. GPA Simulator Action Banner
                _buildSimulatorBanner(context, locale, student, isArabic, isDark),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGpaHeroCard(
    BuildContext context,
    dynamic student,
    bool isArabic,
    bool isDark,
    LocaleProvider locale,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: ThebesColors.primaryHeaderGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withAlpha(25), width: 1),
        boxShadow: [
          BoxShadow(
            color: ThebesColors.navy.withAlpha(45),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                    style: GoogleFonts.cairo(
                      color: const Color(0xFFE2E8F0),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        student.gpa.toStringAsFixed(2),
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: context.responsiveValue(mobile: 34.0, tablet: 40.0),
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ' / 4.00',
                        style: GoogleFonts.cairo(
                          color: ThebesColors.orangeLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withAlpha(30)),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: ThebesColors.orangeLight,
                  size: 34,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGpaMetric(
                  isArabic ? 'التقدير العام' : 'Standing',
                  isArabic ? 'امتياز (A)' : 'Excellent (A)',
                  ThebesColors.mint,
                ),
                Container(width: 1, height: 26, color: Colors.white.withAlpha(30)),
                _buildGpaMetric(
                  isArabic ? 'الساعات المنجزة' : 'Credit Hours',
                  '${student.completedHours} / ${student.totalRequiredHours}',
                  Colors.white,
                ),
                Container(width: 1, height: 26, color: Colors.white.withAlpha(30)),
                _buildGpaMetric(
                  locale.tr('honors_status'),
                  isArabic ? 'مرتبة الشرف' : 'Honors',
                  ThebesColors.orangeLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGpaMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            color: const Color(0xFFCBD5E1),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.cairo(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildGradeCard(GradeEntity grade, bool isArabic, bool isDark) {
    Color badgeBg;
    Color badgeText;

    if (grade.gradeLetter.startsWith('A')) {
      badgeBg = ThebesColors.mint.withAlpha(25);
      badgeText = ThebesColors.mint;
    } else if (grade.gradeLetter.startsWith('B')) {
      badgeBg = ThebesColors.cobaltPale;
      badgeText = ThebesColors.cobalt;
    } else if (grade.gradeLetter.startsWith('C')) {
      badgeBg = const Color(0xFFFEF3C7);
      badgeText = const Color(0xFFD97706);
    } else {
      badgeBg = const Color(0xFFFFE4E4);
      badgeText = ThebesColors.error;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F1A3D),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: ThebesColors.sky,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        grade.courseCode,
                        style: GoogleFonts.cairo(
                          color: ThebesColors.navy,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${grade.creditHours} ${isArabic ? "ساعات معتمدة" : "Credit Hours"}',
                      style: GoogleFonts.cairo(
                        color: ThebesColors.slate,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  grade.getLocalizedCourse(isArabic),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : ThebesColors.navy,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '${isArabic ? "الدرجة الكلية:" : "Score:"} ${grade.totalScore.toInt()}/100 • ${grade.points} ${isArabic ? "نقاط" : "pts"}',
                  style: GoogleFonts.cairo(
                    fontSize: 11.5,
                    color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                grade.gradeLetter,
                style: GoogleFonts.cairo(
                  color: badgeText,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatorBanner(
    BuildContext context,
    LocaleProvider locale,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkSurface : ThebesColors.sky,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ThebesColors.cobalt.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ThebesColors.cobalt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'مخطط ومحاكي المعدل التراكمي' : 'GPA Simulator & Planner',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: isDark ? Colors.white : ThebesColors.navy,
                  ),
                ),
                Text(
                  isArabic
                      ? 'احسب تقديراتك المتوقعة للفصول القادمة'
                      : 'Simulate your expected GPA for upcoming terms',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showGpaCalculator(context, locale, student.gpa, student.completedHours),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThebesColors.cobalt,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              isArabic ? 'تجربة' : 'Simulate',
              style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showGpaCalculator(
    BuildContext context,
    LocaleProvider locale,
    double currentGpa,
    int completedHours,
  ) {
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.read<StudentController>();
    final courses = controller.grades;

    final gradePointsMap = {
      'A+': 4.0,
      'A': 3.7,
      'B+': 3.3,
      'B': 3.0,
      'C+': 2.7,
      'C': 2.4,
      'D+': 2.2,
      'D': 2.0,
      'F': 0.0,
    };
    final gradeOptions = gradePointsMap.keys.toList();

    final expectedLetters = <String, String>{};
    for (final c in courses) {
      expectedLetters[c.courseCode] = 'A';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          int termHours = 0;
          double termQualityPoints = 0.0;
          for (final c in courses) {
            final letter = expectedLetters[c.courseCode] ?? 'A';
            final pts = gradePointsMap[letter] ?? 3.7;
            termHours += c.creditHours;
            termQualityPoints += pts * c.creditHours;
          }

          final priorQualityPoints = currentGpa * completedHours;
          final totalHours = completedHours + termHours;
          final simulatedGpa = totalHours > 0
              ? (priorQualityPoints + termQualityPoints) / totalHours
              : currentGpa;
          final delta = simulatedGpa - currentGpa;
          final isPositive = delta >= 0;

          return Container(
            height: MediaQuery.of(ctx).size.height * 0.75,
            decoration: BoxDecoration(
              color: isDark ? ThebesColors.darkCard : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  isArabic ? 'محاكي ومخطط المعدل التراكمي' : 'GPA Simulator & Planner',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : ThebesColors.navy,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: ThebesColors.primaryHeaderGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'المعدل الحالي' : 'Current',
                            style: GoogleFonts.cairo(fontSize: 11, color: Colors.white70),
                          ),
                          Text(
                            currentGpa.toStringAsFixed(2),
                            style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white70, size: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isArabic ? 'المعدل المتوقع' : 'Simulated',
                            style: GoogleFonts.cairo(fontSize: 11, color: ThebesColors.orangeLight),
                          ),
                          Row(
                            children: [
                              Text(
                                simulatedGpa.toStringAsFixed(2),
                                style: GoogleFonts.cairo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isPositive ? ThebesColors.mint : ThebesColors.error,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${isPositive ? '+' : ''}${delta.toStringAsFixed(2)}',
                                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final c = courses[index];
                      final currentSelected = expectedLetters[c.courseCode] ?? 'A';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? ThebesColors.darkSurface : ThebesColors.pageBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.getLocalizedCourse(isArabic),
                                style: GoogleFonts.cairo(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : ThebesColors.navy,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: currentSelected,
                                dropdownColor: isDark ? ThebesColors.darkCard : Colors.white,
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: ThebesColors.cobalt,
                                ),
                                items: gradeOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                                onChanged: (newVal) {
                                  if (newVal != null) {
                                    setModalState(() => expectedLetters[c.courseCode] = newVal);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThebesColors.cobalt,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isArabic ? 'إغلاق' : 'Close',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
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
