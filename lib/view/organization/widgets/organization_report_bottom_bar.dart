import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/organizationManagerController.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/view/organization/build_daily_report_list.dart';
import 'package:hydrosavex/view/profile/profile_view.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class OrganizationReportBottomBar extends StatelessWidget {
  final String role;

  const OrganizationReportBottomBar({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        color: dark ? SColors.black : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
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
          selectedItemColor: const Color(0xFF1980B8),
          unselectedItemColor: Colors.grey,
          backgroundColor: dark ? SColors.black : Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: role == 'lifeguard'
              ? 0
              : role == 'medic'
                  ? 1
                  : 2,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const BuildDailyReportList('lifeguard'),
                ),
                (Route<dynamic> route) => false,
              );
            } else if (index == 1) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const BuildDailyReportList('medic'),
                ),
                (Route<dynamic> route) => false,
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<OrganizationManagerProvider>(
                    create: (_) => OrganizationManagerProvider(),
                    child: const Profile("org"),
                  ),
                ),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const Icon(Icons.pool, size: 28),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.lifeguard_report,
                    style: TextStyle(
                      fontSize: 12,
                      color: role == 'lifeguard'
                          ? const Color(0xFF1980B8)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const Icon(Icons.local_hospital_sharp, size: 28),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.medic_report,
                    style: TextStyle(
                      fontSize: 12,
                      color: role == 'medic'
                          ? const Color(0xFF1980B8)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const Icon(Icons.person, size: 28),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.profile1,
                    style: TextStyle(
                      fontSize: 12,
                      color: role == 'org'
                          ? const Color(0xFF1980B8)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
