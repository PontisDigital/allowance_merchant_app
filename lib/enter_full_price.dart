import 'package:allowance_merchant/button.dart';
import 'package:allowance_merchant/input.dart';
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
        context,
        MaterialPageRoute(
            builder: (context) => QRViewPage(
                  sale_price: sale_price,
                )));
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(4, 30, 66, 1),
        centerTitle: true,
        title: Text(
          'Allowance Business Portal',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Color(0xffffffff),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(4, 30, 66, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomInput(
                onChanged: (value) {
                  setState(() {
                    sale_price = double.tryParse(value) ?? 0.0;
                  });
                },
                hintText: "Enter Full Price",
                keyboardType: TextInputType.numberWithOptions(decimal: true),
				  textAlign: TextAlign.center,
              ),
              SizedBox(height: 128.0),
              CustomButton(
                onPressed: () => openScanner(),
                text: "Submit",
				minHeight: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
