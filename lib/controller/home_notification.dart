import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrosavex/model/notifications_home.dart';

class HomeNotificationProvider with ChangeNotifier {
  Stream<List<HomeNotification>>? homeNotificationStream;
  bool _disposed = false;

  HomeNotificationProvider() {
    _initializeStream();
  }

  void _initializeStream() {
    homeNotificationStream = FirebaseFirestore.instance
        .collection("homenotifications")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
        var data = documentSnapshot.data() as Map<String, dynamic>?;

        return HomeNotification(
          id: documentSnapshot.id,
          text: data?['text'] ?? '',
          orgCode: data?['orgCode'] ?? '',
          sent: data?['sent'] ?? false,
          date: data?['date'] != null
              ? (data!['date'] as Timestamp).toDate() // Convert Timestamp to DateTime
              : DateTime.now(),
        );
      }).toList();
    }).handleError((error) {
      print("Error in stream: $error");
    });

    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Update 'sent' status and date
  void updateSent(String id, DateTime yourDateTime) {
    FirebaseFirestore.instance
        .collection('homenotifications')
        .doc(id)
        .update({
      'sent': true,
    }).catchError((e) {
      print("Error updating sent status: $e");
    });
  }
}
