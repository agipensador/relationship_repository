import 'package:love_relationship/features/notifications/domain/repositories/notification_repository.dart';

class SyncFcmTokenUseCase {
  final NotificationRepository repo;
  SyncFcmTokenUseCase(this.repo);
  Future<void> call() => repo.syncToken();
}
