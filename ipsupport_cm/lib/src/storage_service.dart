import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /// The function `uploadFile` uploads a file to Firebase storage with the specified file path and
  /// name.
  ///
  /// Args:
  ///   filePath (String): The `filePath` parameter is a string that represents the path to the file
  /// that you want to upload. It should include the file name and extension.
  ///   fileName (String): The `fileName` parameter is a string that represents the name of the file to
  /// be uploaded.
  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('test/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  /// The function lists all files in the 'test' directory in Firebase Storage and prints their
  /// references.
  ///
  /// Returns:
  ///   a `Future` object that resolves to a `firebase_storage.ListResult` object.
  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('test').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });

    return results;
  }
}
