import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/thebes_colors.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/responsive/responsive_helper.dart';
import '../../features/student/domain/entities/academic_entities.dart';
import '../../features/student/presentation/controllers/student_controller.dart';

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
      appBar: AppBar(
        title: Text(locale.tr('nav_schedule')),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThebesColors.gold,
          indicatorWeight: 3,
          labelColor: ThebesColors.gold,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: const Icon(Icons.schedule_rounded, size: 20),
              text: locale.tr('weekly_schedule'),
            ),
            Tab(
              icon: const Icon(Icons.event_note_rounded, size: 20),
              text: locale.tr('exam_schedule'),
            ),
          ],
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
                  // Days Selector Horizontal List
                  Container(
                    height: 56,
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
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? ThebesColors.primary
                                  : (isDark ? ThebesColors.darkCard : Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? ThebesColors.gold
                                    : (isDark ? ThebesColors.darkCardBorder : Colors.transparent),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : ThebesColors.lightTextSecondary),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Filter Chips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                Icon(Icons.weekend_outlined, size: 54, color: Colors.grey.shade400),
                                const SizedBox(height: 12),
                                Text(
                                  locale.tr('no_classes_today'),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.white60 : ThebesColors.lightTextSecondary,
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
                                  childAspectRatio: 2.3,
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
                    // Seat Number Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: ThebesColors.goldGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ThebesColors.opacity(ThebesColors.gold, 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.pin_outlined, color: ThebesColors.primaryDark, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic ? 'رقم جلوس الطالب' : 'Student Seat Number',
                                  style: const TextStyle(
                                    color: ThebesColors.primaryDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  controller.student.seatNumber,
                                  style: const TextStyle(
                                    color: ThebesColors.primaryDark,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: ThebesColors.primaryDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isArabic ? 'امتحانات نهائية' : 'Finals',
                              style: const TextStyle(
                                color: ThebesColors.gold,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Responsive Exams Grid or Column
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? ThebesColors.gold
              : (isDark ? ThebesColors.darkCard : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? ThebesColors.primaryDark : (isDark ? Colors.white70 : Colors.black87),
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
        typeColor = ThebesColors.primaryLight;
        typeTitle = isArabic ? 'محاضرة' : 'Lecture';
        break;
      case LectureType.lab:
        typeColor = ThebesColors.cyanAccent;
        typeTitle = isArabic ? 'معمل تطبيقي' : 'Lab';
        break;
      case LectureType.section:
        typeColor = ThebesColors.warning;
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
              ? ThebesColors.gold
              : (isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder),
          width: item.isUpcoming ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ThebesColors.opacity(typeColor, 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThebesColors.opacity(typeColor, 0.5)),
                ),
                child: Text(
                  '$typeTitle • ${item.code}',
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 14, color: ThebesColors.gold),
                  const SizedBox(width: 4),
                  Text(
                    '${item.startTime} - ${item.endTime}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : ThebesColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.getLocalizedTitle(isArabic),
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ThebesColors.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_pin_circle_outlined, size: 16, color: isDark ? Colors.grey : Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.getLocalizedInstructor(isArabic),
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.grey : Colors.grey.shade700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.meeting_room_outlined, size: 16, color: ThebesColors.gold),
              const SizedBox(width: 4),
              Text(
                item.getLocalizedHall(isArabic),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ThebesColors.gold,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ThebesColors.opacity(ThebesColors.primary, 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  exam.courseCode,
                  style: const TextStyle(
                    color: ThebesColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                exam.date,
                style: const TextStyle(
                  color: ThebesColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            exam.getLocalizedCourse(isArabic),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ThebesColors.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exam.time,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : ThebesColors.lightTextSecondary,
                ),
              ),
              Text(
                exam.hall,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: ThebesColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
