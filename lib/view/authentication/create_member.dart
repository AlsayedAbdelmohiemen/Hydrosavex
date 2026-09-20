import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'widgets/auth_dropdown_field.dart';
import 'widgets/auth_submit_button.dart';
import 'widgets/auth_text_field.dart';

class CreateMember extends StatefulWidget {
  final void Function(
      String organisationName,
      String role,
      String email,
      String password,
      BuildContext ctx,
      String organisationCode,
      String username) submitFn;
  final bool _isLoading;

  const CreateMember(this.submitFn, this._isLoading, {super.key});

  @override
  State<StatefulWidget> createState() {
    return CreateMemberState();
  }
}

class CreateMemberState extends State<CreateMember> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final orgId = TextEditingController();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final employeesUsername = TextEditingController();

  static final validCharacters = RegExp(r"^[a-zA-Z]+$");
  final List<String> _locations = ['Lifeguard', 'Medical Team member'];
  String _selectedLocation = 'Lifeguard';
  String role = "lifeguard";

  static const Color _themeBlue = Color(0xFF0C76B0);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    orgId.dispose();
    employeesUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
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
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.create_member,
          style: const TextStyle(
            color: _themeBlue,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              AuthDropdownField(
                label: AppLocalizations.of(context)!.job,
                value: _selectedLocation,
                items: _locations,
                labelColor: _themeBlue,
                onChanged: (newValue) {
                  setState(() {
                    role = newValue == 'Lifeguard' ? "lifeguard" : "medic";
                    _selectedLocation = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: AppLocalizations.of(context)!.email,
                hintText: AppLocalizations.of(context)!.please_enter_email,
                controller: _email,
                labelColor: _themeBlue,
                elevation: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_enter_email;
                  }
                  if (!value.contains('@') || !value.contains('.com')) {
                    return AppLocalizations.of(context)!.invalid_email;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: AppLocalizations.of(context)!.password,
                hintText: AppLocalizations.of(context)!.please_enter_password,
                controller: _password,
                labelColor: _themeBlue,
                elevation: 5,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_enter_password;
                  }
                  if (value.length < 6) {
                    return AppLocalizations.of(context)!.password_too_short;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: AppLocalizations.of(context)!.confirm_password,
                hintText: AppLocalizations.of(context)!.confirm_your_password,
                controller: _confirmPassword,
                labelColor: _themeBlue,
                elevation: 5,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_confirm_password;
                  }
                  if (_password.text != value) {
                    return AppLocalizations.of(context)!.passwords_do_not_match;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: AppLocalizations.of(context)!.username,
                hintText: AppLocalizations.of(context)!.please_enter_username,
                controller: employeesUsername,
                labelColor: _themeBlue,
                elevation: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_enter_username;
                  }
                  if (value.length < 3) {
                    return AppLocalizations.of(context)!.username_too_short;
                  }
                  if (value.length > 18) {
                    return AppLocalizations.of(context)!.username_too_long;
                  }
                  if (!validCharacters.hasMatch(value)) {
                    return AppLocalizations.of(context)!.username_alphabets_only;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: AppLocalizations.of(context)!.organisation_id,
                hintText:
                    AppLocalizations.of(context)!.please_enter_organisation_id,
                controller: orgId,
                labelColor: _themeBlue,
                elevation: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .please_enter_organisation_id;
                  }
                  if (value.length < 3) {
                    return AppLocalizations.of(context)!
                        .organisation_id_too_short;
                  }
                  if (value.length > 35) {
                    return AppLocalizations.of(context)!
                        .organisation_id_too_long;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              AuthSubmitButton(
                text: AppLocalizations.of(context)!.create_member,
                isLoading: widget._isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.submitFn(
                      orgId.text.trim(),
                      role,
                      _email.text.trim(),
                      _password.text.trim(),
                      context,
                      orgId.text.trim(),
                      employeesUsername.text.trim(),
                    );
                    firebaseMessaging
                        .subscribeToTopic(orgId.text.trim() + role);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
