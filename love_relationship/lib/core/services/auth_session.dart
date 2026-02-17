/// Interface para sessão de autenticação (Cognito/Amplify).
abstract class AuthSession {
  String? currentUidOrNull();
  String requireUid(); // Lança se não autenticado
  Stream<String?> uidChanges();
}