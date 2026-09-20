import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/home.dart';
import 'package:hydrosavex/controller/lifeguardController.dart';
import 'package:hydrosavex/controller/medicController.dart';
import 'package:hydrosavex/controller/organizationManagerController.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/services/signup2_auth.dart';
import 'package:hydrosavex/view/all_accounts/orgAccountBottomBar.dart';
import 'package:hydrosavex/view/code_view/generatedOrgCodeView.dart';
import 'package:hydrosavex/view/drawer/widgets/drawer_language_switcher.dart';
import 'package:hydrosavex/view/drawer/widgets/drawer_menu_item.dart';
import 'package:hydrosavex/view/home_view/HomeScreen.dart';
import 'package:hydrosavex/view/home_view/home_screen_into.dart';
import 'package:hydrosavex/view/lifeguard/build_list.dart';
import 'package:hydrosavex/view/madical/build_report_list.dart';
import 'package:hydrosavex/view/organization/build_daily_report_list.dart';
import 'package:hydrosavex/view/profile/profile_view.dart';
import 'package:hydrosavex/view/theme_screen/theme_screen.dart';
import 'package:hydrosavex/view/timer/timer.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';

class DrawerOrgManagerItems extends StatelessWidget {
  const DrawerOrgManagerItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DrawerMenuItem(
          icon: Icons.home_work,
          title: AppLocalizations.of(context)!.profile1,
          onTap: () {
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
          },
        ),
        DrawerMenuItem(
          icon: Icons.person,
          title: AppLocalizations.of(context)!.accounts,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrgAccountsBar(),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.receipt_rounded,
          title: AppLocalizations.of(context)!.reports,
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuildDailyReportList('lifeguard'),
              ),
            )
          },
        ),
        DrawerMenuItem(
          icon: Icons.code,
          title: AppLocalizations.of(context)!.code,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<OrganizationManagerProvider>(
                  create: (_) => OrganizationManagerProvider(),
                  child: GeneratedCode(),
                ),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.person,
          title: AppLocalizations.of(context)!.create_member,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthForm2(),
              ),
            );
          },
        ),
        const DrawerLanguageSwitcher(),
        DrawerMenuItem(
          icon: Icons.bedtime_outlined,
          title: AppLocalizations.of(context)!.theme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.feedback_outlined,
          title: AppLocalizations.of(context)!.support,
          onTap: () {
            Navigator.of(context).pop();
            Wiredash.of(context).show();
          },
        ),
      ],
    );
  }
}

class DrawerLifeguardItems extends StatelessWidget {
  const DrawerLifeguardItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DrawerMenuItem(
          icon: Icons.notifications_active,
          title: AppLocalizations.of(context)!.lifeguard_notifications,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuildList(),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.pool,
          title: AppLocalizations.of(context)!.lifeguard_profile,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider<LifeguardProvider>(
                  create: (_) => LifeguardProvider(),
                  child: const Profile("lifeguard"),
                ),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.timer,
          title: "Timer",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomTimerScreen(),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.bedtime_outlined,
          title: AppLocalizations.of(context)!.theme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
        ),
        const DrawerLanguageSwitcher(),
        DrawerMenuItem(
          icon: Icons.feedback_outlined,
          title: AppLocalizations.of(context)!.support,
          onTap: () {
            Navigator.of(context).pop();
            Wiredash.of(context).show();
          },
        ),
      ],
    );
  }
}

class DrawerMedicItems extends StatelessWidget {
  const DrawerMedicItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DrawerMenuItem(
          icon: Icons.local_hospital_outlined,
          title: AppLocalizations.of(context)!.medic_notifications,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuildReportList(),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.person,
          title: AppLocalizations.of(context)!.medic_profile,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider<MedicProvider>(
                  create: (_) => MedicProvider(),
                  child: const Profile("medic"),
                ),
              ),
            );
          },
        ),
        const DrawerLanguageSwitcher(),
        DrawerMenuItem(
          icon: Icons.bedtime_outlined,
          title: AppLocalizations.of(context)!.theme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.feedback_outlined,
          title: AppLocalizations.of(context)!.support,
          onTap: () {
            Navigator.of(context).pop();
            Wiredash.of(context).show();
          },
        ),
      ],
    );
  }
}

class DrawerHomeItems extends StatelessWidget {
  const DrawerHomeItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DrawerMenuItem(
          icon: Icons.notifications_active,
          title: AppLocalizations.of(context)!.home_notifications,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.local_hospital,
          title: AppLocalizations.of(context)!.first_aid,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreenInto(),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.home,
          title: AppLocalizations.of(context)!.home_profile,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider<HomeProvider>(
                  create: (_) => HomeProvider(),
                  child: const Profile("home"),
                ),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.timer,
          title: "Timer",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomTimerScreen(),
              ),
            );
          },
        ),
        DrawerMenuItem(
          icon: Icons.bedtime_outlined,
          title: AppLocalizations.of(context)!.theme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
        ),
        const DrawerLanguageSwitcher(),
        DrawerMenuItem(
          icon: Icons.feedback_outlined,
          title: AppLocalizations.of(context)!.support,
          onTap: () {
            Navigator.of(context).pop();
            Wiredash.of(context).show();
          },
        ),
      ],
    );
  }
}
