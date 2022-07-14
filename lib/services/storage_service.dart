import 'dart:io';

import 'package:bethel_smallholding/services/api_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  String get blogPostImagePath => APIPath.blogPostImages;

  Future<String> putFile(String filePath) async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    String id = const Uuid().v4();
    Reference reference = _storage.ref().child("$blogPostImagePath/$id");
    var file = File(filePath);
    await reference.putFile(file);
    return await reference.getDownloadURL();
  }

  Future<void> deleteFile(String filePath) async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    Reference reference = _storage.refFromURL(filePath);
    await reference.delete();
  }
}
