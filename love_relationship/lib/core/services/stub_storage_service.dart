import 'package:love_relationship/core/services/storage_service.dart';

/// Implementação stub do StorageService (sem Firebase/S3).
/// Retorna string vazia. Substituir por S3 quando disponível.
class StubStorageService implements StorageService {
  @override
  Future<String> getImageUrl(String path) async => '';
}
