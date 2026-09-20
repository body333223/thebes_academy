import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/thebes_colors.dart';

class CampusGuideScreen extends StatefulWidget {
  const CampusGuideScreen({super.key});

  @override
  State<CampusGuideScreen> createState() => _CampusGuideScreenState();
}

class _CampusGuideScreenState extends State<CampusGuideScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'دليل مقرات الأكاديمية والمدرجات' : 'Thebes Academy Campus Guide',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThebesColors.gold,
          indicatorWeight: 3,
          labelColor: ThebesColors.gold,
          unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
          labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 14),
          tabs: [
            Tab(
              icon: const Icon(Icons.apartment_rounded, size: 20),
              text: isArabic ? 'مقر المعادي (الهندسة والإدارة)' : 'Maadi Campus',
            ),
            Tab(
              icon: const Icon(Icons.account_balance_rounded, size: 20),
              text: isArabic ? 'مقر سقارة (الحاسبات والمعلومات)' : 'Saqqara Campus',
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: TabBarView(
            controller: _tabController,
            children: [
              // 1. Maadi Campus
              _buildCampusView(
                context,
                isArabic: isArabic,
                isDark: isDark,
                campusNameAr: 'مقر أكاديمية طيبة - المعادي',
                campusNameEn: 'Thebes Academy - Maadi Campus',
                addressAr: 'كورنيش النيل، المعادي، القاهرة (بجوار مستشفى القوات المسلحة)',
                addressEn: 'Corniche El-Nile, Maadi, Cairo',
                institutesAr: '• المعهد العالي للهندسة بالمعادي\n• المعهد العالي لتكنولوجيا الإدارة والمعلومات بالمعادي',
                institutesEn: '• Thebes Higher Institute of Engineering\n• Thebes Higher Institute of Management & IT',
                halls: [
                  {'name': 'مدرج 402 (المدرج الرئيسي)', 'bldg': 'مبنى الهندسة - الدور الرابع', 'type': 'قاعة محاضرات كبرى'},
                  {'name': 'مدرج 302 ومدرج 204', 'bldg': 'مبنى الإدارة - الدور الثاني والثالث', 'type': 'مدرجات دراسية'},
                  {'name': 'صالات الرسم الهندسي (1 و 2)', 'bldg': 'مبنى الهندسة - الدور الأرضي', 'type': 'صالات تخصصية'},
                  {'name': 'معامل الحاسب الآلي (1 إلى 4)', 'bldg': 'مبنى النظم - الدور الثاني', 'type': 'معامل تقنية متقدمة'},
                  {'name': 'إدارة شؤون الطلاب والخزينة', 'bldg': 'المبنى الإداري - الدور الأول', 'type': 'خدمات طلابية ومالية'},
                ],
                contacts: [
                  {'title': 'شؤون الطلاب (المعادي)', 'phone': '02-25281234'},
                  {'title': 'الخزينة والماليات', 'phone': '02-25281235'},
                  {'title': 'الأمن والبوابات', 'phone': '02-25281236'},
                ],
              ),

              // 2. Saqqara Campus
              _buildCampusView(
                context,
                isArabic: isArabic,
                isDark: isDark,
                campusNameAr: 'مقر أكاديمية طيبة - سقارة / المريوطية',
                campusNameEn: 'Thebes Academy - Saqqara Campus',
                addressAr: 'طريق سقارة السياحي، المريوطية، الهرم، الجيزة',
                addressEn: 'Saqqara Tourist Road, Maryouteya, Giza',
                institutesAr: '• المعهد العالي لعلوم الحاسب ونظم المعلومات\n• المدينة الجامعية والملاعب الرياضية المركزية',
                institutesEn: '• Higher Institute of Computer Science & IS\n• Sports Complex & Campus Dorms',
                halls: [
                  {'name': 'قاعة د. فاروق الباز الكبرى', 'bldg': 'المبنى الرئيسي - القاعة المركزية', 'type': 'قاعة مؤتمرات ومحاضرات كبرى'},
                  {'name': 'معامل الذكاء الاصطناعي وهندسة البرمجيات', 'bldg': 'مبنى الحاسبات - الدور الثالث', 'type': 'معامل بحثية متطورة'},
                  {'name': 'المكتبة المركزية وقاعات الاطلاع', 'bldg': 'المبنى الثقافي - الدور الثاني', 'type': 'مكتبة أكاديمية رقمية'},
                  {'name': 'الملاعب الرياضية ورعاية الشباب', 'bldg': 'المجمع الرياضي المفتوح', 'type': 'أنشطة طلابية وملاعب'},
                  {'name': 'العيادة الطبية الجامعية', 'bldg': 'المركز الطبي - الدور الأرضي', 'type': 'رعاية صحية وطوارئ'},
                ],
                contacts: [
                  {'title': 'شؤون طلاب الحاسبات', 'phone': '02-33881200'},
                  {'title': 'العيادة الطبية والطوارئ', 'phone': '02-33881201'},
                  {'title': 'إدارة رعاية الطلاب والأنشطة', 'phone': '02-33881202'},
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampusView(
    BuildContext context, {
    required bool isArabic,
    required bool isDark,
    required String campusNameAr,
    required String campusNameEn,
    required String addressAr,
    required String addressEn,
    required String institutesAr,
    required String institutesEn,
    required List<Map<String, String>> halls,
    required List<Map<String, String>> contacts,
  }) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      children: [
        // Campus Identity Hero Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: ThebesColors.royalCardGradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: ThebesColors.gold.withAlpha(120), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: ThebesColors.primary.withAlpha(90),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ThebesColors.gold.withAlpha(35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_city_rounded, color: ThebesColors.gold, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isArabic ? campusNameAr : campusNameEn,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.place_rounded, color: ThebesColors.gold, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isArabic ? addressAr : addressEn,
                      style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 10),
              Text(
                isArabic ? institutesAr : institutesEn,
                style: GoogleFonts.cairo(color: ThebesColors.gold, fontSize: 12, height: 1.6, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Halls and Labs Directory
        Text(
          isArabic ? 'دليل المدرجات والمعامل والمباني' : 'Halls & Facilities Directory',
          style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: halls.length,
          separatorBuilder: (_, index) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final h = halls[i];
            return Container(
              padding: const EdgeInsets.all(14),
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
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: ThebesColors.gold.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.meeting_room_rounded, color: ThebesColors.gold, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h['name']!,
                          style: GoogleFonts.cairo(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : ThebesColors.primaryDark,
                          ),
                        ),
                        Text(
                          '${h['bldg']} • ${h['type']}',
                          style: GoogleFonts.cairo(fontSize: 11.5, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // Important Phone Contacts
        Text(
          isArabic ? 'أرقام التواصل الهامة بالمقر' : 'Important Contacts',
          style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: contacts.length,
          separatorBuilder: (_, index) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final c = contacts[i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? ThebesColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    c['title']!,
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isArabic ? 'تم نسخ الرقم: ${c['phone']}' : 'Copied: ${c['phone']}'),
                          backgroundColor: ThebesColors.primary,
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone_in_talk_rounded, color: ThebesColors.gold, size: 16),
                    label: Text(
                      c['phone']!,
                      style: GoogleFonts.spaceMono(
                        color: ThebesColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
