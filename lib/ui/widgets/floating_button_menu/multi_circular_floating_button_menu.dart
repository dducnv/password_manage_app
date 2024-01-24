import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/widgets/floating_button_menu/floating_button_menu.dart';

class MultiCircularFloatingButtonMenu extends StatelessWidget {
  /// List of CircularMenu contains at least two CircularMenu objects.
  final List<CircularFloatingButtonMenuItem> menus;

  /// widget holds actual page content
  final Widget? backgroundWidget;
  const MultiCircularFloatingButtonMenu(
      {super.key, required this.menus, this.backgroundWidget})
      : assert(menus.length != 0, 'menus can not be empty list'),
        assert(menus.length > 1,
            'no need to use MultiCircularMenu you can directly use CircularMenu');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        backgroundWidget ?? Container(),
        ...menus,
      ],
    );
  }
}
