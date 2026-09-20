
import 'package:cloud_firestore/cloud_firestore.dart';

class LifeguardNotification {
  String id;
  String text;
  String orgId;
  bool sent;
  DateTime date;

  LifeguardNotification({
    required this.id,
    required this.text,
    required this.orgId,
    required this.sent,
    required this.date,
  });

  factory LifeguardNotification.fromJson(Map<String, dynamic> json) {
    return LifeguardNotification(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      orgId: json['orgId'] ?? '',
      sent: json['sent'] ?? false,
      date: json['date'] != null
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(), // Provide default date if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "orgId": orgId,
      "sent": sent,
      "date": date,
    };
  }
}
