import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class LifeguardNotificationItem extends StatelessWidget {
  final String name;
  final String id;
  final bool sent;
  final DateTime date;
  final VoidCallback onDelete;
  final VoidCallback onOpenReport;

  const LifeguardNotificationItem({
    super.key,
    required this.name,
    required this.id,
    required this.sent,
    required this.date,
    required this.onDelete,
    required this.onOpenReport,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: SColors.primary,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.sent_at}: $date",
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.send_and_archive),
                onPressed: onOpenReport,
              ),
              onTap: onOpenReport,
            ),
          ),
        ),
      ),
    );
  }
}
