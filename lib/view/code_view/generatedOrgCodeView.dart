import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hydrosavex/controller/organizationManagerController.dart';
import 'package:hydrosavex/database/firebase.dart';
import 'package:hydrosavex/l10n/app_localizations.dart' show AppLocalizations;
import 'package:hydrosavex/model/OrganisationManager.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/colors.dart';
import '../../utils/helpers/custom_loading.dart';
import '../../utils/helpers/helper_functions.dart';

class GeneratedCode extends StatefulWidget {
  const GeneratedCode({super.key});

  @override
  State<StatefulWidget> createState() {
    return GeneratedCodeState();
  }
}

class GeneratedCodeState extends State<GeneratedCode> {
  Color c1 = const Color.fromRGBO(110, 204, 234, 1.0);
  static GetFirebase orgCode = GetFirebase();
  TextEditingController controller = TextEditingController();
  late List<OrganisationManager> orgmanagers;
  bool prog = true;
  late int userIndex;

  @override
  void initState() {
    Provider.of<OrganizationManagerProvider>(context, listen: false)
        .fetchData()
        .then((value) {
      prog = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    if (prog == false) {
      userIndex =
          orgmanagers.indexWhere((element) => element.id == orgCode.getUserID);
    }
    orgmanagers =
        Provider.of<OrganizationManagerProvider>(this.context, listen: true)
            .orgManagers;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
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
        title: Text(
          AppLocalizations.of(context)!.generated_code,
          style: TextStyle(
            color: Color(0xFF1980B8),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: prog
          ? Scaffold(
              body: Container(
                  color: dark ? SColors.dark : SColors.primaryBackground,
                  child:
                      Center(child: CustomLoading() // Display a loading spinner
                          )))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image at the top
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/bro.png', // Update the path to your image
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 30),

                  // "The Code" label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.the_code,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Text field with the generated code and copy button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            orgmanagers[userIndex].getOrgCode,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),

                      // Copy Button
                      GestureDetector(
                        onTap: () async {
                          await FlutterClipboard.copy(
                              orgmanagers[userIndex].getOrgCode);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .copied_to_clipboard,
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.check,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFF1980B8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.content_copy,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
