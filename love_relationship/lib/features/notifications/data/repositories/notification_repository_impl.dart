// lib/features/notifications/data/repositories/notification_repository_impl.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:love_relationship/features/notifications/domain/repositories/notification_repository.dart'
    show NotificationRepository;

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseMessaging messaging;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  NotificationRepositoryImpl(this.messaging, this.firestore, this.auth);

  @override
  Future<void> syncToken() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    final token = await _safeGetFcmToken();

    if (token == null) return; // iOS grátis pode retornar null

    await firestore
        .collection('users')
        .doc(uid)
        .collection('fcmTokens')
        .doc(token)
        .set({
          'platform': Platform.isIOS ? 'ios' : 'android',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    // Evita múltiplas inscrições se o repo não for singleton
    messaging.onTokenRefresh.listen((newToken) async {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('fcmTokens')
          .doc(newToken)
          .set({
            'platform': Platform.isIOS ? 'ios' : 'android',
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    });
  }

  // Future<String?> _safeGetFcmToken() async {
  //   final messaging = FirebaseMessaging.instance;
  //   if (Platform.isIOS) {
  //     // pede permissão mesmo sem APNs
  //     await messaging.requestPermission(alert: true, badge: true, sound: true);
  //     //tenta obter APNs token
  //     final apnsToken = await messaging.getAPNSToken();
  //     if (apnsToken == null) {
  //       //Sem APNs não se pode tentar o getToken pra não dar exception
  //       return null;
  //       //TODO CRIAR O ELSE PARA PUSH NOTIFICATION
  //     }
  //   }
  //   // Android (ou iOS já com APNs) → ok
  //   return await messaging.getToken();
  // }

  Future<String?> _safeGetFcmToken() async {
    if (Platform.isIOS) {
      final apnsToken = await messaging.getAPNSToken();
      if (apnsToken == null) return null;
    }
    return messaging.getToken();
  }

  @override
  Future<void> subscribeTopic(String topic) =>
      messaging.subscribeToTopic(topic);

  @override
  Future<void> unsubscribeTopic(String topic) =>
      messaging.unsubscribeFromTopic(topic);
}
