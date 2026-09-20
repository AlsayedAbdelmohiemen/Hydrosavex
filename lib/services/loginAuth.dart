import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/organizationManagerController.dart';
import 'package:hydrosavex/view/home_view/HomeScreen.dart';
import 'package:hydrosavex/view/authentication/loginView.dart';
import 'package:provider/provider.dart';
import '../view/lifeguard/build_list.dart';
import '../view/madical/build_report_list.dart';
import '../view/organization/build_daily_report_list.dart';

class AuthFormLogin extends StatefulWidget {
  const AuthFormLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return AuthFormLoginState();
  }
}

class AuthFormLoginState extends State<AuthFormLogin> {
  final _auth = FirebaseAuth.instance;
  late UserCredential _authResult;
  bool _isLoading = false;
  var userRole;
  var deleted;

  void _submitAuthForm_signin(
      String email, String password, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });

      _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseFirestore.instance
          .collection("users")
          .doc(_authResult.user!.uid)
          .snapshots()
          .listen((event) {
        userRole = event.get("role");

        // Check if the 'deleted' field exists before accessing it
        if (event.data() != null && event.data()!.containsKey('deleted')) {
          deleted = event.get("deleted");
        } else {
          deleted = 0; // Default value if 'deleted' field is not found
        }

        if (deleted == 1) {
          // Account is marked as deleted
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Not Found Account"),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ));
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (userRole == "organisationManager") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<OrganizationManagerProvider>(
                        create: (_) => OrganizationManagerProvider(),
                        child: BuildDailyReportList('lifeguard'))),
            (Route<dynamic> route) => false, // remove back arrow
          );
        } else if (userRole == "lifeguard" && deleted == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BuildList()),
            (Route<dynamic> route) => false, // remove back arrow
          );
        } else if (userRole == "medic" && deleted == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BuildReportList()),
            (Route<dynamic> route) => false, // remove back arrow
          );
        } else if (userRole == "home" && deleted == 0) {
          // New logic for "home" users
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(), // Replace with your home screen widget
            ),
            (Route<dynamic> route) => false, // remove back arrow
          );
        } else {
          // Role not recognized or other conditions not met
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Not Found Account"),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ));
          setState(() {
            _isLoading = false;
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
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

  Color c1 = const Color.fromRGBO(
      110, 204, 234, 1.0); // fully transparent white (invisible)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Login(_submitAuthForm_signin, _isLoading),
    );
  }
}
