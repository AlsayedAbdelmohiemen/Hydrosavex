import 'package:cloud_firestore/cloud_firestore.dart';


class LifeguardReport {
  String id;
  String comment;
  String orgId;
  Timestamp date;
  String type;
  bool sent;

  LifeguardReport({
    required this.id,
    required this.comment,
    required this.orgId,
    required this.type,
    required this.date,
    required this.sent,
  });

  // Method to convert JSON to LifeguardReport object
  LifeguardReport.fromJson(Map<String, dynamic> json)
      : this(
    id: json['id'],
    comment: json['comment'],
    orgId: json['orgId'],
    type: json['type'],
    date: json['date'],
    sent: json['sent'],
  );

  // Method to convert LifeguardReport object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "comment": comment,
      "orgId": orgId,
      "type": type,
      "date": date,
      "sent": sent,
    };
  }
}
