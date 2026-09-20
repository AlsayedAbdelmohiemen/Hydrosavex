import 'package:cloud_firestore/cloud_firestore.dart';

class MedicReport {
  String id;
  String comment;
  String orgId;
  Timestamp date;
  String type;
  bool sent;

  MedicReport({
    required this.id,
    required this.comment,
    required this.orgId,
    required this.date,
    required this.sent,
    required this.type,
  });

  // Method to convert JSON to MedicReport object
  MedicReport.fromJson(Map<String, dynamic> json)
      : this(
          type: json['type'] ?? '',
          sent: json['sent'] ?? false,
          id: json['id'] ?? '',
          comment: json['comment'] ?? '',
          orgId: json['orgId'] ?? '',
          date: json['date'] ?? Timestamp.now(),
        );

  // Method to convert MedicReport object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "comment": comment,
      "orgId": orgId,
      "date": date,
      "type": type,
      "sent": sent,
    };
  }
}
