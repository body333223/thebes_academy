import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/features/student/domain/entities/notification_entity.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationType? _filterType;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.watch<StudentController>();
    final allNotifications = controller.notifications;

    final filtered = _filterType == null
        ? allNotifications
        : allNotifications.where((n) => n.type == _filterType).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'مركز الإشعارات والتنبيهات' : 'Notification Center'),
        actions: [
          if (controller.unreadNotificationsCount > 0)
            TextButton.icon(
              onPressed: () => controller.markAllNotificationsAsRead(),
              icon: const Icon(Icons.done_all_rounded, size: 18, color: ThebesColors.cobalt),
              label: Text(
                isArabic ? 'تحديد كـ مقروء' : 'Mark all read',
                style: GoogleFonts.cairo(color: ThebesColors.cobalt, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              // Filter Chips
              _buildFilterChips(isArabic, isDark),
              const Divider(height: 1),

              // Notifications List
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState(isArabic, isDark)
                    : ListView.builder(
                        padding: context.responsiveScreenPadding,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _buildNotificationCard(item, controller, isArabic, isDark);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isArabic, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildChip(
            label: isArabic ? 'الكل' : 'All',
            isSelected: _filterType == null,
            onTap: () => setState(() => _filterType = null),
            isDark: isDark,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: isArabic ? 'إنذارات الغياب' : 'Absence Alerts',
            icon: Icons.warning_amber_rounded,
            isSelected: _filterType == NotificationType.absenceWarning,
            onTap: () => setState(() => _filterType = NotificationType.absenceWarning),
            isDark: isDark,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: isArabic ? 'المحاضرات' : 'Lectures',
            icon: Icons.school_outlined,
            isSelected: _filterType == NotificationType.lectureReminder,
            onTap: () => setState(() => _filterType = NotificationType.lectureReminder),
            isDark: isDark,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: isArabic ? 'أخبار الكلية' : 'News & Announcements',
            icon: Icons.campaign_outlined,
            isSelected: _filterType == NotificationType.universityNews,
            onTap: () => setState(() => _filterType = NotificationType.universityNews),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? ThebesColors.primaryNavy
              : (isDark ? ThebesColors.darkCard : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? ThebesColors.cobalt
                : (isDark ? ThebesColors.darkCardBorder : Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? ThebesColors.cobalt : (isDark ? Colors.white70 : Colors.black54),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    NotificationEntity item,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    Color typeColor;
    IconData typeIcon;

    switch (item.type) {
      case NotificationType.absenceWarning:
        typeColor = ThebesColors.error;
        typeIcon = Icons.warning_amber_rounded;
        break;
      case NotificationType.lectureReminder:
        typeColor = ThebesColors.cobalt;
        typeIcon = Icons.access_time_rounded;
        break;
      case NotificationType.gradeAlert:
        typeColor = ThebesColors.success;
        typeIcon = Icons.stars_rounded;
        break;
      case NotificationType.universityNews:
        typeColor = ThebesColors.accentBlue;
        typeIcon = Icons.campaign_rounded;
        break;
    }

    final timeStr = DateFormat('yyyy/MM/dd - hh:mm a').format(item.timestamp);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: ThebesColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => controller.deleteNotification(item.id),
      child: GestureDetector(
        onTap: () {
          if (!item.isRead) {
            controller.markNotificationAsRead(item.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.isRead
                ? (isDark ? ThebesColors.darkCard : Colors.white)
                : (isDark
                    ? ThebesColors.opacity(typeColor, 0.15)
                    : typeColor.withAlpha(20)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: !item.isRead
                  ? typeColor
                  : (isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder),
              width: !item.isRead ? 1.5 : 1.0,
            ),
            boxShadow: item.isRead
                ? []
                : [
                    BoxShadow(
                      color: typeColor.withAlpha(30),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: typeColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(typeIcon, color: typeColor, size: 24),
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isArabic ? item.titleAr : item.titleEn,
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: item.isRead ? FontWeight.bold : FontWeight.w900,
                              color: isDark ? Colors.white : ThebesColors.primaryNavy,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: typeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isArabic ? item.messageAr : item.messageEn,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeStr,
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isArabic, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            isArabic ? 'لا توجد إشعارات في هذا التصنيف' : 'No notifications in this category',
            style: GoogleFonts.cairo(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
