import 'dart:developer';
import 'dart:html';
import 'dart:io';

import 'package:allowance_merchant/complete_sale_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormData {
  final String qrCode;
  final double price;
  final String authToken;

  FormData(
      {required this.qrCode, required this.price, required this.authToken});

  Map<String, dynamic> toJson() {
    return {
      'user_id': qrCode,
      'sale_price': price,
      'auth_token': authToken,
    };
  }
}

class QRViewPage extends StatefulWidget {
  final double sale_price;
  QRViewPage({Key? key, required this.sale_price}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _idScanned = false;
  final Uri apiUrl = Uri.parse('https://api.allowance.fund/beginSale');

  void completeSale(String chargeCustomer, String saleId) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CompleteSale(
                  customerShouldPay: chargeCustomer,
                  saleId: saleId,
                )));
  }

  Future<void> submitData() async {
    if (result != null && widget.sale_price > 0) {
      FormData formData = FormData(
          qrCode: result!.code ?? "ERROR",
          price: widget.sale_price,
          authToken: (await FirebaseAuth.instance.currentUser!.getIdToken())
              .toString());

      // Convert formData to JSON
      Map<String, dynamic> jsonData = formData.toJson();

      // Send jsonData to API using your preferred HTTP library (e.g., Dio, http)
      // Make sure to handle API response and errors accordingly
      try {
        final response = await http.post(
          apiUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(jsonData),
        );

        // Handle the API response here
        print('API Response: ${response.statusCode}');

        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);
          completeSale(json["charge_user"], json["sale_id"]);
        }
      } catch (error) {
        // Handle API error here
        print('API Error: $error');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please scan QR code and enter price.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (result != null && !_idScanned) {
      _idScanned = true;
      submitData();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'SCANNING',
                        style: TextStyle(color: Colors.white))
                  else
                    const Text('Scan a code',
                        style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission to Camera')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

