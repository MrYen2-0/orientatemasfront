import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.success,
      title: 'Evaluación Completa',
      body: 'Tu evaluación vocacional ha sido procesada. Ver resultados ahora',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      actionText: 'Ver resultados',
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.info,
      title: 'Nuevo contenido en X carrera',
      body: 'Nuevos testimonios o cambios grandes en las carreras',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      actionText: 'Ver',
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.system,
      title: 'Actualización del sistema',
      body: 'Pusimos más bugs para no quedarnos sin trabajo',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: false,
    ),
    NotificationItem(
      id: '4',
      type: NotificationType.reminder,
      title: 'Recordatorio de evaluación',
      body: 'Han pasado 30 días desde tu última evaluación',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = NotificationItem(
          id: _notifications[index].id,
          type: _notifications[index].type,
          title: _notifications[index].title,
          body: _notifications[index].body,
          timestamp: _notifications[index].timestamp,
          isRead: true,
          actionText: _notifications[index].actionText,
        );
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = NotificationItem(
          id: _notifications[i].id,
          type: _notifications[i].type,
          title: _notifications[i].title,
          body: _notifications[i].body,
          timestamp: _notifications[i].timestamp,
          isRead: true,
          actionText: _notifications[i].actionText,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Notificaciones', style: AppTextStyles.h4),
        centerTitle: true,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Marcar todas',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: notification.isRead ? AppColors.white : AppColors.primary50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead ? AppColors.gray200 : AppColors.primary700,
        ),
      ),
      child: InkWell(
        onTap: () => _markAsRead(notification.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono según tipo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getTypeIcon(notification.type),
                  color: _getTypeColor(notification.type),
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: AppColors.gray900,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary600,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray400,
                      ),
                    ),
                    if (notification.actionText != null) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          _markAsRead(notification.id);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          notification.actionText!,
                          style: TextStyle(
                            color: AppColors.primary600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppColors.gray300,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay notificaciones',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Te avisaremos cuando haya algo nuevo',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.info:
        return Icons.star_outline;
      case NotificationType.system:
        return Icons.info_outline;
      case NotificationType.reminder:
        return Icons.alarm;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return AppColors.success600;
      case NotificationType.info:
        return AppColors.warning600;
      case NotificationType.system:
        return AppColors.info600;
      case NotificationType.reminder:
        return AppColors.secondary600;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

// Modelo de Notificación
class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? actionText;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    this.actionText,
  });
}

enum NotificationType {
  success,
  info,
  system,
  reminder,
}