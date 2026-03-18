import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:love_relationship/features/notifications/domain/repositories/notification_repository.dart';

/// Implementação que usa Firebase Cloud Messaging.
class FcmNotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<void> syncToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (kDebugMode && token != null) {
        debugPrint('[FCM] Token: ${token.substring(0, 20)}...');
      }
      // TODO: enviar token para backend (Lambda/API) quando disponível
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[FCM] Erro ao obter token: $e');
        debugPrint('[FCM] Stack: $st');
      }
    }
  }

  @override
  Future<void> subscribeTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      if (kDebugMode) {
        debugPrint('[FCM] Inscrito no tópico: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Erro ao inscrever em $topic: $e');
      }
    }
  }

  @override
  Future<void> unsubscribeTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        debugPrint('[FCM] Desinscrito do tópico: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Erro ao desinscrever de $topic: $e');
      }
    }
  }
}
