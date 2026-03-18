import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';

/// Serviço de notificações (local + FCM push).
class NotificationService {
  NotificationService(this._flutterLocalNotificationsPlugin);

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static const _channelId = 'app_default_channel';
  static const _channelName = 'Default';
  static const _channelDesc = 'General notifications';

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

  /// Inicializa FCM (chamar apenas quando Firebase estiver configurado).
  Future<void> initFcm() async {
    await requestPermissions();

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }

    // Solicita token e loga para debug (use em "Enviar para dispositivo único" no Firebase Console)
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (kDebugMode && token != null) {
        debugPrint('[FCM] Token (copie para testar no Firebase Console):');
        debugPrint(token);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Erro ao obter token: $e');
      }
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('[FCM] Mensagem em foreground: ${message.notification?.title}');
    }
    final notification = message.notification;
    showLocal(
      title: notification?.title ?? 'Nova notificação',
      body: notification?.body ?? '',
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('[FCM] Notificação tocada: ${message.messageId}');
    }
    // TODO: navegar para tela específica baseado em message.data
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

    if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kDebugMode) {
        debugPrint('[FCM] Permissão iOS: ${settings.authorizationStatus}');
      }
    }
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
        debugPrint('FLN.show PlatformException: code=${e.code} msg=${e.message}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FLN.show error: $e');
      }
      return false;
    }
  }
}
