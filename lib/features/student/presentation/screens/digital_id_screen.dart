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
      appBar: AppBar(
        title: Text(locale.tr('id_card_title')),
        actions: [
          IconButton(
            icon: Icon(
              _showQrEnlarged ? Icons.credit_card_rounded : Icons.qr_code_scanner_rounded,
              color: ThebesColors.gold,
            ),
            onPressed: () => setState(() => _showQrEnlarged = !_showQrEnlarged),
            tooltip: 'Toggle QR View',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: context.responsiveScreenPadding,
            child: Column(
              children: [
                // Live Security Bar Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: ThebesColors.opacity(ThebesColors.success, 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ThebesColors.opacity(ThebesColors.success, 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: ThebesColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${locale.tr('live_verification')} • $_currentTime',
                          style: const TextStyle(
                            color: ThebesColors.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Icon(Icons.verified_user_rounded, color: ThebesColors.success, size: 18),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // THE OFFICIAL DIGITAL ID CARD
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0C2340), Color(0xFF16375E), Color(0xFF09182A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: ThebesColors.gold,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(90),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: ThebesColors.opacity(ThebesColors.gold, 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -40,
                        bottom: -40,
                        child: Opacity(
                          opacity: 0.05,
                          child: const Icon(
                            Icons.school,
                            size: 260,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Header: Academy Crest + Names
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withAlpha(25),
                                    border: Border.all(color: ThebesColors.gold, width: 1.5),
                                  ),
                                  child: const Icon(
                                    Icons.school_rounded,
                                    color: ThebesColors.gold,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isArabic ? 'أكاديمية طـيبة المتكاملة' : 'THEBES ACADEMY',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        student.getLocalizedInstitute(isArabic),
                                        style: TextStyle(
                                          color: ThebesColors.opacity(ThebesColors.gold, 0.95),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: ThebesColors.opacity(ThebesColors.gold, 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ThebesColors.opacity(ThebesColors.gold, 0.5),
                                    ),
                                  ),
                                  child: const Text(
                                    '2026/2027',
                                    style: TextStyle(
                                      color: ThebesColors.gold,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),
                            Divider(color: ThebesColors.opacity(ThebesColors.gold, 0.3), height: 1),
                            const SizedBox(height: 18),

                            // Main Body: Student Photo + Info Or Enlarged QR
                            if (!_showQrEnlarged)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      // Smart Campus Contactless Chip
                                      Container(
                                        width: 44,
                                        height: 32,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFE5C07B), Color(0xFFD4AF37), Color(0xFFB38F24)],
                                          ),
                                          border: Border.all(color: const Color(0xFF7A6014), width: 0.8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(50),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.nfc_rounded, size: 18, color: Color(0xFF0C2340)),
                                        ),
                                      ),
                                      Container(
                                        width: 86,
                                        height: 98,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: ThebesColors.gold, width: 2),
                                          gradient: ThebesColors.cardGradient,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(70),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.person_rounded,
                                            size: 54,
                                            color: ThebesColors.gold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(30),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isArabic ? 'طالب منتظم' : 'Regular',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(width: 16),

                                  // Student Academic Data
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.getLocalizedName(isArabic),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        _buildIdRow(
                                          locale.tr('academic_id'),
                                          student.academicId,
                                          highlight: true,
                                        ),
                                        _buildIdRow(
                                          locale.tr('major'),
                                          student.getLocalizedDepartment(isArabic),
                                        ),
                                        _buildIdRow(
                                          locale.tr('academic_year'),
                                          isArabic ? 'الفرقة الثالثة' : '3rd Year',
                                        ),
                                        _buildIdRow(
                                          locale.tr('seat_no'),
                                          student.seatNumber,
                                        ),
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
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: QrImageView(
                                        data: qrPayload,
                                        version: QrVersions.auto,
                                        size: 180.0,
                                        eyeStyle: const QrEyeStyle(
                                          eyeShape: QrEyeShape.square,
                                          color: ThebesColors.primaryDark,
                                        ),
                                        dataModuleStyle: const QrDataModuleStyle(
                                          dataModuleShape: QrDataModuleShape.square,
                                          color: ThebesColors.primaryDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      student.getLocalizedName(isArabic),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 18),
                            Divider(color: ThebesColors.opacity(ThebesColors.gold, 0.3), height: 1),
                            const SizedBox(height: 14),

                            // Card Footer: Dynamic Mini QR / Gate Pass Barcode
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      locale.tr('valid_through'),
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(150),
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      '31 / 08 / 2027',
                                      style: TextStyle(
                                        color: ThebesColors.gold,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),

                                GestureDetector(
                                  onTap: () => setState(() => _showQrEnlarged = !_showQrEnlarged),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: ThebesColors.gold, width: 1.5),
                                    ),
                                    child: QrImageView(
                                      data: qrPayload,
                                      version: QrVersions.auto,
                                      size: 44.0,
                                      eyeStyle: const QrEyeStyle(
                                        eyeShape: QrEyeShape.square,
                                        color: ThebesColors.primary,
                                      ),
                                      dataModuleStyle: const QrDataModuleStyle(
                                        dataModuleShape: QrDataModuleShape.square,
                                        color: ThebesColors.primary,
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

                // Digital ID Action Dock (Export Card & Offline Pass)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showExportDialog(context, student, isArabic, isDark),
                        icon: const Icon(Icons.share_rounded, size: 18),
                        label: Text(
                          isArabic ? 'تصدير الكارنيه' : 'Export ID',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThebesColors.gold,
                          foregroundColor: ThebesColors.primaryNavy,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showOfflinePassDialog(context, student, isArabic, isDark),
                        icon: const Icon(Icons.offline_bolt_rounded, size: 18, color: ThebesColors.gold),
                        label: Text(
                          isArabic ? 'تصريح البوابات' : 'Gate Pass',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isDark ? Colors.white : ThebesColors.primaryNavy,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: ThebesColors.gold, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Instructions Pill
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
                      const Icon(Icons.info_outline_rounded, color: ThebesColors.gold, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          locale.tr('scan_qr_hint'),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : ThebesColors.lightTextSecondary,
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

  void _showExportDialog(BuildContext context, dynamic student, bool isArabic, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0D1B2A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: ThebesColors.gold, width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.verified_rounded, color: ThebesColors.gold, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isArabic ? 'البطاقة الرقمية الرسمية المعتمدة' : 'Official Verified Digital ID',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : ThebesColors.primaryNavy,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stamp Card Preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: ThebesColors.royalCardGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ThebesColors.gold),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'أكاديمية طيبة المتكاملة للعلوم' : 'THEBES ACADEMY HIGHER INSTITUTES',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: ThebesColors.gold,
                        ),
                      ),
                      const Divider(color: Colors.white24, height: 12),
                      Text(
                        isArabic ? student.nameAr : student.nameEn,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'ID: ${student.academicId} • Seat: ${student.seatNumber}',
                        style: const TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        student.getLocalizedDepartment(isArabic),
                        style: GoogleFonts.cairo(fontSize: 11, color: Colors.white60),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  // Golden Official Stamp
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: ThebesColors.gold, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          color: ThebesColors.gold.withAlpha(40),
                        ),
                        child: Text(
                          isArabic ? 'معتمد رسمياً ★' : 'OFFICIAL PASS ★',
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: ThebesColors.gold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isArabic
                  ? 'هذه البطاقة معتمدة رسمياً ومزودة بختم الأكاديمية الأمني للعام الأكاديمي الحالي.'
                  : 'This verified credential is authenticated by Thebes Academy for the current academic year.',
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isArabic ? 'إغلاق' : 'Close',
              style: GoogleFonts.cairo(color: Colors.grey),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ThebesColors.primaryNavy,
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: ThebesColors.emerald),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isArabic
                              ? 'تم حفظ بطاقة الطالب المعتمدة بنجاح على جهازك!'
                              : 'Official ID card saved successfully to your device!',
                          style: GoogleFonts.cairo(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.download_done_rounded, size: 18),
            label: Text(
              isArabic ? 'حفظ الكارنيه' : 'Save ID',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThebesColors.gold,
              foregroundColor: ThebesColors.primaryNavy,
            ),
          ),
        ],
      ),
    );
  }

  void _showOfflinePassDialog(BuildContext context, dynamic student, bool isArabic, bool isDark) {
    final offlineToken = 'THEBES-OFFLINE-GATE-PASS-${student.academicId}-${DateTime.now().day}${DateTime.now().month}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: ThebesColors.gold, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, color: ThebesColors.emerald, size: 24),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'تصريح البوابات السريع (دون إنترنت)' : 'Offline Contactless Gate Pass',
                  style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'وجه هذا الرمز المباشر إلى قارئ بوابات الدخول بمقرات الأكاديمية (المعادي / سقارة)'
                  : 'Point this offline pass at Thebes Academy entrance turnstiles',
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // High-Contrast Gate QR Code
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ThebesColors.gold, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: ThebesColors.gold.withAlpha(50),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: offlineToken,
                version: QrVersions.auto,
                size: 190.0,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: ThebesColors.primary,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: ThebesColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ThebesColors.emerald.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ThebesColors.emerald),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, color: ThebesColors.emerald, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'تصريح ساري وصالح للمرور الفوري' : 'Pass Valid for Immediate Entry',
                    style: GoogleFonts.cairo(
                      color: ThebesColors.emerald,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThebesColors.gold,
                foregroundColor: ThebesColors.primaryNavy,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                isArabic ? 'تم' : 'Done',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white.withAlpha(150),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: highlight ? ThebesColors.gold : Colors.white,
                fontSize: 11.5,
                fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
