import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> storeUserToken() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fcmToken': fcmToken,
        }, SetOptions(merge: true));
      }
    }
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    
  }
}
