import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrosavex/l10n/app_localizations.dart' show AppLocalizations;
import 'package:hydrosavex/services/signupAuth.dart';
import 'package:hydrosavex/utils/constants/colors.dart';
import 'package:hydrosavex/utils/helpers/custom_loading.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';
import 'package:hydrosavex/view/authentication/forget_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final void Function(String email, String password, BuildContext ctx) submitFn;
  final bool _isLoading;

  const Login(this.submitFn, this._isLoading, {super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _savedDataUsername = "";
  String _savedDataPassword = "";
  bool _isHidden = true;
  bool _rememberMe = false; // Track the "Remember me" checkbox state

  final _usernameField = TextEditingController();
  final _passwordField = TextEditingController();

  @override
  void initState() {
    _loadSavedData();
    super.initState();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _savedDataUsername = sharedPreferences.getString('username') ?? "";
      _savedDataPassword = sharedPreferences.getString('password') ?? "";
      _rememberMe = sharedPreferences.getBool('rememberMe') ?? false;

      // Autofill the fields only if "Remember me" was checked
      if (_rememberMe) {
        _usernameField.text = _savedDataUsername;
        _passwordField.text = _savedDataPassword;
      }
    });
  }

  Future<void> _saveData(
      String username, String password, bool rememberMe) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (rememberMe) {
      // Save username, password, and the rememberMe state
      await sharedPreferences.setString('username', username);
      await sharedPreferences.setString('password', password);
    } else {
      // Clear saved data if "Remember me" is unchecked
      await sharedPreferences.remove('username');
      await sharedPreferences.remove('password');
    }
    await sharedPreferences.setBool('rememberMe', rememberMe);
  }

  void _sendResetLink(String email, BuildContext ctx) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(ctx)!.reset_link_sent),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(ctx)!.error_occurred),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.sign_in,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1980B8),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),

                  // Email Field with label above it
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.email,
                        style: TextStyle(
                          color: Color(0xFF1980B8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameField,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!
                                .please_enter_email;
                          }
                          if (!value.contains('@') || !value.contains('.com')) {
                            return AppLocalizations.of(context)!.invalid_email;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Your Email',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: dark ? SColors.dark : Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 15.0),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Color(0xFF1980B8),
                              width: 1.5,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: dark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Password Field with label above it
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.password,
                        style: TextStyle(
                          color: Color(0xFF1980B8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordField,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!
                                .please_enter_password;
                          }
                          return null;
                        },
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Password',
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          filled: true,
                          fillColor: dark ? SColors.dark : Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 15.0),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Color(0xFF1980B8),
                              width: 1.5,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isHidden = !_isHidden;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: dark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            checkColor: Colors.white,
                            activeColor: Color(0xFF1980B8),
                            onChanged: (newValue) {
                              setState(() {
                                _rememberMe = newValue!;
                              });
                            },
                          ),
                          Text(
                            AppLocalizations.of(context)!.remember_me,
                            style: TextStyle(
                              color: dark ? SColors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ForgetPassword(_sendResetLink, false),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forget_password,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  widget._isLoading
                      ? CustomLoading()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.submitFn(
                                _usernameField.text.trim(),
                                _passwordField.text.trim(),
                                context,
                              );
                              _saveData(_usernameField.text,
                                  _passwordField.text, _rememberMe);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: Color(0xFF1980B8),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthForm()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: AppLocalizations.of(context)!.no_account,
                        style: TextStyle(
                          color: dark ? SColors.white : Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: AppLocalizations.of(context)!.sign_up,
                            style: TextStyle(
                              color: Color(0xFF1980B8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
