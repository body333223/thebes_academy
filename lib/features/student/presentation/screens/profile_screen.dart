import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/widgets/user_avatar_widget.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'digital_id_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isNationalIdMasked = true;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = context.watch<StudentController>();
    final student = controller.student;

    final name = isArabic ? student.nameAr : student.nameEn;
    final major = isArabic ? student.majorAr : student.majorEn;
    final department = isArabic ? student.departmentAr : student.departmentEn;

    return Scaffold(
      backgroundColor: isDark ? ThebesColors.darkBackground : ThebesColors.pageBg,
      appBar: AppBar(
        title: Text(
          isArabic ? 'الملف الشخصي للطالب' : 'Student Profile',
          style: GoogleFonts.almarai(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: context.responsiveScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Hero Student Profile Card
                  _buildHeroProfileCard(context, student, name, major, department, isArabic, isDark),
                  const SizedBox(height: 18),

                  // 2. Academic Vitals & Standing Summary
                  _buildAcademicStandingCard(context, controller, student, isArabic, isDark),
                  const SizedBox(height: 18),

                  // 3. Official University Registration Details
                  _buildAcademicRegistrationCard(context, student, isArabic, isDark),
                  const SizedBox(height: 18),

                  // 4. Contact & Campus Information
                  _buildContactCard(context, student, isArabic, isDark),
                  const SizedBox(height: 24),

                  // 5. Digital ID Shortcut CTA
                  _buildDigitalIdCta(context, isArabic, isDark),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroProfileCard(
    BuildContext context,
    dynamic student,
    String name,
    String major,
    String department,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: ThebesColors.primaryHeaderGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ThebesColors.navy.withAlpha(50),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with online status ring
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ThebesColors.orange, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: ThebesColors.orange.withAlpha(50),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: UserAvatarWidget(
                      size: 68,
                      initials: isArabic ? 'ر.م' : 'R.A',
                    ),
                  ),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: ThebesColors.mint,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: GoogleFonts.almarai(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded, color: ThebesColors.orangeLight, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      major,
                      style: GoogleFonts.almarai(
                        color: Colors.white.withAlpha(210),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      department,
                      style: GoogleFonts.almarai(
                        color: ThebesColors.orangeLight,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeroStatChip(
                isArabic ? 'كود القيد' : 'Academic ID',
                student.academicId.toString(),
                Icons.badge_outlined,
              ),
              _buildHeroStatChip(
                isArabic ? 'المستوى' : 'Level',
                isArabic ? 'السنة الثالثة' : 'Year 3',
                Icons.school_outlined,
              ),
              _buildHeroStatChip(
                isArabic ? 'حالة القيد' : 'Status',
                isArabic ? 'منتظم' : 'Active',
                Icons.check_circle_outline_rounded,
                isBadge: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatChip(String label, String value, IconData icon, {bool isBadge = false}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.almarai(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 3),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: ThebesColors.mint.withAlpha(35),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ThebesColors.mint.withAlpha(120)),
            ),
            child: Text(
              value,
              style: GoogleFonts.almarai(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
              ),
            ),
          )
        else
          Text(
            value,
            style: GoogleFonts.almarai(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  Widget _buildAcademicStandingCard(
    BuildContext context,
    StudentController controller,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    final gpa = student.gpa;
    final hours = student.completedHours;
    final totalHours = student.totalRequiredHours;
    final progress = totalHours > 0 ? (hours / totalHours).clamp(0.0, 1.0) : 0.72;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04101828),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: ThebesColors.cobalt.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.assessment_rounded, color: ThebesColors.cobalt, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'الموقف الأكاديمي والتقدير العام' : 'Academic Standing & GPA',
                      style: GoogleFonts.almarai(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : ThebesColors.navy,
                      ),
                    ),
                    Text(
                      isArabic ? 'نظام الساعات المعتمدة (Credit Hours System)' : 'Credit Hours Scheme',
                      style: GoogleFonts.almarai(
                        fontSize: 11,
                        color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ThebesColors.orange.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ThebesColors.orange.withAlpha(80)),
                ),
                child: Text(
                  isArabic ? 'مرتبة الشرف' : "Dean's List",
                  style: GoogleFonts.almarai(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ThebesColors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // GPA and Hours Progress
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? ThebesColors.darkSurface : ThebesColors.sky,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'المعدل التراكمي (GPA)' : 'Cumulative GPA',
                        style: GoogleFonts.almarai(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            gpa.toStringAsFixed(2),
                            style: GoogleFonts.almarai(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : ThebesColors.navy,
                            ),
                          ),
                          Text(
                            ' / 4.00',
                            style: GoogleFonts.almarai(
                              fontSize: 11,
                              color: ThebesColors.slateLight,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        isArabic ? 'ممتاز مرتفع (A+)' : 'Excellent (A+)',
                        style: GoogleFonts.almarai(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: ThebesColors.mint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? ThebesColors.darkSurface : ThebesColors.sky,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'الساعات المجتازة' : 'Earned Credits',
                        style: GoogleFonts.almarai(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$hours',
                            style: GoogleFonts.almarai(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : ThebesColors.navy,
                            ),
                          ),
                          Text(
                            ' / $totalHours',
                            style: GoogleFonts.almarai(
                              fontSize: 11,
                              color: ThebesColors.slateLight,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        isArabic ? '${(progress * 100).toInt()}% من متطلبات التخرج' : '${(progress * 100).toInt()}% completed',
                        style: GoogleFonts.almarai(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: ThebesColors.cobalt,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark ? Colors.white10 : Colors.black12,
              valueColor: const AlwaysStoppedAnimation<Color>(ThebesColors.cobalt),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicRegistrationCard(
    BuildContext context,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    const rawNationalId = '30205120104812';
    final displayedNationalId = _isNationalIdMasked ? '302051••••••12' : rawNationalId;

    final records = [
      {
        'title': isArabic ? 'كود القيد الجامعي' : 'Academic Registration ID',
        'val': student.academicId.toString(),
        'copyable': true,
      },
      {
        'title': isArabic ? 'رقم الجلوس في الامتحانات' : 'Exam Seating Number',
        'val': student.seatNumber.toString(),
        'copyable': true,
      },
      {
        'title': isArabic ? 'الرقم القومي للطالب' : 'National ID',
        'val': displayedNationalId,
        'hasToggle': true,
      },
      {
        'title': isArabic ? 'المرشد الأكاديمي' : 'Academic Advisor',
        'val': isArabic ? 'د. حسام كمال الدين' : 'Dr. Hossam Kamal',
      },
      {
        'title': isArabic ? 'المعهد / الكلية' : 'Faculty / Institute',
        'val': isArabic ? 'المعهد العالي لعلوم الحاسب ونظم المعلومات' : 'Thebes Institute of Computer Science',
      },
      {
        'title': isArabic ? 'العام الأكاديمي والفصل' : 'Academic Year & Term',
        'val': isArabic ? '2025/2026 - الفصل الدراسي الثاني' : '2025/2026 - Spring Semester',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04101828),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: ThebesColors.navy.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school_rounded, color: ThebesColors.navy, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                isArabic ? 'بيانات القيد والامتحانات' : 'Registration & Exam Records',
                style: GoogleFonts.almarai(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : ThebesColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            separatorBuilder: (_, index) => const Divider(height: 18),
            itemBuilder: (context, i) {
              final r = records[i];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      r['title'] as String,
                      style: GoogleFonts.almarai(
                        fontSize: 12.5,
                        color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        r['val'] as String,
                        style: GoogleFonts.almarai(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : ThebesColors.navy,
                        ),
                      ),
                      if (r['copyable'] == true) ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: r['val'] as String));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isArabic ? 'تم النسخ إلى الحافظة' : 'Copied to clipboard'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Icon(Icons.copy_rounded, size: 15, color: ThebesColors.cobalt),
                        ),
                      ],
                      if (r['hasToggle'] == true) ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => setState(() => _isNationalIdMasked = !_isNationalIdMasked),
                          child: Icon(
                            _isNationalIdMasked ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 16,
                            color: ThebesColors.cobalt,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    final contacts = [
      {
        'title': isArabic ? 'البريد الإلكتروني الجامعي' : 'University Email',
        'val': student.email,
        'icon': Icons.mail_outline_rounded,
      },
      {
        'title': isArabic ? 'رقم الهاتف المسجل' : 'Registered Mobile',
        'val': student.phone,
        'icon': Icons.phone_outlined,
      },
      {
        'title': isArabic ? 'المقر الأكاديمي الرئيسي' : 'Main Campus',
        'val': isArabic ? 'أكاديمية طيبة - صقر قريش، المعادي' : 'Thebes Academy - Maadi Campus',
        'icon': Icons.location_on_outlined,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04101828),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: ThebesColors.orange.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.contact_mail_outlined, color: ThebesColors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                isArabic ? 'بيانات التواصل والمقر' : 'Contact & Campus Info',
                style: GoogleFonts.almarai(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : ThebesColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: contacts.length,
            separatorBuilder: (_, index) => const Divider(height: 18),
            itemBuilder: (context, i) {
              final c = contacts[i];
              return Row(
                children: [
                  Icon(c['icon'] as IconData, size: 18, color: ThebesColors.cobalt),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c['title'] as String,
                          style: GoogleFonts.almarai(
                            fontSize: 11,
                            color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                          ),
                        ),
                        Text(
                          c['val'] as String,
                          style: GoogleFonts.almarai(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : ThebesColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalIdCta(BuildContext context, bool isArabic, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: ThebesColors.orangeCtaGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThebesColors.orange.withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DigitalIdScreen()),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.badge_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    isArabic ? 'عرض كارنيه الكلية الرقمي والباركود' : 'Open Digital ID Pass & Barcode',
                    style: GoogleFonts.almarai(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
