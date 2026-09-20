import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydrosavex/model/notification.dart';

class LifeguardNotificationController {
  Stream<List<LifeguardNotification>>? lifeguardNotificationStream;

  LifeguardNotificationController() {
    lifeguardNotificationStream = FirebaseFirestore.instance
        .collection("lifeguardnotifications")
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      final list = querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
        var data = documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          DateTime parsedDate = DateTime.now();
          if (data['date'] is Timestamp) {
            parsedDate = (data['date'] as Timestamp).toDate();
          } else if (data['date'] is String) {
            parsedDate = DateTime.tryParse(data['date']) ?? DateTime.now();
          }
          return LifeguardNotification(
            id: documentSnapshot.id,
            text: data['text'] ?? '',
            orgId: data['orgID'] ?? data['orgId'] ?? data['orgCode'] ?? '',
            sent: data['sent'] ?? false,
            date: parsedDate,
          );
        } else {
          return LifeguardNotification(
            id: documentSnapshot.id,
            text: '',
            orgId: '',
            sent: false,
            date: DateTime.now(),
          );
        }
      }).toList();

      // Sort descending by date (newest alerts on top)
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    });
  }
  Future<void> fetchLifeguardReports() async {
    await Firebase.initializeApp();
    // The stream is already initialized in the constructor, no need to reinitialize here.
  }

  Future<void> updateSent(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('lifeguardnotifications')
          .doc(id)
          .update({'sent': true});
    } catch (e) {
      print("Error updating 'sent' status: $e");
    }
  }
}