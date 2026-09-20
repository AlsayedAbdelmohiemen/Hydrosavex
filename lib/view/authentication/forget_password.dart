import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hydrosavex/l10n/app_localizations.dart' show AppLocalizations;
import 'package:hydrosavex/utils/constants/colors.dart';
import 'package:hydrosavex/utils/helpers/custom_loading.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';

class ForgetPassword extends StatefulWidget {
  final void Function(String email, BuildContext ctx) submitFn;
  final bool _isLoading;

  const ForgetPassword(this.submitFn, this._isLoading, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ForgetPasswordState();
  }
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _sendResetLink(String email, BuildContext ctx) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.reset_link_sent),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error_occurred),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                  color: Color(0xFF1980B8),
                  width: 1.8,
                ),
              ),
              child: Center(
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
        title: SizedBox.shrink(), // Empty title to center the leading button
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Lottie Animation at the top
                  Center(
                    child: Lottie.asset(
                      'assets/animation/Animation - 1725306528042.json',
                      width: 250,
                      height: 250,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 20),
            
                  // Title for Forgot Password
                  Text(
                    AppLocalizations.of(context)!.forgot_password1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF1980B8),
                    ),
                  ),
                  SizedBox(height: 10),
            
                  // Subtitle for instructions
                  Text(
                    AppLocalizations.of(context)!.enter_email_verification,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),
            
                  // Email input field

                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.email,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1980B8),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.please_enter_email;
                          }
                          if (!value.contains('@') || !value.contains('.com')) {
                            return AppLocalizations.of(context)!.invalid_email;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.please_enter_email,
                          hintStyle: TextStyle(
                              color:  Colors.grey.shade700),
                          filled: true,
                          fillColor: dark ? SColors.dark : Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
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
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
            
                  // Verify Button
                  widget._isLoading
                      ?CustomLoading()
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.submitFn(
                            _emailController.text.trim(),
                            context,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        backgroundColor: Color(0xFF1980B8),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.verify,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
