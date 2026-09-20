import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/lifeguardReportController.dart';
import 'package:hydrosavex/controller/medicalReportController.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class MedicalReportDialog extends StatefulWidget {
  final String id;
  final String name;
  final String type;
  final String orgCode;
  final LifeguardReportController lfc;
  final MedicReportController mrc;

  const MedicalReportDialog({
    super.key,
    required this.id,
    required this.name,
    required this.type,
    required this.orgCode,
    required this.lfc,
    required this.mrc,
  });

  static Future<void> show({
    required BuildContext context,
    required String id,
    required String name,
    required String type,
    required String orgCode,
    required LifeguardReportController lfc,
    required MedicReportController mrc,
  }) {
    return showDialog(
      context: context,
      builder: (context) => MedicalReportDialog(
        id: id,
        name: name,
        type: type,
        orgCode: orgCode,
        lfc: lfc,
        mrc: mrc,
      ),
    );
  }

  @override
  State<MedicalReportDialog> createState() => _MedicalReportDialogState();
}

class _MedicalReportDialogState extends State<MedicalReportDialog> {
  final TextEditingController _commentField = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      body: AlertDialog(
        backgroundColor: dark ? SColors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 550
                ? 550
                : MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.status,
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.type,
                        style: const TextStyle(
                          color: Color(0xFF0C76B0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.lifeguard_notes} ",
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          color: Color(0xFF0C76B0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _commentField,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_your_comment;
                      }
                      return null;
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.medic_notes,
                      icon: const Icon(Icons.comment, color: Color(0xFF1980B8)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Color(0xFF1980B8),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.mrc.addMedicReport(
                          id: widget.id,
                          comment: _commentField.text,
                          orgId: widget.orgCode,
                          type: '',
                          sent: true,
                        );
                        widget.lfc.updateSent(widget.id);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF1980B8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.send,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
