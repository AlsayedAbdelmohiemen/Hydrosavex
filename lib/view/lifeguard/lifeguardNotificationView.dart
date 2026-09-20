import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart' show AppLocalizations;
import 'package:hydrosavex/model/notification.dart';
import 'package:hydrosavex/services/notification_service.dart';
import 'package:hydrosavex/view/drawer/appMenuView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:hydrosavex/controller/lifeguardReportController.dart';
import 'package:hydrosavex/controller/lifeguardNotificationController.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/custom_loading.dart';
import '../../utils/helpers/helper_functions.dart';
import 'widgets/lifeguard_empty_state.dart';
import 'widgets/lifeguard_notification_item.dart';
import 'widgets/lifeguard_report_dialog.dart';

class LifeguardNotify extends StatefulWidget {
  final LifeguardNotificationController LFN;

  const LifeguardNotify({super.key, required this.LFN});

  @override
  _LifeguardNotifyState createState() => _LifeguardNotifyState(LFN: LFN);
}

class _LifeguardNotifyState extends State<LifeguardNotify> {
  final LifeguardNotificationController LFN;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LifeguardReportController LFC = LifeguardReportController();

  String? currentOrgCode;
  bool isSwitched = false;
  bool prog = true;
  StreamSubscription<DocumentSnapshot>? _userSub;
  final DateTime _screenOpenedAt = DateTime.now();
  final Set<String> _knownNotiIds = {};
  bool _isInitialLoadDone = false;

  _LifeguardNotifyState({required this.LFN});

  @override
  void initState() {
    super.initState();
    _listenToUserData();
  }

  void _listenToUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userSub = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && mounted) {
          final data = snapshot.data();
          if (data != null) {
            setState(() {
              currentOrgCode = data['orgCode'] ?? data['orgId'] ?? '';
              isSwitched = data['subscriber'] ?? false;
              prog = false;
            });
          }
        }
      }, onError: (e) {
        if (mounted) setState(() => prog = false);
      });
    } else {
      if (mounted) setState(() => prog = false);
    }
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  Future<void> _playWarningSound() async {
    await NotificationService().playAlarm();
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
        final orgCode = data['orgCode'] ?? data['orgId'] ?? '';
        final role = data['role'] ?? 'lifeguard';

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
      if (mounted) {
        setState(() {
          isSwitched = !value;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "${AppLocalizations.of(context)!.error_activating_notifications} :$e"),
          ),
        );
      }
    }
  }

  Future<void> _showReportDialog({required String id, required bool sent}) {
    return LifeguardReportDialog.show(
      context: context,
      id: id,
      currentOrgCode: currentOrgCode,
      lfc: LFC,
      lfn: LFN,
      scaffoldKey: _scaffoldKey,
    );
  }

  Future<void> _deleteItem(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('lifeguardnotifications')
          .doc(id)
          .delete();

      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.notification_deleted),
        backgroundColor: Colors.green,
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
    final orgList = Provider.of<List<LifeguardNotification>>(context);

    final List<LifeguardNotification> notiList = orgList.where((element) {
      if (currentOrgCode != null && currentOrgCode!.isNotEmpty) {
        return element.orgId.trim() == currentOrgCode!.trim();
      }
      return true;
    }).toList();

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

    if (notiList.isEmpty) {
      return const LifeguardEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        final noti = notiList[i];
        return LifeguardNotificationItem(
          name: noti.text,
          id: noti.id,
          sent: noti.sent,
          date: noti.date,
          onDelete: () => _deleteItem(noti.id),
          onOpenReport: () {
            if (!noti.sent) {
              _showReportDialog(id: noti.id, sent: noti.sent);
            } else {
              ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.report_already_added),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: notiList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return prog
        ? Scaffold(
            body: Container(
              color: dark ? SColors.dark : SColors.primaryBackground,
              child: const Center(child: CustomLoading()),
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            drawer: const SideDrawer('lifeguard'),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Color(0xFF0C76B0), size: 27),
              title: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.lifeguard_notifications,
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showReportDialog(id: "", sent: false);
              },
              backgroundColor: const Color(0xFF0C76B0),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
  }
}
