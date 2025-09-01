import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  // Use o bucket informado por você:
  // gs://love-relationship-7c9ad.firebasestorage.app
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: 'gs://love-relationship-7c9ad.firebasestorage.app',
  );

  /// Retorna uma URL de download para o arquivo no path [path]
  /// Ex.: getImageUrl('logo.png')
  Future<String> getImageUrl(String path) async {
    final ref = _storage.ref().child(path);
    return await ref.getDownloadURL();
  }
}
