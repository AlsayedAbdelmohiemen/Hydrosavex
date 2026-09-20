import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/services/loginAuth.dart';
import 'package:hydrosavex/view/drawer/widgets/drawer_menu_item.dart';
import 'package:hydrosavex/view/drawer/widgets/drawer_role_sections.dart';

class SideDrawer extends StatefulWidget {
  final String router;
  const SideDrawer(this.router, {super.key});

  @override
  _SideDrawerState createState() => _SideDrawerState(router);
}

class _SideDrawerState extends State<SideDrawer> {
  final String router;
  _SideDrawerState(this.router);
  Color c2 = Colors.blue;
  bool isSwitched = true;
  var textValue = 'Switch is ON';

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      textValue = isSwitched ? 'Switch Button is ON' : 'Switch Button is OFF';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(color: Colors.blue),
        ),
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
      ),
      body: SafeArea(
        // Use SafeArea to ensure no overlap with system bars
        child: SizedBox(
          height:
              MediaQuery.of(context).size.height, // Full height of the screen
          child: ListView(
            padding: EdgeInsets.zero, // Ensure no default padding
            children: <Widget>[
              if (router == 'organisationManager') ...[
                const DrawerOrgManagerItems(),
              ] else if (router == 'lifeguard') ...[
                const DrawerLifeguardItems(),
              ] else if (router == 'medic') ...[
                const DrawerMedicItems(),
              ] else if (router == 'home') ...[
                const DrawerHomeItems(),
              ],
              DrawerMenuItem(
                icon: Icons.exit_to_app,
                title: AppLocalizations.of(context)!.logout,
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AuthFormLogin()),
                    (Route<dynamic> route) => false, // Remove back arrow
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

