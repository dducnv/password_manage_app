import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password_manage_app/core/services/otp_generator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerKeyView extends StatefulWidget {
  const QrScannerKeyView({Key? key}) : super(key: key);

  @override
  State<QrScannerKeyView> createState() => _QrScannerKeyViewState();
}

class _QrScannerKeyViewState extends State<QrScannerKeyView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
              onQRViewCreated: (controller) => {
                onQRViewCreated(
                  context: context,
                  controller: controller,
                )
              },
            ),
          ),
        ],
      ),
    );
  }

  bool hasPopped = false;
  void onQRViewCreated({
    required BuildContext context,
    required QRViewController controller,
  }) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      print("====================================");
      print(scanData.code);
      print("====================================");
      print(OTPCustom.fromUri(scanData.code!).toJson());
      print("====================================");

      if (scanData.code != null && !hasPopped) {
        hasPopped = true;
        Navigator.pop(context, scanData.code);
      }
    });
  }
}
