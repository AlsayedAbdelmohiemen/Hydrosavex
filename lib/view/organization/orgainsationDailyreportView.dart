import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/organizationManagerController.dart';
import 'package:hydrosavex/database/firebase.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/model/OrganisationManager.dart';
import 'package:hydrosavex/model/lifeguardReport.dart';
import 'package:hydrosavex/model/medicReport.dart';
import 'package:hydrosavex/services/notification_service.dart';
import 'package:hydrosavex/view/drawer/appMenuView.dart';
import 'package:provider/provider.dart';
import 'widgets/organization_empty_state.dart';
import 'widgets/organization_report_bottom_bar.dart';
import 'widgets/organization_report_item.dart';

class DailyReport extends StatefulWidget {
  final String role;

  const DailyReport(this.role, {super.key});

  @override
  _DailyReportState createState() => _DailyReportState(role);
}

class _DailyReportState extends State<DailyReport> {
  final String role;
  List<OrganisationManager> orgManagers = [];
  bool isLoading = true;
  int userIndex = -1;
  String? currentOrgCode;
  StreamSubscription<DocumentSnapshot>? _userSub;
  final Set<String> _knownReportIds = {};
  bool _isInitialLoadDone = false;

  _DailyReportState(this.role);

  @override
  void initState() {
    super.initState();
    _listenToUserData();
    Provider.of<OrganizationManagerProvider>(context, listen: false)
        .fetchData()
        .then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
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
              isLoading = false;
            });
          }
        }
      }, onError: (e) {
        if (mounted) setState(() => isLoading = false);
      });
    } else {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _playWarningSound() async {
    await NotificationService().playAlarm();
  }

  Future<void> _deleteReport(
      String id, String type, GlobalKey<ScaffoldState> key, BuildContext context) async {
    try {
      if (role == "lifeguard") {
        await FirebaseFirestore.instance.collection('lifeguardReports').doc(id).delete();
      } else {
        await FirebaseFirestore.instance.collection('medicreports').doc(id).delete();
        await FirebaseFirestore.instance.collection('medicReports').doc(id).delete();
      }

      if (key.currentContext != null) {
        ScaffoldMessenger.of(key.currentContext!).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.report_deleted),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      if (key.currentContext != null) {
        ScaffoldMessenger.of(key.currentContext!).showSnackBar(SnackBar(
          content: Text('${AppLocalizations.of(context)!.error_deleting_report}: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ));
      }
    }
  }

  Widget _buildReportList(GlobalKey<ScaffoldState> key) {
    final GetFirebase orgCode = GetFirebase();
    List<dynamic> reportList = [];
    List<dynamic> allReports;

    if (role == "lifeguard") {
      allReports = Provider.of<List<LifeguardReport>>(context);
    } else if (role == "medic") {
      allReports = Provider.of<List<MedicReport>>(context);
    } else {
      return const Center(child: Text('Invalid role'));
    }

    orgManagers =
        Provider.of<OrganizationManagerProvider>(context, listen: true)
            .orgManagers;

    userIndex =
        orgManagers.indexWhere((element) => element.id == orgCode.getUserID);

    String resolvedOrgCode = (currentOrgCode ?? '').trim();
    if (resolvedOrgCode.isEmpty && userIndex >= 0 && userIndex < orgManagers.length) {
      resolvedOrgCode = orgManagers[userIndex].orgCode.trim();
    }

    for (var report in allReports) {
      String rOrgId = '';
      try {
        rOrgId = (report.orgId ?? '').toString().trim();
      } catch (_) {}
      if (resolvedOrgCode.isEmpty || rOrgId == resolvedOrgCode) {
        reportList.add(report);
      }
    }

    if (reportList.isNotEmpty) {
      bool hasNewReport = false;
      for (var report in reportList) {
        if (!_knownReportIds.contains(report.id)) {
          _knownReportIds.add(report.id);
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
      return const OrganizationEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        final dynamic report = reportList[i];
        String reportType = '';
        try {
          reportType = report.type ?? '';
        } catch (_) {
          reportType = '';
        }
        return OrganizationReportItem(
          id: report.id,
          type: reportType,
          comment: report.comment ?? '',
          date: report.date ?? Timestamp.now(),
          onDelete: () => _deleteReport(report.id, reportType, key, context),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: reportList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const SideDrawer('organisationManager'),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF0C76B0), size: 27),
        title: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.the_daily_reports,
              style: const TextStyle(
                color: Color(0xFF0C76B0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: _buildReportList(scaffoldKey),
      bottomNavigationBar: OrganizationReportBottomBar(role: role),
    );
  }

  @override
  void dispose() {
    _userSub?.cancel();
    NotificationService().stopAlarm();
    super.dispose();
  }
}
