import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<String?> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'fotos_de_usuarios/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = await storageRef.putFile(image);

      if (uploadTask.state == TaskState.success) {
        return await storageRef.getDownloadURL();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
