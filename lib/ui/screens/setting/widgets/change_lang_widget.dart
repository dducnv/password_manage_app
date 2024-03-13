import 'package:flutter/material.dart';
import 'package:password_manage_app/core/domains/constants/locale.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class ChangeLangWidget extends StatelessWidget {
  final Function(int id) onTap;
  final Locale locale;
  const ChangeLangWidget({Key? key, required this.onTap, required this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardCustomWidget(
        padding: const EdgeInsets.all(0),
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
              ChangeLangDropdown(
                id: appListLocale
                    .firstWhere((element) => element.locale == locale)
                    .id,
                onChanged: (value) {
                  onTap(value!);
                },
              )
            ],
          ),
        ));
  }
}

class ChangeLangDropdown extends StatelessWidget {
  const ChangeLangDropdown({
    required this.onChanged,
    super.key,
    this.id,
  });

  final int? id;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int?>(
      value: id,
      underline: const SizedBox.shrink(),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      items: List.generate(
        appListLocale.length,
        (index) => DropdownMenuItem(
          value: appListLocale[index].id,
          child: Text(appListLocale[index].countryName),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
