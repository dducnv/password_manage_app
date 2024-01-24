import 'package:flutter/material.dart';
import 'package:password_manage_app/core/utils/utils.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChangeLangWidget extends StatelessWidget {
  const ChangeLangWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardCustomWidget(
        padding: const EdgeInsets.all(0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Provider.of<AppLanguageProvider>(context, listen: false)
                  .changeLanguage(const Locale("vi"));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Language",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "English",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
