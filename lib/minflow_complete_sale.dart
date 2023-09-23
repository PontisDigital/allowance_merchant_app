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

class MinFlowCompleteSale extends StatefulWidget {
  @override
  _MinFlowCompleteSaleState createState() => _MinFlowCompleteSaleState();

  final String deduct;
  final String saleId;
  MinFlowCompleteSale({required this.deduct, required this.saleId});
}

class _MinFlowCompleteSaleState extends State<MinFlowCompleteSale> {

  void nextCustomer() async {
    var email = FirebaseAuth.instance.currentUser!.email;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Dashboard(minPosFlow: email == "gtvapes0@gmail.com")),
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
            '\$${widget.deduct}',
            style: SafeGoogleFont(
              'Outfit',
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xffffffff),
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
            onPressed: () => nextCustomer(),
            text: "Next Customer",
            minHeight: 80,
          ),
        ],
      ),
    );
  }
}
