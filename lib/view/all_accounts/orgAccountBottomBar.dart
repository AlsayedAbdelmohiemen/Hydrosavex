import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/lifeguardController.dart';
import 'package:hydrosavex/controller/medicController.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/utils/constants/colors.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';
import 'package:hydrosavex/view/all_accounts/medicorgallAccounts.dart';
import 'package:hydrosavex/view/all_accounts/organisationAccountsView.dart';
import 'package:provider/provider.dart';

class OrgAccountsBar extends StatefulWidget {
  const OrgAccountsBar({super.key});

  @override
  _OrgAccountsBarState createState() => _OrgAccountsBarState();
}

class _OrgAccountsBarState extends State<OrgAccountsBar> {
  int selectedPage = 0;

  final _pageOptions = [
    ChangeNotifierProvider<LifeguardProvider>(
      create: (_) => LifeguardProvider(),
      child: OrgAccountslifeguard(),
    ),
    ChangeNotifierProvider<MedicProvider>(
      create: (_) => MedicProvider(),
      child: OrgAccountsmedic(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Scaffold(
      extendBody: true,
      body: _pageOptions[selectedPage],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: dark
              ? SColors.black
              : Colors.white, // Background color for BottomNavigationBar
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ), // Rounded corners
          border: Border.all(
            color: dark ? SColors.black : Colors.white,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: dark
                ? SColors.black
                : Colors.white, // Same background as container
            selectedItemColor:
                Color(0xFF1980B8), // Blue color for selected item
            unselectedItemColor: Colors.grey, // Grey color for unselected items
            elevation: 18, // Match the 18dp elevation from the Android XML
            currentIndex: selectedPage,
            onTap: (index) {
              setState(() {
                selectedPage = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.pool, size: 28), // Adjusted icon size
                label: AppLocalizations.of(context)!.lifeguards,
              ),
              BottomNavigationBarItem(
                icon:
                    Icon(Icons.local_hospital, size: 28), // Adjusted icon size
                label: AppLocalizations.of(context)!.medics,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
