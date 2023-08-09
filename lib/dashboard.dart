import 'package:allowance_merchant/enter_full_price.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String result = "";

  void enterFullPrice()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EnterFullPrice()));
  }

  void signUp() {
	FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FirebaseAuth.instance.currentUser!.uid + ' Dashboard Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => enterFullPrice(),
              child: Text("Complete Sale"),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(200, 60)),
              )
            ),
          ],
        ),
      ),
    );
  }
}

