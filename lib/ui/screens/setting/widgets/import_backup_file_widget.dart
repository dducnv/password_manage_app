import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class ImportBackupFileWidget extends StatelessWidget {
  final Function() onTap;

  const ImportBackupFileWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardCustomWidget(
        padding: const EdgeInsets.all(0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Import backup file",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Icon(
                    Icons.upload,
                  )
                  //switch
                ],
              ),
            ),
          ),
        ));
  }
}
