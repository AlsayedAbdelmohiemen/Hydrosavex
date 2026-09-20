import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrosavex/model/lifeguardReport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class LifeguardReportController {
  late Stream<List<LifeguardReport>> lifeguardReports;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  LifeguardReportController();

  Future<void> fetchLifeguardReports() async {
    await Firebase.initializeApp();
    lifeguardReports = FirebaseFirestore.instance
        .collection("lifeguardReports")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((documentSnapshot) {
              final data = documentSnapshot.data();
              Timestamp ts = Timestamp.now();
              if (data['date'] is Timestamp) {
                ts = data['date'] as Timestamp;
              }
              return LifeguardReport(
                id: documentSnapshot.id,
                comment: data['comment'] ?? '',
                orgId: (data['orgId'] ?? data['orgID'] ?? data['orgCode'] ?? '').toString(),
                type: data['type'] ?? '',
                date: ts,
                sent: data['sent'] ?? false,
              );
            }).toList());
  }
  Future<DocumentReference?> addLifeguardReport({
    required String type,
    required String comment,
    required String orgId,
  }) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('lifeguardReports')
          .doc(); // Generates a new ID

      await docRef.set({
        'type': type,
        'comment': comment,
        'orgId': orgId,
        'sent': false, // Initialize 'sent' field
        'date': FieldValue.serverTimestamp(), // Add a timestamp
      });

      print('Report added with ID: ${docRef.id}');
      return docRef;
    } catch (e) {
      print('Error adding lifeguard report: $e');
      return null; // Return null in case of error
    }
  }

  Future<void> updateSent(String id) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('lifeguardReports')
          .doc(id);

      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({'sent': true});
        print('Sent status updated for ID: $id');
      } else {
        print('Error: Document with ID $id does not exist.');
      }
    } catch (e) {
      print('Error updating "sent" status: $e');
    }
  }



  Future<void> updateSubscriber(String id, bool subscriber) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .get();

      if (doc.exists) {
        var role = doc['role'] ?? ''; // Default to empty string if null
        var orgId = doc['orgId'] ?? ''; // Default to empty string if null

        if (subscriber == false) {
          await firebaseMessaging.unsubscribeFromTopic(orgId + role);
        } else {
          await firebaseMessaging.subscribeToTopic(orgId + role);
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .update({'subscriber': subscriber});
      } else {
        print('Error: User with ID $id does not exist.');
      }
    } catch (e) {
      print("Error updating 'subscriber' status: $e");
    }
  }
}
