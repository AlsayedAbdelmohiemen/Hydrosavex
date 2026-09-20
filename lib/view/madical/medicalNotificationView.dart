import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart' show AppLocalizations;
import 'package:hydrosavex/services/notification_service.dart';
import 'package:hydrosavex/utils/constants/colors.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';
import 'package:hydrosavex/view/drawer/appMenuView.dart';
import 'package:provider/provider.dart';
import 'package:hydrosavex/controller/lifeguardReportController.dart';
import 'package:hydrosavex/model/lifeguardReport.dart';
import 'package:hydrosavex/controller/medicalReportController.dart';
import 'package:hydrosavex/controller/medicController.dart';
import 'package:hydrosavex/database/firebase.dart';
import '../../utils/helpers/custom_loading.dart';
import 'widgets/medical_empty_state.dart';
import 'widgets/medical_notification_item.dart';
import 'widgets/medical_report_dialog.dart';

class MedicNotifyPage extends StatefulWidget {
  final LifeguardReportController LFC;

  const MedicNotifyPage({super.key, required this.LFC});

  @override
  _MedicNotifyPageState createState() => _MedicNotifyPageState(LFC: LFC);
}

class _MedicNotifyPageState extends State<MedicNotifyPage> {
  late List<dynamic> medicList;
  int userIndex = -1;
  String? currentOrgCode;
  StreamSubscription<DocumentSnapshot>? _userSub;
  bool prog = true;
  final LifeguardReportController LFC;
  final MedicReportController MRC = MedicReportController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Set<String> _knownReportIds = {};
  bool _isInitialLoadDone = false;

  _MedicNotifyPageState({required this.LFC});

  @override
  void initState() {
    super.initState();
    _listenToUserData();
    Provider.of<MedicProvider>(context, listen: false)
        .fetchData()
        .then((value) {
      if (mounted) {
        setState(() {
          prog = false;
        });
      }
    });
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
              currentOrgCode = (data['orgCode'] ?? data['orgId'] ?? '').toString();
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

  Future<void> _playWarningSound() async {
    await NotificationService().playAlarm();
  }

  void _showReportDialog(String id, String name, String type) {
    String resolvedOrgCode = currentOrgCode ?? '';
    if (resolvedOrgCode.isEmpty && userIndex >= 0 && userIndex < medicList.length) {
      resolvedOrgCode = medicList[userIndex].orgCode ?? '';
    }
    MedicalReportDialog.show(
      context: context,
      id: id,
      name: name,
      type: type,
      orgCode: resolvedOrgCode,
      lfc: LFC,
      mrc: MRC,
    );
  }

  Future<void> _deleteItem(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('lifeguardReports')
          .doc(id)
          .delete();

      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.report_deleted),
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
    final List<LifeguardReport> reportList = [];
    final List<LifeguardReport> orgList =
        Provider.of<List<LifeguardReport>>(context);

    String resolvedOrgCode = (currentOrgCode ?? '').trim();
    if (resolvedOrgCode.isEmpty && userIndex >= 0 && userIndex < medicList.length) {
      resolvedOrgCode = (medicList[userIndex].orgCode ?? '').toString().trim();
    }

    if (orgList.isNotEmpty) {
      for (var element in orgList) {
        if (resolvedOrgCode.isEmpty || element.orgId.trim() == resolvedOrgCode) {
          reportList.add(element);
        }
      }

      bool hasNewReport = false;
      for (var element in reportList) {
        if (!_knownReportIds.contains(element.id)) {
          _knownReportIds.add(element.id);
          if (_isInitialLoadDone) {
            hasNewReport = true;
          }
        }
      }
      _isInitialLoadDone = true;

      if (hasNewReport) {
        _playWarningSound();
      }
    }

    if (reportList.isEmpty) {
      return const MedicalEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        final report = reportList[i];
        return MedicalNotificationItem(
          name: report.comment,
          id: report.id,
          sent: report.sent,
          type: report.type,
          date: report.date.toDate(),
          onDelete: () => _deleteItem(report.id),
          onOpenReport: () {
            if (!report.sent) {
              _showReportDialog(report.id, report.comment, report.type);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!
                    .report_already_added_for_this_case),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ));
            }
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: reportList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    medicList = Provider.of<MedicProvider>(context, listen: true).medic;
    userIndex = medicList
        .indexWhere((element) => element.id == GetFirebase().getUserID);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideDrawer('medic'),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF0C76B0), size: 27),
        title: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.medic_notifications,
              style: const TextStyle(
                color: Color(0xFF0C76B0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: prog
          ? Scaffold(
              body: Container(
                color: dark ? SColors.dark : SColors.primaryBackground,
                child: const Center(child: CustomLoading()),
              ),
            )
          : _buildChatList(),
    );
  }

  @override
  void dispose() {
    _userSub?.cancel();
    NotificationService().stopAlarm();
    super.dispose();
  }
}
