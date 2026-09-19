import 'package:flutter/material.dart';
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
    double expectedNewTermGpa = 3.8;
    int expectedNewHours = 18;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final totalHoursAfter = completedHours + expectedNewHours;
          final calculatedNewGpa = ((currentGpa * completedHours) + (expectedNewTermGpa * expectedNewHours)) / totalHoursAfter;

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  locale.isArabic ? 'حاسبة المعدل التراكمي المتوقع' : 'Expected GPA Simulator',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  locale.isArabic
                      ? 'اختر التقدير المتوقع للفصل الدراسي القادم (18 ساعة):'
                      : 'Select your expected GPA for the upcoming term (18 hrs):',
                  style: const TextStyle(fontSize: 13),
                ),
                Slider(
                  value: expectedNewTermGpa,
                  min: 2.0,
                  max: 4.0,
                  divisions: 20,
                  activeColor: ThebesColors.gold,
                  label: expectedNewTermGpa.toStringAsFixed(2),
                  onChanged: (val) {
                    setModalState(() {
                      expectedNewTermGpa = val;
                    });
                  },
                ),
                Center(
                  child: Text(
                    '${expectedNewTermGpa.toStringAsFixed(2)} / 4.00',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ThebesColors.gold),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThebesColors.opacity(ThebesColors.primary, 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ThebesColors.opacity(ThebesColors.primary, 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.isArabic ? 'المعدل التراكمي المتوقع الجديد:' : 'New Expected Cumulative GPA:',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        calculatedNewGpa.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: ThebesColors.success),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(locale.isArabic ? 'تم' : 'Done'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
