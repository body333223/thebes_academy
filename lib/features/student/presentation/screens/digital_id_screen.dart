import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';

class DigitalIdScreen extends StatefulWidget {
  const DigitalIdScreen({super.key});

  @override
  State<DigitalIdScreen> createState() => _DigitalIdScreenState();
}

class _DigitalIdScreenState extends State<DigitalIdScreen> {
  late Timer _clockTimer;
  String _currentTime = '';
  bool _showQrEnlarged = false;

  @override
  void initState() {
    super.initState();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) _updateClock();
    });
  }

  void _updateClock() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('hh:mm:ss a').format(now);
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final student = context.watch<StudentController>().student;

    final qrPayload = 'THEBES://GATE_ACCESS/${student.academicId}/TIME_${DateTime.now().minute}';

    return Scaffold(
      backgroundColor: isDark ? ThebesColors.darkBackground : const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          locale.tr('id_card_title'),
          style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showQrEnlarged ? Icons.credit_card_rounded : Icons.qr_code_2_rounded,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _showQrEnlarged = !_showQrEnlarged),
            tooltip: 'Toggle QR View',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: context.responsiveScreenPadding,
            child: Column(
              children: [
                // 1. Live Verification Status Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: ThebesColors.mint.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: ThebesColors.mint.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: ThebesColors.mint,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${locale.tr('live_verification')} • $_currentTime',
                          style: GoogleFonts.cairo(
                            color: ThebesColors.mint,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      const Icon(Icons.verified_rounded, color: ThebesColors.mint, size: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 2. THE OFFICIAL SMART CAMPUS CARD (Apple Wallet / Titanium Pass Style)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: ThebesColors.primaryHeaderGradient,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withAlpha(30), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: ThebesColors.navy.withAlpha(60),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background Watermark Emblem
                      Positioned(
                        right: -30,
                        bottom: -30,
                        child: Opacity(
                          opacity: 0.04,
                          child: const Icon(
                            Icons.school,
                            size: 240,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Header: Squircle Academy Crest & Session
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(20),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withAlpha(30)),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.school_rounded, color: Colors.white, size: 24),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isArabic ? 'أكاديمية طـيبة المتكاملة' : 'THEBES ACADEMY',
                                        style: GoogleFonts.cairo(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      Text(
                                        student.getLocalizedInstitute(isArabic),
                                        style: GoogleFonts.cairo(
                                          color: const Color(0xFFCBD5E1),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(18),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '2026 / 2027',
                                    style: GoogleFonts.cairo(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            Divider(color: Colors.white.withAlpha(25), height: 1),
                            const SizedBox(height: 16),

                            // Main Card Content (Photo + Student Details OR Enlarged QR)
                            if (!_showQrEnlarged)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      // Smart Contactless Chip
                                      Container(
                                        width: 40,
                                        height: 28,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFCBD5E1), Color(0xFF94A3B8)],
                                          ),
                                          border: Border.all(color: Colors.white.withAlpha(60)),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.contactless_rounded, size: 18, color: ThebesColors.navy),
                                        ),
                                      ),
                                      // Student Photo Box
                                      Container(
                                        width: 84,
                                        height: 94,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: Colors.white.withAlpha(40), width: 1.5),
                                          color: Colors.white.withAlpha(15),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.person_rounded, size: 52, color: Colors.white70),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: ThebesColors.mint.withAlpha(30),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isArabic ? 'طالب مقيد' : 'Enrolled',
                                          style: GoogleFonts.cairo(
                                            color: ThebesColors.mint,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.getLocalizedName(isArabic),
                                          style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildIdField(locale.tr('academic_id'), student.academicId, highlight: true),
                                        _buildIdField(locale.tr('major'), student.getLocalizedDepartment(isArabic)),
                                        _buildIdField(locale.tr('academic_year'), isArabic ? 'الفرقة الثالثة' : '3rd Year'),
                                        _buildIdField(locale.tr('seat_no'), student.seatNumber),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: QrImageView(
                                        data: qrPayload,
                                        version: QrVersions.auto,
                                        size: 170.0,
                                        eyeStyle: const QrEyeStyle(
                                          eyeShape: QrEyeShape.square,
                                          color: ThebesColors.navy,
                                        ),
                                        dataModuleStyle: const QrDataModuleStyle(
                                          dataModuleShape: QrDataModuleShape.square,
                                          color: ThebesColors.navy,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      student.getLocalizedName(isArabic),
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 16),
                            Divider(color: Colors.white.withAlpha(25), height: 1),
                            const SizedBox(height: 14),

                            // Card Footer: Validity & Mini QR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      locale.tr('valid_through'),
                                      style: GoogleFonts.cairo(
                                        color: Colors.white54,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '31 / 08 / 2027',
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _showQrEnlarged = !_showQrEnlarged),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: QrImageView(
                                      data: qrPayload,
                                      version: QrVersions.auto,
                                      size: 40.0,
                                      eyeStyle: const QrEyeStyle(
                                        eyeShape: QrEyeShape.square,
                                        color: ThebesColors.navy,
                                      ),
                                      dataModuleStyle: const QrDataModuleStyle(
                                        dataModuleShape: QrDataModuleShape.square,
                                        color: ThebesColors.navy,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showExportDialog(context, student, isArabic, isDark),
                        icon: const Icon(Icons.share_rounded, size: 18),
                        label: Text(
                          isArabic ? 'تصدير الكارنيه' : 'Export ID',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThebesColors.cobalt,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showOfflinePassDialog(context, student, isArabic, isDark),
                        icon: const Icon(Icons.qr_code_rounded, size: 18, color: ThebesColors.navy),
                        label: Text(
                          isArabic ? 'تصريح البوابات' : 'Gate Pass',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isDark ? Colors.white : ThebesColors.navy,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Hint banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? ThebesColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: ThebesColors.cobalt, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          locale.tr('scan_qr_hint'),
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : ThebesColors.slate,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdField(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: highlight ? ThebesColors.orangeLight : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, dynamic student, bool isArabic, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? ThebesColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.verified_rounded, color: ThebesColors.cobalt, size: 22),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'بطاقة الطالب الرقمية' : 'Digital ID Card',
              style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          isArabic
              ? 'تم التحقق من بياناتك الأكاديمية بنجاح. يمكنك استخدام هذا الكارنيه الرقمي عبر البوابات الإلكترونية والمعامل.'
              : 'Academic credentials verified. Use this digital pass for automated campus turnstiles and library access.',
          style: GoogleFonts.cairo(fontSize: 12.5, color: isDark ? Colors.white70 : ThebesColors.slate, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'تم' : 'Done', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: ThebesColors.cobalt)),
          ),
        ],
      ),
    );
  }

  void _showOfflinePassDialog(BuildContext context, dynamic student, bool isArabic, bool isDark) {
    final qrPayload = 'THEBES://OFFLINE_GATE/${student.academicId}/PASS';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? ThebesColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            isArabic ? 'تصريح الدخول السريع' : 'Fast Campus Gate Pass',
            style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: qrPayload,
                version: QrVersions.auto,
                size: 160.0,
                eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: ThebesColors.navy),
                dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: ThebesColors.navy),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isArabic ? 'صالح للمسح في بوابات المعاهد حتى في وضع عدم الاتصال' : 'Valid for automated turnstiles even offline',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(fontSize: 11.5, color: isDark ? Colors.white70 : ThebesColors.slate),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isArabic ? 'إغلاق' : 'Close', style: GoogleFonts.cairo(fontWeight: FontWeight.w700, color: ThebesColors.cobalt)),
            ),
          ),
        ],
      ),
    );
  }
}
