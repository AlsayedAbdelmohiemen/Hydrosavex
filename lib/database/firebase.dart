import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GetFirebase {
  // Singleton pattern
  static final GetFirebase _singleton = GetFirebase._internal();

  // Firebase Storage reference
  final firebaseStorageRef = FirebaseStorage.instance.ref();

  // Color flag
  bool color = true;

  // Private constructor for singleton
  GetFirebase._internal();

  // Factory constructor returns the singleton instance
  factory GetFirebase() {
    return _singleton;
  }

  // Getter for color flag
  bool get getColor => color;

  // Getter for user ID
  String get getUserID => FirebaseAuth.instance.currentUser?.uid ?? '';

  // Getter for Firebase Storage reference
  Reference get fbStorage => firebaseStorageRef;

  // Getter for Firebase Auth instance
  FirebaseAuth get auth => FirebaseAuth.instance;


}
