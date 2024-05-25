import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class ConfirmScreenWidget extends StatefulWidget {
  final RegisterViewModel viewModel;
  const ConfirmScreenWidget({super.key, required this.viewModel});

  @override
  State<ConfirmScreenWidget> createState() => _ConfirmScreenWidgetState();
}

class _ConfirmScreenWidgetState extends State<ConfirmScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return PinCodeWidget(
      maxPinLength: 6,
      minPinLength: 6,
      onPressColorAnimation:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.black
              : Colors.white,
      onEnter: (pin, state) async {
        if (pin.isEmpty) {
          return;
        }
        if (widget.viewModel.pinCode == pin) {
          widget.viewModel.savePinCode();
        } else {
          state.reset();
          widget.viewModel.backToCreatePage();
        }
      },
      onChangedPin: (pin) {},
    );
  }
}
