import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../controller/lifeguardController.dart';
import '../../controller/lifeguardNotificationController.dart';
import '../../model/notification.dart';
import 'lifeguardNotificationView.dart';

class BuildList extends StatefulWidget {
  const BuildList({super.key});

  @override
  _BuildListState createState() => _BuildListState();
}

class _BuildListState extends State<BuildList> {
  LifeguardNotificationController LFN = LifeguardNotificationController();
  late Stream<List<LifeguardNotification>> val;

  @override
  void initState() {
    super.initState();

    // Initialize the stream with an empty stream
    val = Stream<List<LifeguardNotification>>.empty();

    // Fetch the real data
    LFN.fetchLifeguardReports().then((_) {
      // Assign the real stream once the data is fetched
      setState(() {
        val = LFN.lifeguardNotificationStream!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<LifeguardNotification>>.value(
      value: val,
      initialData: [],
      child: ChangeNotifierProvider<LifeguardProvider>(
        create: (_) => LifeguardProvider(),
        child: LifeguardNotify(LFN: LFN),
      ),
    );
  }
}
