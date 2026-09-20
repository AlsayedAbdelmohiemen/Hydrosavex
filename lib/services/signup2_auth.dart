import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/organizationManagerController.dart';
import 'package:hydrosavex/view/authentication/create_member.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../view/lifeguard/build_list.dart';
import '../view/madical/build_report_list.dart';
import '../view/organization/build_daily_report_list.dart';

class AuthForm2 extends StatefulWidget {
  const AuthForm2({super.key});

  @override
  State<StatefulWidget> createState() {
    return AuthForm2State();
  }
}

class AuthForm2State extends State<AuthForm2> {
  final _auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  bool _isLoading = false;
  Null profileImage;
  var rng = Random();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  bool codeCheck = true;
  bool usernameCheck = true;
  void submitFn(String orgainsationName, String role, String email,
      String password, BuildContext ctx,
      [String? organisationCode, String? username]) async {
    var codeId = rng.nextInt(10000);
    var genrated = DateTime.now().millisecondsSinceEpoch;
    var fullOrgCode = codeId.toString() + genrated.toString();

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
          'orgainsationName': orgainsationName,
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
          'orgainsationName': orgainsationName,
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChangeNotifierProvider<OrganizationManagerProvider>(
                      create: (_) => OrganizationManagerProvider(),
                      child: BuildDailyReportList('lifeguard'))),
          (Route<dynamic> route) => false, // remove back arrow
        );
      } on FirebaseAuthException catch (e) {
        String message = "error Occured";
        if (e.code == 'weak-password') {
          message = "The password provided is too weak";
        } else if (e.code == 'email-already-in-use') {
          message = "The account already exists for that email";
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

          //String fcmToken = await fbm.getToken();
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'email': email,
            'orgainsationName': orgainsationName,
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
          String message = "error Occured";
          if (e.code == 'weak-password') {
            message = "The password provided is too weak";
          } else if (e.code == 'email-already-in-use') {
            message = "The account already exists for that email";
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
      body: CreateMember(submitFn, _isLoading),
    );
  }
}
