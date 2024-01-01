import 'package:flutter/material.dart';
import 'package:password_manage_app/core/services/otp_generator.dart';
import 'package:password_manage_app/core/utils/refetch_totp.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';
import 'package:timezone/timezone.dart' as timezone;

class OtpTextWithCountdown extends StatefulWidget {
  final String keySecret;
  final double? height;
  final double? width;
  final int? duration;
  final int? initialDuration;
  final TextStyle? otpTextStyle;
  final TextStyle? countDownTextStyle;
  const OtpTextWithCountdown(
      {Key? key,
      required this.keySecret,
      this.otpTextStyle,
      this.countDownTextStyle,
      this.height,
      this.width,
      this.duration,
      this.initialDuration})
      : super(key: key);

  @override
  OtpTextWithCountdownState createState() => OtpTextWithCountdownState();
}

class OtpTextWithCountdownState extends State<OtpTextWithCountdown> {
  String totp = "";
  late RefetchTotp refetchTotp;
  int nowSeconds = 0;
  int nowValueCountDown = 0;
  final CountDownController countDownController = CountDownController();

  @override
  void initState() {
    super.initState();
    nowSeconds = DateTime.now().second;
    if (nowSeconds < 30) {
      nowValueCountDown = nowSeconds;
    } else {
      nowValueCountDown = nowSeconds - 30;
    }

    generateRandomNumber();
    refetchTotp = RefetchTotp(
      refetchTotp: () {
        generateRandomNumber();
        setState(() {});
      },
    );
    refetchTotp.elapsedStream.listen(null);
  }

  void resetCountDown() {
    if (nowSeconds < 30) {
      nowValueCountDown = nowSeconds;
    } else {
      nowValueCountDown = nowSeconds - 30;
    }

    countDownController.restart(
      duration: widget.duration ?? 30,
    );
    setState(() {});
  }

  void generateRandomNumber() {
    var now = DateTime.now();
    final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
    final date = timezone.TZDateTime.from(now, pacificTimeZone);
    totp = OTPCustom.generateTOTPCodeString(
      widget.keySecret,
      date.millisecondsSinceEpoch,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
  }

  @override
  void dispose() {
    refetchTotp.dispose();
    refetchTotp.elapsedStream.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircularCountDownTimer(
          width: widget.width ?? 20,
          height: widget.height ?? 20,
          duration: widget.duration ?? 30,
          initialDuration: widget.initialDuration ?? nowValueCountDown,
          fillColor: Theme.of(context).colorScheme.primary,
          ringColor: Colors.grey[300]!,
          backgroundColor: Colors.grey[300],
          controller: countDownController,
          strokeWidth: 5,
          textStyle: widget.countDownTextStyle ??
              const TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
          autoStart: true,
          isReverse: true,
          strokeCap: StrokeCap.round,
          isTimerTextShown: true,
          onComplete: () {
            resetCountDown();
          },
        ),
        const SizedBox(width: 10),
        Text(totp.toString(),
            style: widget.otpTextStyle ??
                TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary))
      ],
    );
  }
}
