import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../controller/lifeguardReportController.dart';
import '../../controller/medicalReportController.dart';
import '../../controller/organizationManagerController.dart';
import '../../model/lifeguardReport.dart';
import '../../model/medicReport.dart';
import 'orgainsationDailyreportView.dart';

class BuildDailyReportList extends StatefulWidget {
  final String role;

  const BuildDailyReportList(this.role, {super.key});

  @override
  _BuildDailyReportListState createState() => _BuildDailyReportListState(role);
}

class _BuildDailyReportListState extends State<BuildDailyReportList> {
  final String role;
  final MedicReportController medicController = MedicReportController();
  final LifeguardReportController lifeguardController =
      LifeguardReportController();
  Stream<List<MedicReport>>? medicReports;
  Stream<List<LifeguardReport>>? lifeguardReports;

  _BuildDailyReportListState(this.role);

  @override
  void initState() {
    super.initState();
    if (role == 'lifeguard') {
      lifeguardController.fetchLifeguardReports().then((_) {
        setState(() {
          lifeguardReports = lifeguardController.lifeguardReports;
        });
      });
    } else if (role == 'medic') {
      medicController.fetchMedicReports().then((_) {
        setState(() {
          medicReports = medicController.medicReports;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrganizationManagerProvider>(
      create: (_) => OrganizationManagerProvider(),
      child: Builder(
        builder: (context) {
          if (role == 'lifeguard') {
            return StreamProvider<List<LifeguardReport>>.value(
              value: lifeguardReports,
              initialData: const [],
              child: DailyReport('lifeguard'),
            );
          } else if (role == 'medic') {
            return StreamProvider<List<MedicReport>>.value(
              value: medicReports,
              initialData: const [],
              child: DailyReport('medic'),
            );
          } else {
            return Center(child: Text("invalid_role"));
          }
        },
      ),
    );
  }
}
