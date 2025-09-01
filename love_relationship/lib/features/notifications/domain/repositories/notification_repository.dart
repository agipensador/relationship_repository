abstract class NotificationRepository {
  Future<void> syncToken(); // salva/atualiza token do usuário logado
  Future<void> subscribeTopic(String topic);
  Future<void> unsubscribeTopic(String topic);
}
