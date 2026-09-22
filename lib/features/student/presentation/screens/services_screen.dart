import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/features/student/domain/entities/academic_entities.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';

class ServicesScreen extends StatefulWidget {
  final int initialTab;

  const ServicesScreen({super.key, this.initialTab = 0});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.tr('services_and_finance')),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThebesColors.gold,
          indicatorWeight: 3,
          labelColor: ThebesColors.gold,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: const Icon(Icons.account_balance_wallet_outlined, size: 20),
              text: locale.tr('tab_finance'),
            ),
            Tab(
              icon: const Icon(Icons.description_outlined, size: 20),
              text: locale.tr('tab_requests'),
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
              // 1. TUITION & FINANCE TAB
              ListView(
                padding: context.responsiveScreenPadding,
                children: [
                  // Financial Summary Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: ThebesColors.primaryGradient,
                      borderRadius: BorderRadius.circular(22),
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
                                  locale.tr('total_fees'),
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${controller.totalTuition.toInt()} ج.م',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThebesColors.opacity(ThebesColors.gold, 0.2),
                              ),
                              child: const Icon(Icons.payments_rounded, color: ThebesColors.gold, size: 30),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.white.withAlpha(40), height: 1),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.tr('paid_amount'),
                                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${controller.paidTuition.toInt()} ج.م',
                                  style: const TextStyle(
                                    color: ThebesColors.success,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.tr('remaining_amount'),
                                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${controller.remainingTuition.toInt()} ج.م',
                                  style: const TextStyle(
                                    color: ThebesColors.warning,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    locale.tr('installments'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : ThebesColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Responsive Installments Grid or Column
                  if (isTabletOrDesktop)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.1,
                      ),
                      itemCount: controller.installments.length,
                      itemBuilder: (context, index) {
                        return _buildInstallmentCard(
                          context,
                          controller.installments[index],
                          isArabic,
                          isDark,
                        );
                      },
                    )
                  else
                    ...controller.installments.map((inst) => _buildInstallmentCard(context, inst, isArabic, isDark)),
                ],
              ),

              // 2. E-SERVICES & STUDENT REQUESTS TAB
              ListView(
                padding: context.responsiveScreenPadding,
                children: [
                  // New Request Button Banner
                  GestureDetector(
                    onTap: () => _showNewRequestDialog(context, locale, controller),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: ThebesColors.goldGradient,
                        borderRadius: BorderRadius.circular(18),
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
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ThebesColors.primaryDark,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add_task_rounded, color: ThebesColors.gold, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.tr('request_service'),
                                  style: const TextStyle(
                                    color: ThebesColors.primaryDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  isArabic
                                      ? 'استخرج إفادة قيد، بيان درجات، أو إثبات تجنيد'
                                      : 'Request enrollment certificates, transcripts & IDs',
                                  style: TextStyle(
                                    color: ThebesColors.opacity(ThebesColors.primaryDark, 0.8),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, color: ThebesColors.primaryDark, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    isArabic ? 'سجل الطلبات السابقة' : 'Previous Requests History',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : ThebesColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Responsive Requests Grid or Column
                  if (isTabletOrDesktop)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: controller.requests.length,
                      itemBuilder: (context, index) {
                        return _buildRequestCard(
                          controller.requests[index],
                          isArabic,
                          isDark,
                          locale,
                        );
                      },
                    )
                  else
                    ...controller.requests.map((req) => _buildRequestCard(req, isArabic, isDark, locale)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstallmentCard(
    BuildContext context,
    PaymentInstallmentEntity inst,
    bool isArabic,
    bool isDark,
  ) {
    final isPaid = inst.status == PaymentStatus.paid;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPaid
              ? ThebesColors.opacity(ThebesColors.success, 0.4)
              : (isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder),
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
                '${inst.amount.toInt()} ج.م',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : ThebesColors.primaryDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid
                      ? ThebesColors.opacity(ThebesColors.success, 0.12)
                      : ThebesColors.opacity(ThebesColors.warning, 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isPaid ? ThebesColors.success : ThebesColors.warning,
                  ),
                ),
                child: Text(
                  isPaid ? (isArabic ? 'مسدد' : 'Paid') : (isArabic ? 'مستحق الدفع' : 'Due'),
                  style: TextStyle(
                    color: isPaid ? ThebesColors.success : ThebesColors.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            inst.getLocalizedTitle(isArabic),
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : ThebesColors.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: isDark ? Colors.grey : Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${isArabic ? "تاريخ الاستحقاق:" : "Due:"} ${inst.dueDate}',
                style: TextStyle(fontSize: 11.5, color: isDark ? Colors.grey : Colors.grey.shade600),
              ),
            ],
          ),
          if (isPaid && inst.receiptNumber != null) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _showOfficialReceiptDialog(context, inst, isArabic),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ThebesColors.gold.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ThebesColors.gold.withAlpha(90)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded, size: 18, color: ThebesColors.gold),
                        const SizedBox(width: 8),
                        Text(
                          '${isArabic ? "إيصال معتمد:" : "Receipt:"} ${inst.receiptNumber}',
                          style: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.bold, color: ThebesColors.gold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          isArabic ? 'عرض الإيصال' : 'View',
                          style: GoogleFonts.cairo(fontSize: 11.5, fontWeight: FontWeight.bold, color: ThebesColors.gold),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: ThebesColors.gold),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (!isPaid) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showPaymentCheckoutDialog(context, inst, isArabic),
                icon: const Icon(Icons.credit_card, size: 18),
                label: Text(
                  isArabic ? 'سداد فوري (فوري / فيزا / ميزة)' : 'Pay Now (Fawry / Visa)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThebesColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    ServiceRequestEntity req,
    bool isArabic,
    bool isDark,
    LocaleProvider locale,
  ) {
    Color statusColor;
    String statusTitle;

    switch (req.status) {
      case RequestStatus.completed:
        statusColor = ThebesColors.success;
        statusTitle = locale.tr('status_completed');
        break;
      case RequestStatus.underReview:
        statusColor = ThebesColors.warning;
        statusTitle = locale.tr('status_under_review');
        break;
      case RequestStatus.readyForPickup:
        statusColor = ThebesColors.info;
        statusTitle = isArabic ? 'جاهز للاستلام من الشؤون' : 'Ready for pickup';
        break;
    }

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
                '#${req.referenceNumber}',
                style: const TextStyle(
                  color: ThebesColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ThebesColors.opacity(statusColor, 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusTitle,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            req.getLocalizedTitle(isArabic),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ThebesColors.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${isArabic ? "تاريخ الطلب:" : "Date:"} ${req.requestDate}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey : ThebesColors.lightTextMuted,
                ),
              ),
              Text(
                '${req.fee.toInt()} ج.م',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ThebesColors.gold,
                ),
              ),
            ],
          ),
          if (req.status == RequestStatus.completed) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showOfficialCertificateDialog(context, req, isArabic),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: ThebesColors.gold.withAlpha(120)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.download_done_rounded, color: ThebesColors.gold, size: 16),
                label: Text(
                  isArabic ? 'عرض وتحميل الوثيقة المعتمدة' : 'View Certified Document',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12, color: ThebesColors.gold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showNewRequestDialog(BuildContext context, LocaleProvider locale, StudentController controller) {
    final services = [
      {'ar': 'طلب إفادة قيد رسمية موجهة لجهة محددة', 'en': 'Official Proof of Enrollment', 'fee': 150.0},
      {'ar': 'بيان تقديرات معتمد باللغة الإنجليزية', 'en': 'Official Transcript in English', 'fee': 250.0},
      {'ar': 'استخراج إثبات قيد للتجنيد (نموذج 2 جند)', 'en': 'Military Deferment Certificate (Form 2)', 'fee': 100.0},
      {'ar': 'طلب استخراج كارنيه طالب بدل فاقد', 'en': 'Replacement Student ID Card', 'fee': 120.0},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              locale.isArabic ? 'اختر الخدمة الإلكترونية المطلوبة' : 'Select Service to Request',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...services.map((srv) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    locale.isArabic ? srv['ar'] as String : srv['en'] as String,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${(srv['fee'] as double).toInt()} ج.م • ${locale.isArabic ? "رسوم استخراج" : "Service fee"}',
                    style: const TextStyle(color: ThebesColors.gold, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {
                    Navigator.pop(ctx);
                    controller.submitRequest(
                      srv['ar'] as String,
                      srv['en'] as String,
                      srv['fee'] as double,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(locale.tr('request_submitted_successfully')),
                        backgroundColor: ThebesColors.success,
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showPaymentCheckoutDialog(BuildContext context, PaymentInstallmentEntity inst, bool isArabic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    int selectedMethod = 0; // 0: Fawry, 1: Card, 2: InstaPay
    bool isProcessing = false;
    const fawryCode = '789 204 812';
    const instaPayAddress = 'thebes.tuition@instapay';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0D1B2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            border: Border.all(color: ThebesColors.gold.withAlpha(90), width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(90),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'بوابة السداد الإلكتروني المعتمدة' : 'Official E-Payment Gateway',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : ThebesColors.primaryDark,
                        ),
                      ),
                      Text(
                        isArabic ? 'خزينة أكاديمية طيبة التعليمية' : 'Thebes Academy Finance & Treasury',
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          color: ThebesColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ThebesColors.emerald.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ThebesColors.emerald.withAlpha(90)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_rounded, size: 12, color: ThebesColors.emerald),
                        const SizedBox(width: 4),
                        Text(
                          '256-bit SSL',
                          style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: ThebesColors.emerald,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Installment Info Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: ThebesColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ThebesColors.gold.withAlpha(110)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inst.getLocalizedTitle(isArabic),
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${isArabic ? "تاريخ الاستحقاق:" : "Due Date:"} ${inst.dueDate}',
                            style: GoogleFonts.cairo(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${inst.amount.toInt()} ج.م',
                      style: GoogleFonts.spaceMono(
                        color: ThebesColors.gold,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Payment Method Selector Tabs
              Row(
                children: [
                  _buildPaymentMethodTab(
                    title: 'فوري Fawry',
                    icon: Icons.point_of_sale_rounded,
                    isSelected: selectedMethod == 0,
                    onTap: () => setModalState(() => selectedMethod = 0),
                  ),
                  const SizedBox(width: 8),
                  _buildPaymentMethodTab(
                    title: isArabic ? 'بطاقة بنكية' : 'Bank Card',
                    icon: Icons.credit_card_rounded,
                    isSelected: selectedMethod == 1,
                    onTap: () => setModalState(() => selectedMethod = 1),
                  ),
                  const SizedBox(width: 8),
                  _buildPaymentMethodTab(
                    title: isArabic ? 'إنستاباي' : 'InstaPay',
                    icon: Icons.account_balance_wallet_rounded,
                    isSelected: selectedMethod == 2,
                    onTap: () => setModalState(() => selectedMethod = 2),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Method Details Content
              Expanded(
                child: SingleChildScrollView(
                  child: selectedMethod == 0
                      ? _buildFawryMethodView(context, isDark, isArabic, fawryCode)
                      : selectedMethod == 1
                          ? _buildCardMethodView(isDark, isArabic)
                          : _buildInstaPayMethodView(context, isDark, isArabic, instaPayAddress),
                ),
              ),

              const SizedBox(height: 12),

              // Confirm Button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          setModalState(() => isProcessing = true);
                          await Future.delayed(const Duration(milliseconds: 700));
                          if (!context.mounted) return;
                          Navigator.pop(modalCtx);
                          final controller = context.read<StudentController>();
                          await controller.payInstallment(inst.id);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    isArabic
                                        ? 'تم تأكيد السداد وإصدار إيصال السداد المعتمد!'
                                        : 'Payment confirmed & official receipt issued!',
                                  ),
                                ],
                              ),
                              backgroundColor: ThebesColors.success,
                            ),
                          );
                          // Show the official receipt immediately
                          final paidItem = controller.installments.firstWhere(
                            (i) => i.id == inst.id,
                            orElse: () => inst,
                          );
                          _showOfficialReceiptDialog(context, paidItem, isArabic);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThebesColors.gold,
                    foregroundColor: ThebesColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: ThebesColors.primaryDark),
                        )
                      : Text(
                          isArabic ? 'تأكيد السداد وإصدار الإيصال الرسمي' : 'Confirm & Issue Official Receipt',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTab({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? ThebesColors.gold.withAlpha(30) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? ThebesColors.gold : Colors.grey.withAlpha(70),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? ThebesColors.gold : Colors.grey),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? ThebesColors.gold : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFawryMethodView(BuildContext context, bool isDark, bool isArabic, String fawryCode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF14243B) : const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withAlpha(90)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.point_of_sale_rounded, color: Colors.orange, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'كود دفع فوري (الرقم المرجعي):' : 'Fawry Reference Code:',
                        style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 12, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          isArabic ? 'صالح 48 ساعة' : 'Valid 48h',
                          style: GoogleFonts.cairo(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fawryCode,
                    style: GoogleFonts.spaceMono(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: ThebesColors.gold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: ThebesColors.gold, size: 20),
                    tooltip: isArabic ? 'نسخ الكود' : 'Copy code',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: fawryCode.replaceAll(' ', '')));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isArabic ? 'تم نسخ كود فوري إلى الحافظة' : 'Fawry code copied to clipboard'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF101E31) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? 'خطوات السداد عبر منافذ فوري:' : 'How to pay via Fawry:',
                style: GoogleFonts.cairo(fontSize: 11.5, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                isArabic
                    ? '1. توجه لأي منفذ فوري أو استخدم تطبيق myFawry.\n2. اطلب خدمة "مدفوعات أكاديمية طيبة" (كود الخدمة: 788).\n3. أدخل الرقم المرجعي الموضح أعلاه وسيتم السداد فورياً.'
                    : '1. Visit any Fawry POS or open myFawry.\n2. Select "Thebes Academy Payments" (Service Code: 788).\n3. Enter the reference number above to complete payment.',
                style: GoogleFonts.cairo(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardMethodView(bool isDark, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF14243B) : const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThebesColors.gold.withAlpha(70)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isArabic ? 'بيانات البطاقة البنكية' : 'Card Details',
                    style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Visa / Meeza',
                          style: GoogleFonts.spaceMono(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B1728) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.credit_card_rounded, size: 18, color: ThebesColors.gold),
                    const SizedBox(width: 8),
                    Text(
                      '5378  ••••  ••••  4128',
                      style: GoogleFonts.spaceMono(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0B1728) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.withAlpha(60)),
                      ),
                      child: Text(
                        '08 / 28',
                        style: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0B1728) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.withAlpha(60)),
                      ),
                      child: Text(
                        'CVV: •••',
                        style: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.security_rounded, size: 14, color: ThebesColors.emerald),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                isArabic
                    ? 'متوافق مع بروتوكول 3D Secure ومعايير البنك المركزي المصري'
                    : 'Compliant with 3D Secure & Central Bank of Egypt standards',
                style: GoogleFonts.cairo(fontSize: 10.5, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInstaPayMethodView(BuildContext context, bool isDark, bool isArabic, String instaPayAddress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF14243B) : const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThebesColors.emerald.withAlpha(90)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isArabic ? 'عنوان الدفع اللحظي (IPA):' : 'InstaPay IPA Address:',
                    style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ThebesColors.emerald.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'InstaPay Direct',
                      style: GoogleFonts.spaceMono(fontSize: 10, color: ThebesColors.emerald, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    instaPayAddress,
                    style: GoogleFonts.spaceMono(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ThebesColors.gold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: ThebesColors.gold, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: instaPayAddress));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isArabic ? 'تم نسخ عنوان إنستاباي بنجاح' : 'InstaPay address copied'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF101E31) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isArabic
                ? 'يرجى وضع كود الطالب أو الرقم القومي في خانة "سبب التحويل" لسرعة التوثيق التلقائي.'
                : 'Please include student ID or National ID in transfer notes for automatic verification.',
            style: GoogleFonts.cairo(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showOfficialReceiptDialog(BuildContext context, PaymentInstallmentEntity inst, bool isArabic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = context.read<StudentController>();
    final student = controller.student;
    final receiptNo = inst.receiptNumber ?? 'THB-REC-2026-98124';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1E33) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          border: Border.all(color: ThebesColors.gold.withAlpha(90), width: 1.5),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.withAlpha(80), borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            // Academy Receipt Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'أكاديمية طيبة التعليمية' : 'Thebes Academy',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 16, color: ThebesColors.gold),
                    ),
                    Text(
                      isArabic ? 'الخزينة والحسابات الإلكترونية' : 'E-Finance & Treasury',
                      style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ThebesColors.emerald.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ThebesColors.emerald),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: ThebesColors.emerald, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'إيصال مسدد ومعتمد' : 'Paid & Certified',
                        style: GoogleFonts.cairo(color: ThebesColors.emerald, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount Banner
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: ThebesColors.royalCardGradient,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: ThebesColors.gold.withAlpha(100)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${inst.amount.toInt()} EGP',
                              style: GoogleFonts.spaceMono(
                                color: ThebesColors.gold,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              inst.getLocalizedTitle(isArabic),
                              style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Receipt Info Table
                    _buildReceiptRow(Icons.person_rounded, isArabic ? 'اسم الطالب:' : 'Student:', student.getLocalizedName(isArabic)),
                    _buildReceiptRow(Icons.badge_rounded, isArabic ? 'الرقم الأكاديمي:' : 'Academic ID:', student.academicId),
                    _buildReceiptRow(Icons.school_rounded, isArabic ? 'الكلية / القسم:' : 'Institute:', student.getLocalizedDepartment(isArabic)),
                    _buildReceiptRow(Icons.receipt_rounded, isArabic ? 'رقم الإيصال:' : 'Receipt No:', receiptNo),
                    _buildReceiptRow(Icons.date_range_rounded, isArabic ? 'تاريخ السداد:' : 'Payment Date:', inst.paidDate ?? '10 سبتمبر 2026'),
                    _buildReceiptRow(Icons.credit_card_rounded, isArabic ? 'وسيلة الدفع:' : 'Method:', 'فوري Fawry / بطاقة ميزة'),
                    const SizedBox(height: 16),

                    // Official Stamp Watermark & QR
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: QrImageView(
                              data: 'THEBES-RECEIPT-$receiptNo-${student.academicId}',
                              size: 70,
                              version: QrVersions.auto,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: ThebesColors.gold.withAlpha(20),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: ThebesColors.gold, width: 1.5),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.verified_rounded, color: ThebesColors.gold, size: 22),
                                const SizedBox(height: 4),
                                Text(
                                  isArabic ? 'الختم المالي المعتمد' : 'Official Treasury Stamp',
                                  style: GoogleFonts.cairo(color: ThebesColors.gold, fontWeight: FontWeight.w900, fontSize: 11),
                                ),
                                Text(
                                  isArabic ? 'أكاديمية طيبة - القاهرة' : 'Thebes Academy Cairo',
                                  style: GoogleFonts.cairo(color: Colors.grey, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThebesColors.gold,
                      foregroundColor: ThebesColors.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isArabic ? 'تم حفظ الإيصال المعتمد كملف PDF بنجاح' : 'Receipt PDF saved to downloads'),
                          backgroundColor: ThebesColors.emerald,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: Text(
                      isArabic ? 'تحميل وحفظ الإيصال (PDF)' : 'Download PDF Receipt',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 13.5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: ThebesColors.gold),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.cairo(fontSize: 12.5, color: Colors.grey)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showOfficialCertificateDialog(BuildContext context, ServiceRequestEntity req, bool isArabic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = context.read<StudentController>();
    final student = controller.student;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.80,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1E33) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          border: Border.all(color: ThebesColors.gold.withAlpha(90), width: 1.5),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.withAlpha(80), borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'وثيقة رسمية معتمدة' : 'Official Certified Document',
              style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: ThebesColors.gold),
            ),
            const SizedBox(height: 4),
            Text(
              isArabic ? 'صادرة من إدارة شؤون الطلاب - أكاديمية طيبة' : 'Issued by Thebes Student Affairs',
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      req.getLocalizedTitle(isArabic),
                      style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: ThebesColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isArabic
                          ? 'تشهد إدارة المعهد العالي للهندسة وتكنولوجيا الإدارة بأكاديمية طيبة بأن الطالب/ ${student.nameAr}، المقيد بالفرقة ${student.academicYear} بقسم ${student.departmentAr} للعام الجامعي 2026/2027، مقيد ومنتظم بالدراسة حتى تاريخه.\n\nوقد أعطيت له هذه الإفادة بناءً على طلبه لتقديمها إلى الجهات المختصة دون أدنى مسؤولية على الأكاديمية.'
                          : 'This is to certify that student ${student.nameEn}, enrolled in Year ${student.academicYear}, is a registered student in good standing.',
                      style: GoogleFonts.cairo(fontSize: 13, height: 1.8),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(isArabic ? 'الموظف المختص' : 'Registrar', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(isArabic ? 'أحمد الشاذلي' : 'A. El-Shazly', style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: ThebesColors.gold.withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ThebesColors.gold),
                          ),
                          child: Text(
                            isArabic ? 'خاتم شعار الأكاديمية' : 'Academy Seal',
                            style: GoogleFonts.cairo(color: ThebesColors.gold, fontWeight: FontWeight.w900, fontSize: 11),
                          ),
                        ),
                        Column(
                          children: [
                            Text(isArabic ? 'عميد المعهد' : 'Dean', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(isArabic ? 'أ.د. عادل سليمان' : 'Prof. A. Soliman', style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThebesColors.gold,
                  foregroundColor: ThebesColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isArabic ? 'تم تنزيل الوثيقة الرسمية بصيغة PDF معتمدة' : 'Official PDF downloaded'),
                      backgroundColor: ThebesColors.emerald,
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: Text(
                  isArabic ? 'تنزيل الإفادة الرسمية (PDF)' : 'Download Certified Document',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
