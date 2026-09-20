import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/organizationManagerController.dart';
import 'package:hydrosavex/view/home_view/HomeScreen.dart';
import 'package:hydrosavex/view/authentication/signupView.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../view/lifeguard/build_list.dart';
import '../view/madical/build_report_list.dart';
import '../view/organization/build_daily_report_list.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return AuthFormState();
  }
}

class AuthFormState extends State<AuthForm> {
  final _auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  bool _isLoading = false;
  Null profileImage;
  var rng = Random();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  bool codeCheck = true;
  bool usernameCheck = true;
  void _submitAuthForm(
    String organisationName,
    String role,
    String email,
    String password,
    BuildContext ctx, [
    String? organisationCode,
    String? username,
  ]) async {
    var codeId = rng.nextInt(10000);
    var generated = DateTime.now().millisecondsSinceEpoch;
    var fullOrgCode = codeId.toString() + generated.toString();

    if (role == "organisationManager") {
      try {
        setState(() {
          _isLoading = true;
        });

        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'organisationName': organisationName,
          'orgCode': fullOrgCode,
          'role': role,
          'profileImage': profileImage,
        });
        firebaseMessaging.subscribeToTopic(fullOrgCode + role);
        print(fullOrgCode + role);

        FirebaseFirestore.instance
            .collection('organisations')
            .doc(fullOrgCode)
            .set({
          'orgCode': fullOrgCode,
          'organisationName': organisationName,
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChangeNotifierProvider<OrganizationManagerProvider>(
                    create: (_) => OrganizationManagerProvider(),
                    child: BuildDailyReportList('lifeguard'),
                  )),
          (Route<dynamic> route) => false, // remove back arrow
        );
      } on FirebaseAuthException catch (e) {
        String message = "An error occurred.";
        if (e.code == 'weak-password') {
          message = "The password provided is too weak.";
        } else if (e.code == 'email-already-in-use') {
          message = "The account already exists for that email.";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ));
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      }
    } else if (role == "home") {
      // Home role logic
      try {
        setState(() {
          _isLoading = true;
        });

        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'organisationName': organisationName,
          'orgCode': fullOrgCode,
          'role': role,
          'profileImage': profileImage,
          'username': username,
        });

        // Subscribe to Firebase topic for push notifications
        firebaseMessaging.subscribeToTopic(fullOrgCode + role);

        // Navigate to the appropriate screen for Home
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen()), // Add your home screen widget here
          (Route<dynamic> route) => false, // remove back arrow
        );
      } on FirebaseAuthException catch (e) {
        String message = "An error occurred.";
        if (e.code == 'weak-password') {
          message = "The password provided is too weak.";
        } else if (e.code == 'email-already-in-use') {
          message = "The account already exists for that email.";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ));
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Logic for other roles (lifeguard, medic, etc.)
      await FirebaseFirestore.instance
          .collection("organisations")
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          if (organisationCode == result["orgCode"]) {
            codeCheck = false;
            break;
          }
        }
      });

      if (codeCheck == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid Code"),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ));
      }

      if (codeCheck == false) {
        try {
          setState(() {
            _isLoading = true;
          });

          userCredential = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'email': email,
            'organisationName': organisationName,
            'orgCode': organisationCode,
            'role': role,
            'profileImage': profileImage,
            'deleted': 0,
            'username': username,
            'subscriber': true
          });

          if (role == "lifeguard") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BuildList()),
              (Route<dynamic> route) => false, // remove back arrow
            );
          }

          if (role == "medic") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BuildReportList()),
              (Route<dynamic> route) => false, // remove back arrow
            );
          }
        } on FirebaseAuthException catch (e) {
          String message = "An error occurred.";
          if (e.code == 'weak-password') {
            message = "The password provided is too weak.";
          } else if (e.code == 'email-already-in-use') {
            message = "The account already exists for that email.";
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ));
          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          print(e);
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Color c1 = const Color.fromRGBO(
      110, 204, 234, 1.0); // fully transparent white (invisible)
  final _formKey = GlobalKey<FormState>();
  static final validCharacters = RegExp(r"^[a-zA-Z]+$");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Signup(_submitAuthForm, _isLoading),
    );
  }
}
