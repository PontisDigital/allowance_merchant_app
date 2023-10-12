import 'package:allowance_merchant/button.dart';
import 'package:allowance_merchant/dashboard.dart';
import 'package:allowance_merchant/enter_full_price.dart';
import 'package:allowance_merchant/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiData {
  final String saleId;
  final String authToken;

  ApiData({required this.saleId, required this.authToken});

  Map<String, dynamic> toJson() {
    return {
      'sale_id': saleId,
      'auth_token': authToken,
    };
  }
}

class CompleteSale extends StatefulWidget {
  @override
  _CompleteSaleState createState() => _CompleteSaleState();

  final String customerShouldPay;
  final String saleId;
  CompleteSale({required this.customerShouldPay, required this.saleId});
}

class _CompleteSaleState extends State<CompleteSale> {
  String result = "";
  final Uri apiUrl = Uri.parse('https://api.allowance.fund/completeSale');

  Future<void> completeSale() async {
    ApiData apiData = ApiData(
        saleId: widget.saleId,
        authToken:
            (await FirebaseAuth.instance.currentUser!.getIdToken()).toString());

    // Convert formData to JSON
    Map<String, dynamic> jsonData = apiData.toJson();

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
      }
    } catch (error) {
      // Handle API error here
      print('API Error: $error');
    }
  }

  void nextCustomer() async {
    var email = FirebaseAuth.instance.currentUser!.email;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Dashboard(minPosFlow: email == "gtvapes0@gmail.com", isHop: email == "hopcask@gmail.com")),
        (route) => false);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Please deduct: ",
            style: SafeGoogleFont(
              'Outfit',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffffffff),
            ),
          ),
          Text(
            '\$${widget.customerShouldPay}',
            style: SafeGoogleFont(
              'Outfit',
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xffffffff),
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
            onPressed: () {completeSale(); nextCustomer();},
            text: "Complete Sale",
            minHeight: 80,
          ),
        ],
      ),
    );
  }
}
