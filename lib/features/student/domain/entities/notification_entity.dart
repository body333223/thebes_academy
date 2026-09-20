enum NotificationType {
  lectureReminder,
  absenceWarning,
  universityNews,
  gradeAlert,
}

class NotificationEntity {
  final String id;
  final String titleAr;
  final String titleEn;
  final String messageAr;
  final String messageEn;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? actionRoute;
  final Map<String, dynamic>? metadata;

  const NotificationEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.messageAr,
    required this.messageEn,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.actionRoute,
    this.metadata,
  });

  NotificationEntity copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    String? messageAr,
    String? messageEn,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    String? actionRoute,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      messageAr: messageAr ?? this.messageAr,
      messageEn: messageEn ?? this.messageEn,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'messageAr': messageAr,
      'messageEn': messageEn,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'isRead': isRead,
      'actionRoute': actionRoute,
      'metadata': metadata,
    };
  }

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      messageAr: json['messageAr'] as String? ?? '',
      messageEn: json['messageEn'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.universityNews,
      ),
      isRead: json['isRead'] as bool? ?? false,
      actionRoute: json['actionRoute'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
