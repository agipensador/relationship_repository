import 'package:firebase_storage/firebase_storage.dart';
import 'package:love_relationship/core/services/storage_service.dart';

class FirebaseStorageService implements StorageService {
  final FirebaseStorage storage;
  FirebaseStorageService(this.storage);

  @override
  Future<String> getImageUrl(String path) async{
    final ref = storage.ref().child(path);
    return await ref.getDownloadURL();
  }
}