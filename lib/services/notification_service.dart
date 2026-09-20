import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  static const String channelId = 'drowning_channel';
  static const String channelName = 'Drowning Alerts';
  static const String channelDescription =
      'Critical drowning detection and emergency alerts';

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alarm'),
    enableVibration: true,
  );

  Future<void> initialize() async {
    // 1. Request FCM permissions
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    // 2. Setup Local Notifications & Android Notification Channel
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        stopAlarm();
      },
    );

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(channel);
        await androidPlugin.requestNotificationsPermission();
      }
    }

    // 3. Configure foreground presentation options
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 4. Set background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 5. Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('Foreground message received: ${message.notification?.title}');
      }

      // Play the alarm sound immediately in foreground
      await playAlarm();

      // Display heads-up notification
      final notification = message.notification;
      if (notification != null) {
        showNotification(
          title: notification.title ?? 'Drowning Alert',
          body: notification.body ?? 'Emergency detected!',
        );
      }
    });

    // 6. Handle notification click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      stopAlarm();
    });
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('alarm'),
      enableVibration: true,
      fullScreenIntent: true,
    );

    final NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
    );
  }

  Future<void> playAlarm() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('Sounds/alarm.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing alarm audio: $e');
      }
    }
  }

  Future<void> stopAlarm() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping alarm audio: $e');
      }
    }
  }
}
