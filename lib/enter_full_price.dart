import 'package:allowance_merchant/complete_sale_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormData {
  final String qrCode;
  final double price;
  final String authToken;

  FormData({required this.qrCode, required this.price, required this.authToken});

  Map<String, dynamic> toJson() {
    return {
      'user_id': qrCode,
      'sale_price': price,
      'auth_token': authToken,
    };
  }
}

class EnterFullPrice extends StatefulWidget {
  @override
  _EnterFullPriceState createState() => _EnterFullPriceState();
}

class _EnterFullPriceState extends State<EnterFullPrice> {
  String user_id = "";
  double sale_price = 0.0;

  final Uri apiUrl = Uri.parse('https://api.allowance.fund/beginSale');

  Future<void> openScanner() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(scanType: ScanType.qr),
      ),
    );
    setState(() {
      if (res is String) {
        user_id = res;
      }
    });
  }

  void completeSale(String chargeCustomer, String saleId)
  {
	Navigator.pushReplacement(
	  context, 
	  MaterialPageRoute(builder: (context) => CompleteSale(customerShouldPay: chargeCustomer,saleId: saleId,))
	);
  }

  Future<void> submitData() async
  {
    // Call the scanner to get the QR code
    await openScanner();

    if (user_id.isNotEmpty && sale_price > 0)
    {
      FormData formData = FormData(qrCode: user_id, price: sale_price, authToken: (await FirebaseAuth.instance.currentUser!.getIdToken()).toString());

      // Convert formData to JSON
      Map<String, dynamic> jsonData = formData.toJson();

      // Send jsonData to API using your preferred HTTP library (e.g., Dio, http)
      // Make sure to handle API response and errors accordingly
      try
      {
        final response = await http.post(
          apiUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(jsonData),
        );

        // Handle the API response here
        print('API Response: ${response.statusCode}');

		if (response.statusCode == 200)
		{
		  Map<String, dynamic> json = jsonDecode(response.body);
		  completeSale(json["charge_user"], json["sale_id"]);
		}
      }
      catch (error)
      {
        // Handle API error here
        print('API Error: $error');
      }
    }
    else
    {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please scan QR code and enter price.')),
        );
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Input'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      sale_price = double.tryParse(value) ?? 0.0;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter price in USD',
                    prefix: Text('\$', style: TextStyle(fontSize: 36)),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(fontSize: 36),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 128.0),
              ElevatedButton(
                onPressed: () => submitData(),
                child: Text("Submit"),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(200, 60)),
                ),
              ),
              Text("Result: " + user_id),
            ],
          ),
        ),
      ),
    );
  }
}

