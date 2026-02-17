import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';

/// Serviço de notificações (local + push futuro com SNS/Pinpoint).
/// FCM removido; apenas notificações locais por enquanto.
class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static const _channelId = 'app_default_channel';
  static const _channelName = 'Default';
  static const _channelDesc = 'General notifications';

  NotificationService(this._flutterLocalNotificationsPlugin);

  Future<void> initCore() async {
    const init = InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
      iOS: DarwinInitializationSettings(),
    );
    await _flutterLocalNotificationsPlugin.initialize(init);

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<bool> showLocal({String? title, String? body}) async {
    try {
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_notification',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _flutterLocalNotificationsPlugin.show(
        id,
        title ?? 'Sem título',
        body ?? 'Sem corpo',
        details,
      );
      return true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('FLN.show PlatformException: code=${e.code} msg=${e.message}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('FLN.show error: $e');
      }
      return false;
    }
  }
}
