import 'package:allowance_merchant/scan_qr_code.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class EnterFullPrice extends StatefulWidget {
  @override
  _EnterFullPriceState createState() => _EnterFullPriceState();
}

class _EnterFullPriceState extends State<EnterFullPrice> {
  String user_id = "";
  double sale_price = 0.0;

  final Uri apiUrl = Uri.parse('https://api.allowance.fund/beginSale');

  Future<void> openScanner() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QRViewPage(sale_price: sale_price,)));
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
                onPressed: () => openScanner(),
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
