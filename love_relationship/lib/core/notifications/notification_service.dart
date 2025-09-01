import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static const _channelId = 'app_default_channel';
  static const _channelName = 'Default';
  static const _channelDesc = 'General notifications';

  NotificationService(
    this._firebaseMessaging,
    this._flutterLocalNotificationsPlugin,
  );

  //ISSO FUNCIONA
  // Future<void> init() async {
  //   //iOS pede permissão , Android ignora
  //   // safeGetFcmToken();

  //   //Firebase Ok mesmo sem APNs
  //   await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   // Inicialização do plugin flutter Local Notification Plugin
  //   const init = InitializationSettings(
  //     android: AndroidInitializationSettings('ic_notification'),
  //     iOS: DarwinInitializationSettings(
  //       // iOS <10 ignorado; iOS 10+ usa UNUserNotificationCenter
  //       // se quiser, pode setar onDidReceiveLocalNotification para iOS 9
  //     ),
  //   );
  //   await _flutterLocalNotificationsPlugin.initialize(init);

  //   // 3) ANDROID 13+: peça permissão de notificação em runtime
  //   await _flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin
  //       >()
  //       ?.requestNotificationsPermission();

  //   //canal android
  //   const channel = AndroidNotificationChannel(
  //     _channelId,
  //     _channelName,
  //     description: _channelDesc,
  //     importance: Importance.high,
  //   );

  //   await _flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin
  //       >()
  //       ?.createNotificationChannel(channel);

  //   // TODO IOS PUSH NOTIFICATION
  //   //Permissao do plugin (necessário para simulador(ios))
  //   await _flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //         IOSFlutterLocalNotificationsPlugin
  //       >()
  //       ?.requestPermissions(alert: true, badge: true, sound: true);

  //   // (Opcional) iOS: quando tiver APNs, isso mostra remote-notif em FG
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );

  //   //Exibe notificacao local FOREGROUND
  //   FirebaseMessaging.onMessage.listen((RemoteMessage msg) async {
  //     final notification = msg.notification;
  //     if (notification == null) return;

  //     await showLocal(title: notification.title, body: notification.body);
  //   });
  // }

  //FUNC NOVA
  /// Configura plugin, canal e listeners. NÃO pede permissão.
  Future<void> initCore() async {
    const init = InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
      iOS: DarwinInitializationSettings(),
    );
    await _flutterLocalNotificationsPlugin.initialize(init);

    // Android 13+ (v17+ do plugin)
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // Cria canal antes de qualquer show
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Foreground FCM → renderiza como notificação local
    FirebaseMessaging.onMessage.listen((msg) async {
      final n = msg.notification;
      if (n != null) {
        await showLocal(title: n.title, body: n.body);
      }
    });
  }

  Future<String?> safeGetFcmToken() async {
    // if (Platform.isIOS) {
    //   // pede permissão mesmo sem APNs
    //   await messaging.requestPermission(alert: true, badge: true, sound: true);
    //   //tenta obter APNs token
    //   final apnsToken = await messaging.getAPNSToken();
    //   if (apnsToken == null) {
    //     //Sem APNs não se pode tentar o getToken pra não dar exception
    //     return null;
    //     //TODO CRIAR O ELSE PARA PUSH NOTIFICATION
    //   }
    // }

    if (Platform.isIOS) {
      final apns = await _firebaseMessaging.getAPNSToken();
      if (apns == null) return null;
    }
    return _firebaseMessaging.getToken();
  }

  /// Pede permissões (chamar após 1º frame / quando a UI já apareceu)
  Future<void> requestPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // iOS: também pelo plugin
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // iOS: quando tiver APNs, isso mostra push remoto em foreground
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
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
          icon: 'ic_notification', // drawable válido
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      // id previsível (p.ex. timestamp em segundos)
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _flutterLocalNotificationsPlugin.show(
        id,
        //TODO ALTERAR - SOMENTE EM TESTES
        title ?? 'Sem título',
        body ?? 'Sem corpo',
        details,
      );
      return true;
    } on PlatformException catch (e) {
      print('FLN.show PlatformException: code=${e.code} msg=${e.message}');
      return false;
    } catch (e) {
      print('FLN.show error: $e');
      return false;
    }
  }
}
