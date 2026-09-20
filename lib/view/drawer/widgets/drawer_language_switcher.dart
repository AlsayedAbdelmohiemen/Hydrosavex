import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/language_provider.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/utils/helpers/helper_functions.dart';
import 'package:provider/provider.dart';

class DrawerLanguageSwitcher extends StatelessWidget {
  const DrawerLanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: dark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              backgroundColor: dark ? Colors.black : Colors.white,
              collapsedBackgroundColor: dark ? Colors.black : Colors.white,
              iconColor: Colors.blue,
              collapsedIconColor: Colors.blue,
              title: Text(
                AppLocalizations.of(context)!.language,
                style: TextStyle(
                  color: dark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              childrenPadding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 8.0),
                  title: Text(
                    AppLocalizations.of(context)!.english,
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Provider.of<LanguagesProvider>(context, listen: false)
                        .selectEnglishLanguage();
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 8.0),
                  title: Text(
                    AppLocalizations.of(context)!.arabic,
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Provider.of<LanguagesProvider>(context, listen: false)
                        .selectArabicLanguage();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
