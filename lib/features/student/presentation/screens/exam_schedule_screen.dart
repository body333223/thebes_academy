import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';

class ExamScheduleScreen extends StatelessWidget {
  const ExamScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = context.watch<StudentController>();
    final student = controller.student;
    final exams = controller.exams;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'جدول الامتحانات وأرقام الجلوس' : 'Exams & Seating Schedule',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: ThebesColors.gold),
            tooltip: isArabic ? 'تعليمات الامتحانات' : 'Exam Rules',
            onPressed: () => _showExamRegulationsDialog(context, isArabic, isDark),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Seating & Committee Hero Card
                _buildSeatingHeroCard(context, student, exams.length, isArabic),
                const SizedBox(height: 20),

                // 2. Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'جدول اختبارات الفصل الدراسي' : 'Semester Exam Schedule',
                      style: GoogleFonts.cairo(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : ThebesColors.primaryDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: ThebesColors.gold.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ThebesColors.gold.withAlpha(90)),
                      ),
                      child: Text(
                        '${exams.length} ${isArabic ? "امتحانات" : "Exams"}',
                        style: GoogleFonts.cairo(
                          color: ThebesColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 3. Exam Schedule Cards
                if (exams.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        isArabic ? 'لا توجد امتحانات مجدولة حالياً' : 'No scheduled exams found',
                        style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exams.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 14),
                    itemBuilder: (context, i) {
                      final exam = exams[i];
                      return _buildExamCard(context, exam, i, isArabic, isDark);
                    },
                  ),

                const SizedBox(height: 28),

                // 4. Instructions & Regulations Banner
                _buildInstructionsBanner(context, isArabic, isDark),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeatingHeroCard(BuildContext context, dynamic student, int totalExams, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: ThebesColors.royalCardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ThebesColors.gold.withAlpha(120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ThebesColors.primary.withAlpha(90),
            blurRadius: 24,
            offset: const Offset(0, 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ThebesColors.gold.withAlpha(35),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ThebesColors.gold),
                ),
                child: Text(
                  isArabic ? 'بطاقة رقم الجلوس المعتمدة' : 'Official Seating Card',
                  style: GoogleFonts.cairo(
                    color: ThebesColors.gold,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '2026/2027',
                style: GoogleFonts.spaceMono(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'رقم الجلوس الأكاديمي:' : 'Academic Seat No:',
                      style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      student.seatNumber,
                      style: GoogleFonts.spaceMono(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(15),
                  shape: BoxShape.circle,
                  border: Border.all(color: ThebesColors.gold.withAlpha(100)),
                ),
                child: const Icon(Icons.event_seat_rounded, color: ThebesColors.gold, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.meeting_room_rounded, color: ThebesColors.gold, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    isArabic ? 'اللجنة: صالة 1 (مبنى الهندسة)' : 'Committee: Hall 1 (Eng)',
                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.assignment_turned_in_rounded, color: ThebesColors.emerald, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    isArabic ? 'الحالة: مسدد ومؤهل' : 'Status: Eligible',
                    style: GoogleFonts.cairo(color: ThebesColors.emerald, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, dynamic exam, int index, bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 10),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Code and Date badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ThebesColors.gold.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThebesColors.gold.withAlpha(80)),
                ),
                child: Text(
                  exam.courseCode,
                  style: GoogleFonts.spaceMono(
                    color: ThebesColors.gold,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 15, color: ThebesColors.gold),
                  const SizedBox(width: 5),
                  Text(
                    exam.date,
                    style: GoogleFonts.cairo(
                      color: ThebesColors.gold,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Course Title
          Text(
            exam.getLocalizedCourse(isArabic),
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : ThebesColors.primaryDark,
            ),
          ),
          const SizedBox(height: 10),

          // Details: Time and Hall
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                exam.time,
                style: GoogleFonts.cairo(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  exam.hall,
                  style: GoogleFonts.cairo(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action: Add to Calendar & Remind
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isArabic
                              ? 'تمت إضافة موعد امتحان ${exam.courseCode} إلى تقويم الهاتف وتفعيل التذكير'
                              : 'Exam added to calendar with reminders',
                        ),
                        backgroundColor: ThebesColors.primary,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ThebesColors.gold.withAlpha(120)),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.notification_add_rounded, size: 17, color: ThebesColors.gold),
                  label: Text(
                    isArabic ? 'إضافة للتقويم وتذكيري' : 'Add to Calendar',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      color: isDark ? Colors.white : ThebesColors.primaryDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsBanner(BuildContext context, bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13233A) : const Color(0xFFEBF3FB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ThebesColors.primary.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gavel_rounded, color: ThebesColors.gold, size: 20),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'ضوابط وتعليمات اللجان الامتحانية' : 'Exam Rules & Instructions',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : ThebesColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isArabic
                ? '• يرجى التواجد بمقر اللجنة قبل موعد الامتحان بـ 15 دقيقة على الأقل.\n• يشترط إبراز الكارنيه الجامعي (الورقي أو الرقمي عبر التطبيق) للدخول.\n• يمنع منعاً باتاً اصطحاب الهواتف المحمولة أو الساعات الذكية داخل اللجنة.'
                : '• Arrive 15 mins before exam starts.\n• Present Student ID at the door.\n• Mobile phones are strictly prohibited.',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _showExamRegulationsDialog(BuildContext context, bool isArabic, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F1E33) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            const Icon(Icons.rule_rounded, color: ThebesColors.gold),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'اللائحة الامتحانية' : 'Exam Regulations',
              style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 17),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic
                  ? 'وفقاً لقرارات مجلس إدارة أكاديمية طيبة التعليمية:\n1. الالتزام بالمقعد ورقم الجلوس المخصص في القاعة.\n2. التوقيع في كشف الحضور والانصراف لدى مراقب اللجنة.\n3. لن يسمح بدخول الامتحان بعد مرور 15 دقيقة من بدء الوقت.\n4. عدم مغادرة اللجنة إلا بعد مرور نصف الوقت الأصلي.'
                  : '1. Adhere to assigned seat.\n2. Sign attendance sheet.\n3. No entry after 15 mins.\n4. No departure before half-time.',
              style: GoogleFonts.cairo(fontSize: 13, height: 1.6),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThebesColors.gold,
              foregroundColor: ThebesColors.primaryDark,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'فهمت التعليمات' : 'Understood', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
