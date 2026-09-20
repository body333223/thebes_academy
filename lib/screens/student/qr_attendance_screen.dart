import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/responsive/responsive_helper.dart';
import '../../core/theme/thebes_colors.dart';
import '../../features/student/presentation/controllers/student_controller.dart';

class QrAttendanceScreen extends StatefulWidget {
  const QrAttendanceScreen({super.key});

  @override
  State<QrAttendanceScreen> createState() => _QrAttendanceScreenState();
}

class _QrAttendanceScreenState extends State<QrAttendanceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _laserPositionAnimation;
  final TextEditingController _manualCodeController = TextEditingController();
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserPositionAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleScan(String code) async {
    final controller = context.read<StudentController>();
    final success = await controller.scanDoctorQr(code);

    if (!mounted) return;

    if (success && controller.lastScannedRecord != null) {
      _showSuccessDialog(controller);
    } else if (controller.scanErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ThebesColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.scanErrorMessage!,
                  style: GoogleFonts.cairo(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showSuccessDialog(StudentController controller) {
    final isArabic = context.read<LocaleProvider>().isArabic;
    final record = controller.lastScannedRecord!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF0F1E33)
                : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: ThebesColors.gold.withAlpha(80), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: ThebesColors.primary.withAlpha(80),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              // Glowing check circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withAlpha(120),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),
              Text(
                isArabic ? 'تم تسجيل حضورك بنجاح! 🎉' : 'Attendance Verified! 🎉',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: ThebesColors.gold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic ? 'تم توثيق حضور المحاضرة بالمنظومة المركزية' : 'Attendance logged in central academy registry',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              // Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: ThebesColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ThebesColors.gold.withAlpha(50)),
                ),
                child: Column(
                  children: [
                    _buildModalRow(
                      Icons.menu_book_rounded,
                      isArabic ? 'المقرر:' : 'Course:',
                      record.getLocalizedCourseTitle(isArabic),
                    ),
                    const Divider(height: 20),
                    _buildModalRow(
                      Icons.person_pin_rounded,
                      isArabic ? 'المحاضر:' : 'Doctor:',
                      record.getLocalizedDoctorName(isArabic),
                    ),
                    const Divider(height: 20),
                    _buildModalRow(
                      Icons.location_on_rounded,
                      isArabic ? 'المكان:' : 'Hall:',
                      record.hall,
                    ),
                    const Divider(height: 20),
                    _buildModalRow(
                      Icons.access_time_filled_rounded,
                      isArabic ? 'التوقيت:' : 'Timestamp:',
                      DateFormat('hh:mm a - yyyy/MM/dd').format(record.timestamp),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThebesColors.gold,
                    foregroundColor: ThebesColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    isArabic ? 'تم وعودة للشاشة' : 'Done & Return',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ThebesColors.gold),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showManualEntrySheet() {
    final isArabic = context.read<LocaleProvider>().isArabic;
    _manualCodeController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF0F1E33)
                  : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: ThebesColors.gold.withAlpha(80), width: 1.5),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(80),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  isArabic ? 'إدخال كود الجلسة يدوياً' : 'Enter Lecture Session Code',
                  style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: ThebesColors.gold),
                ),
                const SizedBox(height: 6),
                Text(
                  isArabic
                      ? 'يمكنك كتابة الرمز المعروض على شاشة الدكتور في حال تعذر المسح'
                      : 'Type the code displayed on doctor\'s screen if scanner fails',
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _manualCodeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.qr_code_2_rounded, color: ThebesColors.gold),
                    hintText: 'e.g. THEBES-CS301-2026',
                    filled: true,
                    fillColor: ThebesColors.primary.withAlpha(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: ThebesColors.gold.withAlpha(80)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThebesColors.gold,
                      foregroundColor: ThebesColors.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      final code = _manualCodeController.text.trim();
                      if (code.isNotEmpty) {
                        Navigator.pop(ctx);
                        _handleScan(code);
                      }
                    },
                    child: Text(
                      isArabic ? 'تأكيد الحضور' : 'Confirm Attendance',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final controller = context.watch<StudentController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'تسجيل الحضور عبر QR' : 'Doctor QR Attendance',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded),
            color: _isFlashOn ? ThebesColors.gold : Colors.grey,
            tooltip: isArabic ? 'الكشاف' : 'Flashlight',
            onPressed: () => setState(() => _isFlashOn = !_isFlashOn),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Live Attendance Summary Banner
                _buildAttendanceStatsHero(context, controller, isArabic, isDark),
                const SizedBox(height: 24),

                // 2. Animated QR Scanner Viewfinder
                _buildScannerViewfinder(context, controller, isArabic, isDark),
                const SizedBox(height: 20),

                // 3. Quick Demo Simulation Chips for immediate testing
                _buildQuickDemoChips(isArabic),
                const SizedBox(height: 16),

                // 4. Manual entry button
                OutlinedButton.icon(
                  onPressed: _showManualEntrySheet,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ThebesColors.gold.withAlpha(120)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.keyboard_rounded, color: ThebesColors.gold),
                  label: Text(
                    isArabic ? 'إدخال كود المحاضرة يدوياً' : 'Enter Lecture Code Manually',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : ThebesColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // 5. Subject-by-Subject Attendance Tracker
                _buildCourseAttendanceSection(controller, isArabic, isDark),
                const SizedBox(height: 28),

                // 6. Attended Sessions Log
                _buildAttendanceHistorySection(controller, isArabic, isDark),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceStatsHero(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    final overallRate = controller.student.attendanceRate;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: ThebesColors.royalCardGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ThebesColors.gold.withAlpha(90), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: ThebesColors.primary.withAlpha(60),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular percent indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: overallRate / 100.0,
                  strokeWidth: 6,
                  backgroundColor: Colors.white.withAlpha(25),
                  valueColor: const AlwaysStoppedAnimation<Color>(ThebesColors.gold),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${overallRate.toStringAsFixed(1)}%',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ThebesColors.emerald.withAlpha(35),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ThebesColors.emerald.withAlpha(100)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded, color: ThebesColors.emerald, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            isArabic ? 'سجل منتظم' : 'Good Standing',
                            style: GoogleFonts.cairo(
                              color: ThebesColors.emerald,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isArabic ? 'معدل الحضور التراكمي' : 'Cumulative Attendance',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                Text(
                  isArabic
                      ? 'امسح الـ QR المعروض في قاعة المحاضرة لتثبيت حضورك فورياً'
                      : 'Scan doctor\'s in-class QR to log attendance instantly',
                  style: GoogleFonts.cairo(
                    color: Colors.white.withAlpha(180),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerViewfinder(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: const Color(0xFF07111E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: ThebesColors.gold.withAlpha(110), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ThebesColors.gold.withAlpha(35),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background grid simulation
          Opacity(
            opacity: 0.1,
            child: GridPaper(
              color: ThebesColors.gold,
              divisions: 2,
              subdivisions: 1,
            ),
          ),

          // Central target box
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(8),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // 4 Golden Corners
          Positioned(
            top: 55,
            left: (context.screenWidth > 640 ? 640 : context.screenWidth) / 2 - 110,
            child: _buildCornerBracket(isTop: true, isLeft: true),
          ),
          Positioned(
            top: 55,
            right: (context.screenWidth > 640 ? 640 : context.screenWidth) / 2 - 110,
            child: _buildCornerBracket(isTop: true, isLeft: false),
          ),
          Positioned(
            bottom: 55,
            left: (context.screenWidth > 640 ? 640 : context.screenWidth) / 2 - 110,
            child: _buildCornerBracket(isTop: false, isLeft: true),
          ),
          Positioned(
            bottom: 55,
            right: (context.screenWidth > 640 ? 640 : context.screenWidth) / 2 - 110,
            child: _buildCornerBracket(isTop: false, isLeft: false),
          ),

          // Laser Scanning Beam
          AnimatedBuilder(
            animation: _laserPositionAnimation,
            builder: (context, child) {
              return Positioned(
                top: 60 + (190 * _laserPositionAnimation.value),
                child: Container(
                  width: 210,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFFFFDF79),
                        ThebesColors.gold,
                        Color(0xFFFFDF79),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ThebesColors.gold.withAlpha(220),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Bottom Instruction overlay
          Positioned(
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(160),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withAlpha(20)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.isScanning)
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: ThebesColors.gold),
                    )
                  else
                    const Icon(Icons.center_focus_strong_rounded, color: ThebesColors.gold, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    controller.isScanning
                        ? (isArabic ? 'جاري التحقق من الجلسة...' : 'Verifying Session...')
                        : (isArabic ? 'وجه الكاميرا نحو كود الدكتور' : 'Aim at Doctor\'s Screen QR'),
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerBracket({required bool isTop, required bool isLeft}) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: ThebesColors.gold, width: 3.5) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: ThebesColors.gold, width: 3.5) : BorderSide.none,
          left: isLeft ? const BorderSide(color: ThebesColors.gold, width: 3.5) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: ThebesColors.gold, width: 3.5) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildQuickDemoChips(bool isArabic) {
    final demos = [
      {'title': isArabic ? '⚡ مسح ذكاء اصطناعي (CS301)' : '⚡ Scan AI (CS301)', 'code': 'THEBES-CS301-2026'},
      {'title': isArabic ? '⚡ مسح قواعد بيانات (CS302)' : '⚡ Scan DB (CS302)', 'code': 'THEBES-CS302-2026'},
      {'title': isArabic ? '⚡ مسح أمن شبكات (CS304)' : '⚡ Scan Sec (CS304)', 'code': 'THEBES-CS304-2026'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'تجربة سريعة لمحاكاة مسح كود الدكتور:' : 'Quick Demo to Simulate Doctor QR Scan:',
          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: demos.map((d) {
            return ActionChip(
              backgroundColor: ThebesColors.gold.withAlpha(25),
              side: BorderSide(color: ThebesColors.gold.withAlpha(80)),
              label: Text(
                d['title']!,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: ThebesColors.gold,
                ),
              ),
              onPressed: () => _handleScan(d['code']!),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCourseAttendanceSection(StudentController controller, bool isArabic, bool isDark) {
    final stats = controller.attendanceStats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isArabic ? 'نسبة الحضور لكل مادة' : 'Courses Attendance Rates',
                style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.w800),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${stats.length} ${isArabic ? 'مقررات' : 'Courses'}',
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...stats.map((stat) {
          final isWarning = stat.attendancePercentage < 85;
          final isDanger = stat.attendancePercentage < 75;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? ThebesColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDanger
                    ? ThebesColors.error.withAlpha(120)
                    : isWarning
                        ? ThebesColors.warning.withAlpha(120)
                        : (isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stat.getLocalizedTitle(isArabic),
                            style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          Text(
                            stat.courseCode,
                            style: GoogleFonts.cairo(color: ThebesColors.gold, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${stat.attendancePercentage.toStringAsFixed(1)}%',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: isDanger
                            ? ThebesColors.error
                            : isWarning
                                ? ThebesColors.warning
                                : ThebesColors.emerald,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: stat.attendancePercentage / 100.0,
                    minHeight: 7,
                    backgroundColor: isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(15),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDanger
                          ? ThebesColors.error
                          : isWarning
                              ? ThebesColors.warning
                              : ThebesColors.emerald,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic
                          ? 'حضور: ${stat.attendedLectures} من ${stat.totalLectures} محاضرة'
                          : 'Attended: ${stat.attendedLectures} / ${stat.totalLectures} lectures',
                      style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                    ),
                    if (stat.absentLectures > 0)
                      Text(
                        isArabic ? 'غياب: ${stat.absentLectures}' : 'Absences: ${stat.absentLectures}',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isWarning ? ThebesColors.warning : Colors.grey,
                        ),
                      ),
                  ],
                ),
                if (stat.isAtRisk || stat.isDeprived) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: stat.isDeprived
                          ? ThebesColors.error.withAlpha(25)
                          : ThebesColors.warning.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: stat.isDeprived ? ThebesColors.error : ThebesColors.warning,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          stat.isDeprived ? Icons.cancel_rounded : Icons.warning_amber_rounded,
                          size: 15,
                          color: stat.isDeprived ? ThebesColors.error : ThebesColors.warning,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            stat.getRiskBadgeText(isArabic),
                            style: GoogleFonts.cairo(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: stat.isDeprived ? ThebesColors.error : ThebesColors.warning,
                            ),
                          ),
                        ),
                        Text(
                          isArabic
                              ? 'متبقي: ${stat.remainingAbsencesAllowed} غياب'
                              : '${stat.remainingAbsencesAllowed} absences left',
                          style: GoogleFonts.cairo(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAttendanceHistorySection(StudentController controller, bool isArabic, bool isDark) {
    final history = controller.attendanceHistory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'سجل المحاضرات التي تم حضورها' : 'Attended Sessions History',
          style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        if (history.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                isArabic ? 'لا توجد جلسات حضور مسجلة بعد' : 'No recorded attendance sessions yet',
                style: GoogleFonts.cairo(color: Colors.grey),
              ),
            ),
          )
        else
          ...history.map((record) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? ThebesColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ThebesColors.emerald.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: ThebesColors.emerald.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.how_to_reg_rounded, color: ThebesColors.emerald, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.getLocalizedCourseTitle(isArabic),
                          style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 13.5),
                        ),
                        Text(
                          '${record.getLocalizedDoctorName(isArabic)} • ${record.hall}',
                          style: GoogleFonts.cairo(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('MM/dd hh:mm a').format(record.timestamp),
                    style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w600, color: ThebesColors.gold),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
