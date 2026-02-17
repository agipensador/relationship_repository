import 'package:love_relationship/features/notifications/domain/repositories/notification_repository.dart';

/// Implementação stub (sem FCM). Substituir por SNS/Pinpoint quando disponível.
class StubNotificationRepository implements NotificationRepository {
  @override
  Future<void> syncToken() async {}

  @override
  Future<void> subscribeTopic(String topic) async {}

  @override
  Future<void> unsubscribeTopic(String topic) async {}
}
