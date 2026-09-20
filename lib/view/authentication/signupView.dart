import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart' show AppLocalizations;
import 'package:hydrosavex/utils/constants/colors.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';
import 'widgets/auth_dropdown_field.dart';
import 'widgets/auth_submit_button.dart';
import 'widgets/auth_text_field.dart';

class Signup extends StatefulWidget {
  final void Function(
      String organisationName,
      String role,
      String email,
      String password,
      BuildContext ctx,
      String organisationCode,
      String username) submitFn;
  final bool _isLoading;

  const Signup(this.submitFn, this._isLoading, {super.key});

  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _organisationName = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final employeesUsername = TextEditingController();

  String role = "organisationManager";
  final orgId = TextEditingController();

  static final validCharacters = RegExp(r"^[a-zA-Z]+$");
  bool visible_manager = true;
  bool visible_others = false;

  final List<String> _locations = [
    'Organisation Manager',
    'Home',
  ];
  String _selectedLocation = "Organisation Manager";

  @override
  void dispose() {
    _email.dispose();
    _organisationName.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    employeesUsername.dispose();
    orgId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return Scaffold(
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
        title: Text(
          AppLocalizations.of(context)!.sign_up,
          style: const TextStyle(
            color: Color(0xFF1980B8),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              AuthDropdownField(
                label: AppLocalizations.of(context)!.job,
                value: _selectedLocation,
                items: _locations,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                    role = newValue == 'Organisation Manager'
                        ? 'organisationManager'
                        : 'home';
                    visible_manager = role == 'organisationManager';
                    visible_others = !visible_manager;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (visible_manager) ...[
                AuthTextField(
                  label: AppLocalizations.of(context)!.organisation_name,
                  hintText:
                      AppLocalizations.of(context)!.please_enter_organisation_name,
                  controller: _organisationName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .please_enter_organisation_name;
                    }
                    if (value.length < 3 || value.length > 18) {
                      return AppLocalizations.of(context)!
                          .organisation_name_length;
                    }
                    if (!validCharacters.hasMatch(value)) {
                      return AppLocalizations.of(context)!
                          .organisation_name_alphabets_only;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
              if (visible_others) ...[
                AuthTextField(
                  label: AppLocalizations.of(context)!.username,
                  hintText: AppLocalizations.of(context)!.please_enter_username,
                  controller: employeesUsername,
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
                      return AppLocalizations.of(context)!
                          .username_alphabets_only;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
              AuthTextField(
                label: AppLocalizations.of(context)!.email,
                hintText: AppLocalizations.of(context)!.please_enter_email,
                controller: _email,
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
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_confirm_password;
                  }
                  if (value != _password.text) {
                    return AppLocalizations.of(context)!.passwords_do_not_match;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              AuthSubmitButton(
                text: AppLocalizations.of(context)!.sign_up,
                isLoading: widget._isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.submitFn(
                      _organisationName.text.trim(),
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
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: AppLocalizations.of(context)!.already_have_account,
                      style: TextStyle(
                        color: dark ? SColors.white : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context)!.login,
                          style: const TextStyle(
                            color: Color(0xFF1980B8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
