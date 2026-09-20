import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class OrganizationReportItem extends StatelessWidget {
  final String id;
  final String type;
  final String comment;
  final Timestamp date;
  final VoidCallback onDelete;

  const OrganizationReportItem({
    super.key,
    required this.id,
    required this.type,
    required this.comment,
    required this.date,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Slidable(
        key: ValueKey(id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
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
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 5,
          margin: EdgeInsets.zero,
          color: dark ? SColors.black : Colors.white,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "${AppLocalizations.of(context)!.status} ",
                          style: TextStyle(
                            color: Colors.blue.withOpacity(0.8),
                          ),
                        ),
                        TextSpan(
                          text: "$type\n",
                          style: TextStyle(
                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "${AppLocalizations.of(context)!.comment}: ",
                          style: TextStyle(
                            color: Colors.blue.withOpacity(0.8),
                          ),
                        ),
                        TextSpan(
                          text: comment,
                          style: TextStyle(
                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                "${AppLocalizations.of(context)!.sent_at}: ${date.toDate()}",
              ),
              isThreeLine: true,
            ),
          ),
        ),
      ),
    );
  }
}
