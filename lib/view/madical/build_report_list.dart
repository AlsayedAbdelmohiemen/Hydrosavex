import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../controller/lifeguardReportController.dart';
import '../../controller/medicController.dart';
import '../../model/lifeguardReport.dart';
import 'medicalNotificationView.dart';

class BuildReportList extends StatefulWidget {
  const BuildReportList({super.key});

  @override
  _BuildReportListState createState() => _BuildReportListState();
}

class _BuildReportListState extends State<BuildReportList> {
  LifeguardReportController LFC = LifeguardReportController();
  Stream<List<LifeguardReport>> val = Stream<List<LifeguardReport>>.empty();

  @override
  void initState() {
    super.initState();
    LFC.fetchLifeguardReports().then((value) {
      setState(() {
        val = LFC.lifeguardReports;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<LifeguardReport>>.value(
      value: val,
      initialData: [],
      child: ChangeNotifierProvider<MedicProvider>(
        create: (_) => MedicProvider(),
        child: MedicNotifyPage(LFC: LFC),
      ),
    );
  }
}
