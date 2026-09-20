import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/lifeguardNotificationController.dart';
import 'package:hydrosavex/controller/lifeguardReportController.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class LifeguardReportDialog extends StatefulWidget {
  final String id;
  final String? currentOrgCode;
  final LifeguardReportController lfc;
  final LifeguardNotificationController lfn;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const LifeguardReportDialog({
    super.key,
    required this.id,
    required this.currentOrgCode,
    required this.lfc,
    required this.lfn,
    required this.scaffoldKey,
  });

  static Future<void> show({
    required BuildContext context,
    required String id,
    required String? currentOrgCode,
    required LifeguardReportController lfc,
    required LifeguardNotificationController lfn,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    return showDialog(
      context: scaffoldKey.currentContext!,
      builder: (context) => LifeguardReportDialog(
        id: id,
        currentOrgCode: currentOrgCode,
        lfc: lfc,
        lfn: lfn,
        scaffoldKey: scaffoldKey,
      ),
    );
  }

  @override
  State<LifeguardReportDialog> createState() => _LifeguardReportDialogState();
}

class _LifeguardReportDialogState extends State<LifeguardReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _commentField = TextEditingController();
  String _selectedType = "";

  @override
  void dispose() {
    _commentField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.send_a_report,
          style: const TextStyle(fontSize: 20.0, color: Color(0xFF0C76B0)),
        ),
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Transform.scale(
            scale: 0.7,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1980B8),
                  width: 1.8,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF1980B8),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: AlertDialog(
            backgroundColor: dark ? SColors.black : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Container(
              color: dark ? SColors.black : Colors.white,
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.choose_the_drowning_status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dark ? SColors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'False Alarm';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'False Alarm'
                                ? const Color(0xFF1980B8)
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: dark ? Colors.black : Colors.white,
                          ),
                          child: const Text(
                            'False Alarm',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'CPR';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'CPR'
                                ? const Color(0xFF1980B8)
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Need CPR',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'Get Ambulance';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'Get Ambulance'
                                ? const Color(0xFF1980B8)
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Ambulance',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.local_hospital_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _commentField,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.enter_your_comment;
                              }
                              if (_selectedType.isEmpty) {
                                return AppLocalizations.of(context)!.choose_a_type;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.comment,
                              icon: const Icon(Icons.comment),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final docRef = await widget.lfc.addLifeguardReport(
                                    type: _selectedType,
                                    comment: _commentField.text,
                                    orgId: widget.currentOrgCode ?? '',
                                  );

                                  if (docRef != null && widget.id.isNotEmpty) {
                                    await widget.lfn.updateSent(docRef.id);
                                  }

                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  print('Error: $e');
                                  ScaffoldMessenger.of(widget.scaffoldKey.currentContext!).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(context)!.error_occurred2),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              backgroundColor: const Color(0xFF1980B8),
                            ),
                            child: Text(AppLocalizations.of(context)!.send),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
