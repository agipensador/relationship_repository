import 'package:love_relationship/features/notifications/domain/repositories/notification_repository.dart';

class SubscribeTopicUseCase {
  final NotificationRepository repo;
  SubscribeTopicUseCase(this.repo);
  Future<void> call(String topic) => repo.subscribeTopic(topic);
}
