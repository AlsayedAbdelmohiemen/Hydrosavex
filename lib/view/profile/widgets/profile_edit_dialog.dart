import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';

class ProfileEditDialog extends StatefulWidget {
  final String type;
  final String initialValue;
  final ValueChanged<String> onSubmitted;

  const ProfileEditDialog({
    super.key,
    required this.type,
    required this.initialValue,
    required this.onSubmitted,
  });

  static Future<void> show({
    required BuildContext context,
    required String type,
    required String initialValue,
    required ValueChanged<String> onSubmitted,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ProfileEditDialog(
        type: type,
        initialValue: initialValue,
        onSubmitted: onSubmitted,
      ),
    );
  }

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        " ${widget.type}",
        style: const TextStyle(
          color: Color(0xFF1980B8),
        ),
      ),
      content: SizedBox(
        height: 200,
        width: 350,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (widget.type == "Name" || widget.type == "Organization Name") {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .please_enter_organisation_name;
                    }
                    if (value.length < 3 || value.length > 18) {
                      return AppLocalizations.of(context)!
                          .organisation_name_length;
                    }
                    if (!RegExp(r"^(?:.*[a-zA-Z].*){3}").hasMatch(value)) {
                      return AppLocalizations.of(context)!
                          .organisation_name_alphabets_only;
                    }
                    return null;
                  }
                  return null;
                },
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF1980B8),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1980B8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.submit),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onSubmitted(_controller.text);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
