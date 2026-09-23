import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/features/student/domain/entities/academic_entities.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'exam_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final int initialTab;

  const ScheduleScreen({super.key, this.initialTab = 0});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LectureType? _selectedTypeFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.watch<StudentController>();
    final isTabletOrDesktop = context.isTablet || context.isDesktop;

    final days = [
      {'ar': 'السبت', 'en': 'Sat'},
      {'ar': 'الأحد', 'en': 'Sun'},
      {'ar': 'الإثنين', 'en': 'Mon'},
      {'ar': 'الثلاثاء', 'en': 'Tue'},
      {'ar': 'الأربعاء', 'en': 'Wed'},
      {'ar': 'الخميس', 'en': 'Thu'},
    ];

    var dayClasses = controller.dayClasses;
    if (_selectedTypeFilter != null) {
      dayClasses = dayClasses.where((c) => c.type == _selectedTypeFilter).toList();
    }

    return Scaffold(
      backgroundColor: isDark ? ThebesColors.darkBackground : const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          locale.tr('nav_schedule'),
          style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: ThebesColors.navy,
              unselectedLabelColor: Colors.white.withAlpha(200),
              labelStyle: GoogleFonts.cairo(fontSize: 12.5, fontWeight: FontWeight.w700),
              unselectedLabelStyle: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w500),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  icon: const Icon(Icons.schedule_rounded, size: 18),
                  text: locale.tr('weekly_schedule'),
                ),
                Tab(
                  icon: const Icon(Icons.event_note_rounded, size: 18),
                  text: locale.tr('exam_schedule'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1140),
          child: TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: WEEKLY TIMETABLE
              Column(
                children: [
                  // Horizontal Day Selector Pills
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: isDark ? ThebesColors.darkSurface : Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final isSelected = controller.selectedDayIndex == index;
                        final dayName = isArabic ? days[index]['ar']! : days[index]['en']!;

                        return GestureDetector(
                          onTap: () => controller.setSelectedDayIndex(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? ThebesColors.navy
                                  : (isDark ? ThebesColors.darkCard : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: ThebesColors.navy.withAlpha(40),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              dayName,
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                color: isSelected
                                  ? Colors.white
                                  : (isDark ? ThebesColors.slateLight : ThebesColors.slate),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Filter Chips
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: locale.tr('all'),
                          isSelected: _selectedTypeFilter == null,
                          onTap: () => setState(() => _selectedTypeFilter = null),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: locale.tr('lectures_only'),
                          isSelected: _selectedTypeFilter == LectureType.lecture,
                          onTap: () => setState(() => _selectedTypeFilter = LectureType.lecture),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: locale.tr('sections_only'),
                          isSelected: _selectedTypeFilter == LectureType.lab || _selectedTypeFilter == LectureType.section,
                          onTap: () => setState(() => _selectedTypeFilter = LectureType.lab),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  // Responsive Classes Grid or List
                  Expanded(
                    child: dayClasses.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.event_busy_rounded, size: 52, color: Colors.grey.shade400),
                                const SizedBox(height: 12),
                                Text(
                                  locale.tr('no_classes_today'),
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white60 : ThebesColors.slate,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : isTabletOrDesktop
                            ? GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 2.2,
                                ),
                                itemCount: dayClasses.length,
                                itemBuilder: (context, index) {
                                  return _buildLectureCard(dayClasses[index], isArabic, isDark);
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: dayClasses.length,
                                itemBuilder: (context, index) {
                                  return _buildLectureCard(dayClasses[index], isArabic, isDark);
                                },
                              ),
                  ),
                ],
              ),

              // TAB 2: EXAM TIMETABLE
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Modern Student Seat Number Hero Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: ThebesColors.primaryHeaderGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: ThebesColors.navy.withAlpha(50),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(20),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.badge_rounded, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic ? 'رقم جلوس الطالب' : 'Student Seat Number',
                                  style: GoogleFonts.cairo(
                                    color: const Color(0xFFE2E8F0),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  controller.student.seatNumber,
                                  style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: ThebesColors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isArabic ? 'امتحانات نهائية' : 'Finals',
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Link to Full Exam Schedule
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ExamScheduleScreen()),
                      ),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isDark ? ThebesColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ThebesColors.cobaltPale,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.assignment_outlined, color: ThebesColors.cobalt, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                isArabic ? 'جدول الامتحانات الرسمية ومواعيد القاعات' : 'Official Exam Dates & Halls',
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : ThebesColors.navy,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: ThebesColors.slate),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Exams List
                    if (isTabletOrDesktop)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.3,
                        ),
                        itemCount: controller.exams.length,
                        itemBuilder: (context, index) {
                          return _buildExamCard(controller.exams[index], isArabic, isDark);
                        },
                      )
                    else
                      ...controller.exams.map((exam) => _buildExamCard(exam, isArabic, isDark)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? ThebesColors.cobalt
              : (isDark ? ThebesColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? ThebesColors.cobalt
                : (isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : ThebesColors.slateDark),
          ),
        ),
      ),
    );
  }

  Widget _buildLectureCard(CourseScheduleEntity item, bool isArabic, bool isDark) {
    Color typeColor;
    String typeTitle;

    switch (item.type) {
      case LectureType.lecture:
        typeColor = ThebesColors.cobalt;
        typeTitle = isArabic ? 'محاضرة' : 'Lecture';
        break;
      case LectureType.lab:
        typeColor = ThebesColors.mint;
        typeTitle = isArabic ? 'معمل' : 'Lab';
        break;
      case LectureType.section:
        typeColor = ThebesColors.orange;
        typeTitle = isArabic ? 'سكشن' : 'Section';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: item.isUpcoming
              ? ThebesColors.cobalt
              : (isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder),
          width: item.isUpcoming ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F1A3D),
            blurRadius: 12,
            offset: Offset(0, 4),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: typeColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$typeTitle • ${item.code}',
                  style: GoogleFonts.cairo(
                    color: typeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 14, color: ThebesColors.slate),
                  const SizedBox(width: 4),
                  Text(
                    '${item.startTime} - ${item.endTime}',
                    style: GoogleFonts.cairo(
                      color: isDark ? Colors.white70 : ThebesColors.slateDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.getLocalizedTitle(isArabic),
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : ThebesColors.navy,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 15, color: ThebesColors.slate),
                  const SizedBox(width: 4),
                  Text(
                    item.getLocalizedInstructor(isArabic),
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ThebesColors.sky,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.getLocalizedHall(isArabic),
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ThebesColors.navy,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(ExamEntity exam, bool isArabic, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ThebesColors.orangePale,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  exam.courseCode,
                  style: GoogleFonts.cairo(
                    color: ThebesColors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                exam.date,
                style: GoogleFonts.cairo(
                  color: ThebesColors.slate,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            exam.getLocalizedCourse(isArabic),
            style: GoogleFonts.cairo(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : ThebesColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exam.time,
                style: GoogleFonts.cairo(fontSize: 12, color: ThebesColors.slate),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: ThebesColors.sky,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${isArabic ? "لجنة:" : "Hall:"} ${exam.hall}',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ThebesColors.navy,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
