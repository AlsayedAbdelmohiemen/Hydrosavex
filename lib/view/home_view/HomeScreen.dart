import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrosavex/controller/home.dart';
import 'package:hydrosavex/controller/home_notification.dart';
import 'package:hydrosavex/database/firebase.dart';
import 'package:hydrosavex/l10n/app_localizations.dart' show AppLocalizations;
import 'package:hydrosavex/model/notifications_home.dart';
import 'package:hydrosavex/view/drawer/appMenuView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'widgets/home_empty_state.dart';
import 'widgets/home_notification_item.dart';

class HomeNotify extends StatefulWidget {
  final HomeNotificationProvider HNP;

  const HomeNotify({super.key, required this.HNP});

  @override
  _HomeNotifyState createState() => _HomeNotifyState(HNP: HNP);
}

class _HomeNotifyState extends State<HomeNotify> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List? homeList;
  int userIndex = 0;
  bool? isSwitched;
  bool prog = true;
  final HomeNotificationProvider HNP;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DateTime _screenOpenedAt = DateTime.now();
  final Set<String> _knownNotiIds = {};
  bool _isInitialLoadDone = false;

  _HomeNotifyState({required this.HNP});

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).fetchData().then((value) {
      if (mounted) {
        setState(() {
          prog = false;
          updateSwitch();
        });
      }
    });
  }

  void updateSwitch() {
    if (homeList != null && userIndex >= 0 && userIndex < homeList!.length) {
      setState(() {
        isSwitched = homeList![userIndex].switcher;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

  Future<void> _playWarningSound() async {
    try {
      await _audioPlayer.play(AssetSource('Sounds/alarm.mp3'));
      await Future.delayed(const Duration(seconds: 10));
      await _audioPlayer.stop();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> toggleSwitch(bool value) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final orgCode = data['orgCode'];
        final role = data['role'];

        if (orgCode == null || role == null) return;

        final topic = '$orgCode$role';
        if (value) {
          await FirebaseMessaging.instance.subscribeToTopic(topic);
        } else {
          await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'subscriber': value});

        if (mounted) {
          setState(() {
            isSwitched = value;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                value
                    ? AppLocalizations.of(context)!
                        .subscription_status_updated_successfully
                    : AppLocalizations.of(context)!.subscription_canceled,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error in toggleSwitch: $e');
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('homenotifications')
          .doc(id)
          .delete();

      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.notification_deleted),
        duration: const Duration(seconds: 2),
      ));
    } catch (e) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(
            '${AppLocalizations.of(context)!.error_deleting_notification}: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Widget _buildChatList() {
    List<HomeNotification> notiList = [];
    final orgList = Provider.of<List<HomeNotification>>(context);

    if (homeList != null && userIndex >= 0 && userIndex < homeList!.length) {
      for (var element in orgList) {
        if (element.orgCode == homeList![userIndex].orgCode) {
          notiList.add(element);
        }
      }

      bool hasNewNoti = false;
      for (var element in notiList) {
        if (!_knownNotiIds.contains(element.id)) {
          _knownNotiIds.add(element.id);
          if (_isInitialLoadDone) {
            if (element.date
                .isAfter(_screenOpenedAt.subtract(const Duration(seconds: 5)))) {
              hasNewNoti = true;
            }
          }
        }
      }
      _isInitialLoadDone = true;

      if (hasNewNoti) {
        _playWarningSound();
      }
    }

    if (notiList.isEmpty) {
      return const HomeEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        final noti = notiList[i];
        return HomeNotificationItem(
          name: noti.text,
          id: noti.id,
          sent: noti.sent,
          date: noti.date,
          onDelete: () => _deleteItem(noti.id),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: notiList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    homeList = Provider.of<HomeProvider>(context, listen: true).homes;
    userIndex = homeList!
        .indexWhere((element) => GetFirebase().getUserID == element.id);

    updateSwitch();

    return prog
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            key: _scaffoldKey,
            drawer: const SideDrawer('home'),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Color(0xFF0C76B0), size: 27),
              title: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.home_notifications,
                    style: const TextStyle(
                      color: Color(0xFF0C76B0),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            body: _buildChatList(),
          );
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<HomeNotification>> homeNotificationStream;
  late HomeNotificationProvider HNP;

  @override
  void initState() {
    super.initState();
    homeNotificationStream = Stream<List<HomeNotification>>.empty();
    HNP = HomeNotificationProvider();
    setState(() {
      homeNotificationStream = HNP.homeNotificationStream!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<HomeNotification>>.value(
      value: homeNotificationStream,
      initialData: const [],
      child: ChangeNotifierProvider<HomeProvider>(
        create: (_) => HomeProvider(),
        child: HomeNotify(HNP: HNP),
      ),
    );
  }
}
