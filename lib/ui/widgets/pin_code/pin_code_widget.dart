import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({
    super.key,
    required this.onEnter,
    this.minPinLength = 4,
    this.maxPinLength = 25,
    required this.onChangedPin,
    this.clearStream,
    this.centerBottomWidget,
    this.numbersStyle = const TextStyle(
        fontSize: 30.0, fontWeight: FontWeight.w600, color: Colors.grey),
    this.borderSide = const BorderSide(width: 1, color: Colors.grey),
    this.buttonColor = Colors.black12,
    this.onPressColorAnimation = Colors.yellow,
  });

  final void Function(String pin, PinCodeState state) onEnter;
  final void Function(String pin) onChangedPin;
  final Stream<bool>? clearStream;
  final int minPinLength;
  final int maxPinLength;
  final Widget? centerBottomWidget;
  final TextStyle numbersStyle;
  final BorderSide borderSide;
  final Color buttonColor;
  final Color onPressColorAnimation;

  @override
  State<StatefulWidget> createState() => PinCodeState();
}

class PinCodeState<T extends PinCodeWidget> extends State<T> {
  final _gridViewKey = GlobalKey();
  final _key = GlobalKey<ScaffoldState>();
  final ScrollController listController = ScrollController();

  late String pin;
  late double _aspectRatio;
  bool animate = false;
  bool incorectPinAnimation = false;
  bool maxLengthAnimation = false;

  int currentPinLength() => pin.length;

  void reset() {
    pin = "";
    setState(() {});
  }

  void codeIncorected() {
    setState(() {
      incorectPinAnimation = true;
      maxLengthAnimation = true;
    });

    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      setState(() {
        incorectPinAnimation = false;
        maxLengthAnimation = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    pin = '';
    _aspectRatio = 0;

    if (widget.clearStream != null) {
      widget.clearStream!.listen((val) {
        if (val) {
          clear();
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void clear() {
    if (_key.currentState?.mounted != null && _key.currentState!.mounted) {
      setState(() => pin = '');
    }
  }

  void calculateAspectRatio() {
    final renderBox =
        _gridViewKey.currentContext!.findRenderObject() as RenderBox;
    final cellWidth = renderBox.size.width / 3;
    final cellHeight = renderBox.size.height / 4;
    if (cellWidth > 0 && cellHeight > 0) {
      _aspectRatio = cellWidth / cellHeight;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _key,
        body: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: body(context),
        ),
        resizeToAvoidBottomInset: false,
      );

  Widget body(BuildContext context) {
    return MeasureSize(
      onChange: (size) {
        calculateAspectRatio();
      },
      child: Container(
        key: _gridViewKey,
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildPinIndicator(),
              const Spacer(flex: 2),
              Flexible(
                flex: 26,
                child: SizedBox(
                  width: 350,
                  child: _aspectRatio > 0 ? _buildNumPad() : null,
                ),
              ),
              const Spacer(flex: 1),
              widget.centerBottomWidget != null
                  ? Center(child: widget.centerBottomWidget!)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinIndicator() {
    return SizedBox(
      height: 20,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: ListView(
          controller: listController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          shrinkWrap: true,
          children: List.generate(pin.length, (index) {
            const size = 15.0;
            if (index == pin.length - 1) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: AnimatedContainer(
                  width:
                      !maxLengthAnimation || !incorectPinAnimation || !animate
                          ? size
                          : size + 10,
                  height:
                      !maxLengthAnimation || !incorectPinAnimation || !animate
                          ? size
                          : size + 10,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: incorectPinAnimation
                        ? Colors.red
                        : Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: AnimatedContainer(
                width: !maxLengthAnimation || !incorectPinAnimation
                    ? size
                    : size + 10,
                height: !maxLengthAnimation || !incorectPinAnimation
                    ? size
                    : size + 10,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: incorectPinAnimation
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNumPad() {
    return GridView.count(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      crossAxisCount: 3,
      children: List.generate(12, (index) {
        if (index == 9) {
          return _buildButton(
            text: 'delete',
            backgroundColor: Colors.transparent,
            child: Icon(
              CupertinoIcons.delete_left_fill,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            onPressed: () {
              _onRemove();
            },
          );
        } else if (index == 10) {
          return _buildButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            text: '0',
            onPressed: () {
              _onPressed(0);
            },
          );
        } else if (index == 11) {
          return _buildButton(
            backgroundColor: Colors.transparent,
            text: 'OK',
            textStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            onPressed: () {
              widget.onEnter(pin, this);
            },
          );
        } else {
          return _buildButton(
            text: (index + 1).toString(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              _onPressed(index + 1);
            },
          );
        }
      }),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    TextStyle? textStyle,
    Color? backgroundColor,
    Widget? child,
  }) {
    return CustomButtonWidget(
      width: 50,
      height: 50,
      borderRaidus: 50,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      kMargin: 0,
      kPadding: 0,
      miniumSize: const Size(50, 50),
      text: text,
      style: textStyle,
      backgroundColor: backgroundColor ?? widget.buttonColor,
      onPressed: onPressed,
      child: child,
    );
  }

  void _onRemove() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  void _onPressed([int num = -1]) async {
    if (currentPinLength() >= widget.maxPinLength) {
      setState(() {
        maxLengthAnimation = true;
      });

      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        setState(() {
          maxLengthAnimation = false;
        });
      });
      await HapticFeedback.heavyImpact();
      return;
    }

    setState(() {
      animate = false;

      if (num >= 0) {
        pin += num.toString();
        widget.onChangedPin(pin);
      }
    });

    Future.delayed(const Duration(milliseconds: 60)).then((value) {
      setState(() {
        animate = true;
      });
    });

    listController.jumpTo(listController.position.maxScrollExtent);
  }

  void _afterLayout(dynamic _) {
    calculateAspectRatio();
  }
}

// ...

typedef OnWidgetSizeChange = void Function(Size size);

class _MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;

  _MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({
    super.key,
    required this.onChange,
    required Widget super.child,
  });

  final OnWidgetSizeChange onChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MeasureSizeRenderObject(onChange);
  }
}
