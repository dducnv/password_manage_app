import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:password_manage_app/core/services/otp_generator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrcodeScaner extends StatefulWidget {
  const QrcodeScaner({Key? key}) : super(key: key);

  @override
  _QrcodeScanerState createState() => _QrcodeScanerState();
}

class _QrcodeScanerState extends State<QrcodeScaner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
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
    void onQRViewCreated({
      required BuildContext context,
      required QRViewController controller,
    }) {
      this.controller = controller;
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          result = scanData;
        });

        print("====================================");
        print(result!.code);
        print("====================================");
        print(OTPCustom.fromUri(result!.code!).toJson());
        print("====================================");

        Navigator.pop(context, OTPCustom.fromUri(result!.code!).toJson());
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Scan QR Code'),
      ),
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
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
