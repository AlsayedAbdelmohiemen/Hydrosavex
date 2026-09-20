import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydrosavex/model/medicReport.dart';

class MedicReportController {
  MedicReportController();

  late Stream<List<MedicReport>> medicReports;

  Future<void> fetchMedicReports() async {
    await Firebase.initializeApp(); // Ensure Firebase is initialized
    medicReports = FirebaseFirestore.instance
        .collection("medicreports")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
        .map((documentSnapshot) {
          final data = documentSnapshot.data();
          return MedicReport(
            id: documentSnapshot.id,
            comment: data['comment'] ?? '',
            orgId: data['orgId'] ?? '',
            date: data['date'] is Timestamp ? data['date'] : Timestamp.now(),
            type: data['type'] ?? '',
            sent: data['sent'] ?? false,
          );
        })
        .toList());
  }

  // Add a new medic report to Firestore
  Future<void> addMedicReport({
    required String id,
    required String comment,
    required String orgId,
    required String type,
    required bool sent,
  }) async {
    var now = DateTime.now(); // Get current time as DateTime
    await FirebaseFirestore.instance.collection("medicreports").doc(id).set({
      'comment': comment,
      'date': Timestamp.fromDate(now), // Convert DateTime to Timestamp
      'orgId': orgId,
      'type': type,
      'sent': sent,
      'sentTO': "organisationManager",
    });
  }
}
