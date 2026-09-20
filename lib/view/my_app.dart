import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/organizationManagerController.dart';
import 'package:hydrosavex/services/loginAuth.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';
import 'package:hydrosavex/view/home_view/HomeScreen.dart';

import 'package:provider/provider.dart';
import '../utils/constants/colors.dart';
import '../utils/helpers/custom_loading.dart';
import 'lifeguard/build_list.dart';
import 'madical/build_report_list.dart';
import 'organization/build_daily_report_list.dart';

class AuthStream extends StatelessWidget {
  static const String routeName = "AuthStream";

  const AuthStream({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Container(
                  color: dark ? SColors.dark : SColors.primaryBackground,
                  child:
                      Center(child: CustomLoading() // Display a loading spinner
                          ))
              // Display a loading spinner
              );
        }

        if (userSnapshot.hasData && userSnapshot.data != null) {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userSnapshot.data!.uid)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Container(
                        color: dark ? SColors.dark : SColors.primaryBackground,
                        child: Center(
                            child: CustomLoading() // Display a loading spinner
                            ))); // Blank screen if loading user data
              }

              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.exists) {
                var userData = snapshot.data!.data() as Map<String, dynamic>?;

                if (userData != null) {
                  var userRole = userData['role'];
                  var deleted =
                      userData.containsKey('deleted') ? userData['deleted'] : 0;

                  if (userRole == "organisationManager") {
                    return ChangeNotifierProvider<OrganizationManagerProvider>(
                      create: (_) => OrganizationManagerProvider(),
                      child: BuildDailyReportList('lifeguard'),
                    );
                  } else if (userRole == "lifeguard" && deleted == 0) {
                    return BuildList();
                  } else if (userRole == "medic" && deleted == 0) {
                    return BuildReportList();
                  } else if (userRole == "home" && deleted == 0) {
                    return HomeScreen(); // Home view for the "home" role
                  } else {
                    return AuthFormLogin();
                  }
                } else {
                  return AuthFormLogin();
                }
              }

              return AuthFormLogin();
            },
          );
        } else {
          return AuthFormLogin();
        }
      },
    );
  }
}
