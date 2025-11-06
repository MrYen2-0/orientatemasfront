import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Datos de ejemplo
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.evaluation,
      title: 'Evaluación completada',
      body: 'Tu evaluación vocacional ha sido procesada. Ver resultados ahora.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      actionText: 'Ver resultados',
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.newContent,
      title: 'Nuevos testimonios disponibles',
      body: 'Lee experiencias de Ingenieros Industriales',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.reminder,
      title: 'Recordatorio: Repetir evaluación',
      body: 'Ya puedes realizar una nueva evaluación vocacional',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      actionText: 'Comenzar',
    ),
    NotificationItem(
      id: '4',
      type: NotificationType.university,
      title: 'Nueva universidad agregada',
      body: 'El Tec de Monterrey ahora está disponible en el catálogo',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      type: NotificationType.newContent,
      title: 'Nuevo contenido en Psicología',
      body: '3 testimonios nuevos de profesionales agregados',
      timestamp: DateTime.now().subtract(const Duration(days: 14)),
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      type: NotificationType.system,
      title: 'Actualización del sistema',
      body: 'Mejoras en el algoritmo de recomendación implementadas',
      timestamp: DateTime.now().subtract(const Duration(days: 30)),
      isRead: true,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las notificaciones marcadas como leídas'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
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
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: AppColors.gray200,
        ),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      color: notification.isRead ? AppColors.white : AppColors.primary50,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: _getNotificationColor(notification.type),
                size: 24,
              ),
            ),
            if (!notification.isRead)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primary600,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          notification.title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  // TODO: Implementar acción
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(notification.actionText!),
              ),
            ],
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            _markAsRead(notification.id);
          }
          // TODO: Navegar según tipo de notificación
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: AppColors.gray300,
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes notificaciones',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 8),
          Text(
            'Cuando tengas notificaciones nuevas\naparecerán aquí',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.evaluation:
        return Icons.check_circle_outline;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.newContent:
        return Icons.star_outline;
      case NotificationType.university:
        return Icons.school_outlined;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.evaluation:
        return AppColors.success600;
      case NotificationType.reminder:
        return AppColors.primary600;
      case NotificationType.newContent:
        return AppColors.accent600;
      case NotificationType.university:
        return AppColors.secondary600;
      case NotificationType.system:
        return AppColors.gray600;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    }
  }
}

// Modelo de datos
class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;
  final String? actionText;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.actionText,
  });
}

enum NotificationType {
  evaluation,
  reminder,
  newContent,
  university,
  system,
}