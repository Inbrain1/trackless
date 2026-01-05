import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageService {
  Future<String> uploadImage(File file);
}

class StorageServiceImpl implements StorageService {
  final FirebaseStorage _storage;

  StorageServiceImpl({FirebaseStorage? storage}) 
      : _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadImage(File file) async {
    try {
      // Create a unique filename based on timestamp
      final String fileName = 'discovery_images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      
      final Reference ref = _storage.ref().child(fileName);
      final UploadTask uploadTask = ref.putFile(file);
      
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }
}

// Mock implementation for testing or offline dev if needed
class MockStorageService implements StorageService {
  @override
  Future<String> uploadImage(File file) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // Return a dummy URL
    return 'https://picsum.photos/500/300'; 
  }
}
