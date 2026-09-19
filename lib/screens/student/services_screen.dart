import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/thebes_colors.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/responsive/responsive_helper.dart';
import '../../features/student/domain/entities/academic_entities.dart';
import '../../features/student/presentation/controllers/student_controller.dart';

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 16, color: ThebesColors.gold),
                  const SizedBox(width: 6),
                  Text(
                    '${isArabic ? "إيصال:" : "Receipt:"} ${inst.receiptNumber}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
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
    showModalBottomSheet(
      context: context,
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
            Text(
              isArabic ? 'سداد المصروفات الدراسية' : 'Tuition Payment Gateway',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ThebesColors.opacity(ThebesColors.primary, 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(inst.getLocalizedTitle(isArabic)),
                  Text(
                    '${inst.amount.toInt()} ج.م',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ThebesColors.gold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isArabic ? 'اختر طريقة الدفع:' : 'Select Payment Method:',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.point_of_sale_rounded, color: Colors.orange),
              title: const Text('فوري Fawry Pay'),
              subtitle: Text(isArabic ? 'كود دفع فوري صالح لـ 48 ساعة' : 'Fawry Ref code valid 48h'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _executePayment(context, inst, ctx, isArabic),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card_rounded, color: Colors.blue),
              title: const Text('بطاقة بنكية (Visa / MasterCard / Meeza)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _executePayment(context, inst, ctx, isArabic),
            ),
          ],
        ),
      ),
    );
  }

  void _executePayment(BuildContext context, PaymentInstallmentEntity inst, BuildContext modalCtx, bool isArabic) {
    Navigator.pop(modalCtx);
    context.read<StudentController>().payInstallment(inst.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic
              ? 'تم سداد القسط بنجاح! تم إصدار إيصال السداد الإلكتروني.'
              : 'Payment successful! Electronic receipt generated.',
        ),
        backgroundColor: ThebesColors.success,
      ),
    );
  }
}
