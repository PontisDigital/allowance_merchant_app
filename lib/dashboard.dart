import 'package:allowance_merchant/button.dart';
import 'package:allowance_merchant/enter_full_price.dart';
import 'package:allowance_merchant/minflow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.minPosFlow, required this.isHop});
  @override
  _DashboardState createState() => _DashboardState();

  bool minPosFlow;
  bool isHop;
}

class _DashboardState extends State<Dashboard> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(4, 30, 66, 1),
        centerTitle: true,
        title: const Text(
          'Allowance Business Portal',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Color(0xffffffff),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(4, 30, 66, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: CustomButton(
                onPressed: () => widget.minPosFlow ? minFlow() : enterFullPrice(),
                text: 'Begin Sale',
                minHeight: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void enterFullPrice() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EnterFullPrice(isHop: widget.isHop)));
  }

  void minFlow() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MinFlow()));
  }


  void signUp() {
    FirebaseAuth.instance.signOut();
  }
}
