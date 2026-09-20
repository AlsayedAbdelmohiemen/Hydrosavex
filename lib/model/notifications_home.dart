import 'package:cloud_firestore/cloud_firestore.dart';

class HomeNotification {
  String id;
  String text;
  String orgCode;
  bool sent;
  DateTime date;
  HomeNotification({
    required this.id,
    required this.text,
    required this.orgCode,
    required this.sent,
    required this.date,
  });


  HomeNotification.fromJson(Map<String, dynamic> json)
      : this(
    id: json['id'],
    text: json['text'],
    orgCode: json['orgCode'],
    sent: json['sent'],
    date: json['date'] != null
        ? (json['date'] as Timestamp).toDate()
        : DateTime.now(),
  );


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "orgCode": orgCode,
      "sent": sent,
      "date": Timestamp.fromDate(date),
    };
  }
}
