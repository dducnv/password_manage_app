import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class FistScreenWidget extends StatefulWidget {
  final RegisterViewModel viewModel;
  const FistScreenWidget({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<FistScreenWidget> createState() => _FistScreenWidgetState();
}

class _FistScreenWidgetState extends State<FistScreenWidget> {
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
        if(pin.isEmpty){
          return;
        }
        widget.viewModel.setPin(pin);
        
      },
      onChangedPin: (pin) {},
    );
  }
}
