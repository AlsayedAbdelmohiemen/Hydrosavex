import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import '../database/firebase_service_account.dart';

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAcountJson = FirebaseServiceAccountConfig.credentials;
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAcountJson), scopes);
    // get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAcountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotificationToAdmin(
    String deviceToken,
    BuildContext context,
    String tripId,
    String messageSender,
    String messageBody,
  ) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endPointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/drowning-detection-main/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {'title': messageSender, 'body': messageBody},
        'data': {
          'tripId': tripId,
        },
        'android': {
          'priority': 'high',
          'notification': {
            'channel_id': 'drowning_channel',
            'sound': 'alarm',
            'default_vibrate_timings': true,
          }
        }
      }
    };

    final http.Response response =
        await http.post(Uri.parse(endPointFirebaseCloudMessaging),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $serverAccessTokenKey'
            },
            body: jsonEncode(message));
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Send notification failed: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<void> sendNotificationToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final String serverAccessTokenKey = await getAccessToken();
      String endPointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/drowning-detection-main/messages:send';

      final Map<String, dynamic> message = {
        'message': {
          'topic': topic,
          'notification': {'title': title, 'body': body},
          'data': data ?? {},
          'android': {
            'priority': 'high',
            'notification': {
              'channel_id': 'drowning_channel',
              'sound': 'alarm',
              'default_vibrate_timings': true,
            }
          }
        }
      };

      final http.Response response = await http.post(
        Uri.parse(endPointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey'
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('Topic notification sent successfully to $topic');
      } else {
        print('Send topic notification failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error sending topic notification: $e');
    }
  }
}
