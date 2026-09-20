import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hydrosavex/controller/medicController.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/model/medic.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/colors.dart';
import '../../utils/helpers/custom_loading.dart';
import '../../utils/helpers/helper_functions.dart';


class OrgAccountsmedic extends StatefulWidget {
  const OrgAccountsmedic({super.key});

  @override
  _OrgAccountsmedicState createState() => _OrgAccountsmedicState();
}

class _OrgAccountsmedicState extends State<OrgAccountsmedic> {
  late List<Medic> medics;
  bool isLoading = true;
  var update;
  int deleted = 1;

  @override
  void initState() {
    super.initState();
    Provider.of<MedicProvider>(context, listen: false)
        .fetchData()
        .then((_) {
      setState(() {
        isLoading = false;
      });
    });
    update = Provider.of<MedicProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    medics = Provider.of<MedicProvider>(this.context, listen: true).medic;


    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.all_medic_accounts,
          style: TextStyle(color: Color(0xFF0C76B0)),
        ),
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

      body: isLoading
          ? Scaffold(
          body: Container(color: dark ? SColors.dark : SColors.primaryBackground,
              child: Center(
                  child: CustomLoading()// Display a loading spinner
              )
          )
      )
          : medics.isEmpty
          ? _buildNoDataPlaceholder()
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: medics.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: ValueKey(medics[index].getId),

              // Swipe from left to right (start)
              startActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      _showDeleteConfirmationDialog(context, index);
                    },
                    backgroundColor: Colors.red,
                    borderRadius: BorderRadius.circular(18),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: AppLocalizations.of(context)!.delete,
                  ),
                ],
              ),

              // Swipe from right to left (end)
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      _showDeleteConfirmationDialog(context, index);
                    },
                    backgroundColor: Colors.red,
                    borderRadius: BorderRadius.circular(18),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: AppLocalizations.of(context)!.delete,
                  ),
                ],
              ),

              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                color: Color(0xFF1980B8),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  title: Row(
                    children: [
                      Icon(Icons.email, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          medics[index].getEmail,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          medics[index].getUsername,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) =>
          const SizedBox(height: 16),
        ),
      ),
    );
  }

  // Placeholder for no data
  Widget _buildNoDataPlaceholder() {
    final dark = SHelperFunctions.isDarkMode(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/cuate.png'), // Update the path to your image
          SizedBox(height: 20),
          Text(
            "No Accounts Yet",
            style: TextStyle(fontSize: 18, color: dark ? SColors.white : SColors.black,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(AppLocalizations.of(context)!.confirm_delete),
          ),
          content: Text(AppLocalizations.of(context)!.are_you_sure_want_to_proceed),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.yes),
              onPressed: () {
                update.updateData(medics[index].getId, {'deleted': deleted});
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor:  SColors.white,
                backgroundColor: SColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.cancel,style: TextStyle(color: Color(0xFF1980B8),),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
