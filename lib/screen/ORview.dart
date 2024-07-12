import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello_doctor/screen/QrHealthCard.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRview extends StatefulWidget {
  const QRview({Key? key}) : super(key: key);

  @override
  State<QRview> createState() => _QRviewState();
}

class _QRviewState extends State<QRview> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String result = 'Scannig...';
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
              onQRViewCreated: (cont) {
                controller = cont;
                cont.scannedDataStream.listen((scanData) {
                  if(scanData.code!.startsWith('01')){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QrHealthCard(phone: scanData.code!,)));
                  }else{
                    setState(() {
                      result = 'Invalid health card QR code';
                    });
                  }
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                  result,
                  style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
