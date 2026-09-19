import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/thebes_colors.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/responsive/responsive_helper.dart';
import '../../core/widgets/user_avatar_widget.dart';
import '../../features/student/domain/entities/student_entity.dart';
import '../../features/student/presentation/controllers/student_controller.dart';

class FacultyDashboardScreen extends StatelessWidget {
  const FacultyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.watch<StudentController>();
    final isTabletOrDesktop = context.isTablet || context.isDesktop;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.tr('faculty_dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: ThebesColors.gold),
            onPressed: () {
              controller.switchRole(UserRole.student);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? 'تم التبديل إلى بوابة الطالب' : 'Switched to Student Portal'),
                  backgroundColor: ThebesColors.primary,
                ),
              );
            },
            tooltip: 'Switch to Student View',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1140),
          child: SingleChildScrollView(
            padding: context.responsiveScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Faculty Hero Profile
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: ThebesColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ThebesColors.gold, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      UserAvatarWidget(
                        size: context.responsiveValue(mobile: 56.0, tablet: 68.0),
                        initials: 'د.ع',
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'أ.د. عادل سليمان عبد الرحيم' : 'Prof. Dr. Adel Soliman',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isArabic
                                  ? 'أستاذ علوم الحاسب • عميد المعهد العالي لتكنولوجيا الإدارة'
                                  : 'Professor of CS • Dean of Management & IT',
                              style: const TextStyle(
                                color: ThebesColors.gold,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Live Attendance Session Controller
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? ThebesColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: controller.isAttendanceActive
                          ? ThebesColors.success
                          : (isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder),
                      width: controller.isAttendanceActive ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.qr_code_scanner_rounded,
                                color: controller.isAttendanceActive ? ThebesColors.success : ThebesColors.gold,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isArabic ? 'تسجيل الحضور التفاعلي للقاعة' : 'Live Hall QR Attendance',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : ThebesColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: controller.isAttendanceActive
                                  ? ThebesColors.opacity(ThebesColors.success, 0.12)
                                  : Colors.grey.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              controller.isAttendanceActive
                                  ? (isArabic ? 'الجلسة نشطة الآن' : 'Active Session')
                                  : (isArabic ? 'الجلسة مغلقة' : 'Closed'),
                              style: TextStyle(
                                color: controller.isAttendanceActive ? ThebesColors.success : Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (controller.isAttendanceActive) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: ThebesColors.gold),
                          ),
                          child: QrImageView(
                            data: 'THEBES://SESSION_ATTENDANCE/CS301/${DateTime.now().minute}',
                            version: QrVersions.auto,
                            size: 150.0,
                            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: ThebesColors.primaryDark),
                            dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: ThebesColors.primaryDark),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${isArabic ? "تم رصد حضور:" : "Live Attendees:"} ${controller.presentStudentsCount} ${locale.tr("students_enrolled")}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ThebesColors.success,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => controller.toggleAttendanceSession(),
                          icon: Icon(controller.isAttendanceActive ? Icons.stop_circle_outlined : Icons.play_circle_outline),
                          label: Text(
                            controller.isAttendanceActive
                                ? (isArabic ? 'إغلاق جلسة الحضور' : 'End Attendance Session')
                                : (isArabic ? 'بدء جلسة الحضور بالـ QR للمحاضرة' : 'Start QR Attendance Session'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isAttendanceActive ? ThebesColors.error : ThebesColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Teaching Courses List
                Text(
                  locale.tr('my_courses'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : ThebesColors.primaryDark,
                  ),
                ),

                const SizedBox(height: 12),

                if (isTabletOrDesktop)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.2,
                    children: [
                      _buildCourseManagementCard(
                        context,
                        code: 'CS 301',
                        title: isArabic ? 'تطوير تطبيقات الهواتف الذكية (Flutter)' : 'Mobile Application Development',
                        students: 118,
                        isDark: isDark,
                        isArabic: isArabic,
                      ),
                      _buildCourseManagementCard(
                        context,
                        code: 'CS 304',
                        title: isArabic ? 'الذكاء الاصطناعي وتعلم الآلة' : 'Artificial Intelligence & ML',
                        students: 96,
                        isDark: isDark,
                        isArabic: isArabic,
                      ),
                      _buildCourseManagementCard(
                        context,
                        code: 'IS 302',
                        title: isArabic ? 'هندسة البرمجيات والمنظومات' : 'Software Engineering',
                        students: 134,
                        isDark: isDark,
                        isArabic: isArabic,
                      ),
                    ],
                  )
                else ...[
                  _buildCourseManagementCard(
                    context,
                    code: 'CS 301',
                    title: isArabic ? 'تطوير تطبيقات الهواتف الذكية (Flutter)' : 'Mobile Application Development',
                    students: 118,
                    isDark: isDark,
                    isArabic: isArabic,
                  ),
                  _buildCourseManagementCard(
                    context,
                    code: 'CS 304',
                    title: isArabic ? 'الذكاء الاصطناعي وتعلم الآلة' : 'Artificial Intelligence & ML',
                    students: 96,
                    isDark: isDark,
                    isArabic: isArabic,
                  ),
                  _buildCourseManagementCard(
                    context,
                    code: 'IS 302',
                    title: isArabic ? 'هندسة البرمجيات والمنظومات' : 'Software Engineering',
                    students: 134,
                    isDark: isDark,
                    isArabic: isArabic,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseManagementCard(
    BuildContext context, {
    required String code,
    required String title,
    required int students,
    required bool isDark,
    required bool isArabic,
  }) {
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
              Text(
                code,
                style: const TextStyle(
                  color: ThebesColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                '$students ${isArabic ? "طالب" : "students"}',
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark ? Colors.grey : ThebesColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ThebesColors.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isArabic
                              ? 'تم فتح شيت رصد درجات أعمال السنة لـ $code'
                              : 'Grade entry sheet opened for $code',
                        ),
                        backgroundColor: ThebesColors.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_note_rounded, size: 16),
                  label: Text(
                    isArabic ? 'رصد الدرجات' : 'Enter Grades',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isArabic
                              ? 'تم نشر تنبيه للمقرر $code'
                              : 'Announcement broadcasted to $code',
                        ),
                        backgroundColor: ThebesColors.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.campaign_outlined, size: 16),
                  label: Text(
                    isArabic ? 'نشر إعلان' : 'Broadcast',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
