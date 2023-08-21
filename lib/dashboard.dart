import 'package:allowance_merchant/button.dart';
import 'package:allowance_merchant/enter_full_price.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String result = "";

  void enterFullPrice() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EnterFullPrice()));
  }

  void signUp() {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: CustomButton(
                onPressed: () => enterFullPrice(),
                text: 'Begin Sale',
			  minHeight: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
