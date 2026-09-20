import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hydrosavex/controller/lifeguardController.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/model/lifeguard.dart';

import 'package:provider/provider.dart';

import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';

class OrgAccountslifeguard extends StatefulWidget {
  const OrgAccountslifeguard({super.key});

  @override
  _OrgAccountslifeguard createState() => _OrgAccountslifeguard();
}

class _OrgAccountslifeguard extends State<OrgAccountslifeguard> {
  late List<Lifeguard> lifeguard;
  bool prog = true;
  var update;
  int deleted = 1;

  @override
  void initState() {
    super.initState();
    _fetchData();
    update = Provider.of<LifeguardProvider>(context, listen: false);
  }

  Future<void> _fetchData() async {
    await Provider.of<LifeguardProvider>(context, listen: false).fetchData();
    setState(() {
      prog = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    lifeguard =
        Provider.of<LifeguardProvider>(this.context, listen: true).lifeguards;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.all_lifeguards_accounts,
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
      body: prog
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchData,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: lifeguard.isEmpty
                    ? _buildNoDataPlaceholder()
                    : ListView.separated(
                        itemCount: lifeguard.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Slidable(
                            key: ValueKey(lifeguard[index].getId),

                            // Action pane for swiping from left to right (start)
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    _showDeleteConfirmation(context, index);
                                  },
                                  backgroundColor: Colors.red,
                                  borderRadius: BorderRadius.circular(18),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: AppLocalizations.of(context)!.delete,
                                ),
                              ],
                            ),

                            // Action pane for swiping from right to left (end)
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    _showDeleteConfirmation(context, index);
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
                                        lifeguard[index].getEmail,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
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
                                        lifeguard[index].getUsername,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 16),
                      ),
              ),
            ),
    );
  }

  // No data placeholder
  Widget _buildNoDataPlaceholder() {
    final dark = SHelperFunctions.isDarkMode(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              'assets/images/cuate.png'), // Update the path to your image
          SizedBox(height: 20),
          Text(
            "No Accounts Yet", // Ensure this is in your localization file
            style: TextStyle(
              fontSize: 18,
              color: dark ? SColors.white : SColors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(AppLocalizations.of(context)!.confirm_delete),
          ),
          content:
              Text(AppLocalizations.of(context)!.are_you_sure_want_to_proceed),
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
                update.updateData(
                  lifeguard[index].getId,
                  {'deleted': deleted},
                ).then((_) {
                  _fetchData(); // Refresh the list after deletion
                });
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: SColors.white,
                backgroundColor: SColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                    color: Color(0xFF1980B8),
                  )),
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
