/// Interface para serviço de armazenamento (S3, etc).
/// Ex.: getImageUrl('logo.png')
abstract class StorageService {
  Future<String> getImageUrl(String path);
}
