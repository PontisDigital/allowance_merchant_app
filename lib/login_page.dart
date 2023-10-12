import 'package:allowance_merchant/button.dart';
import 'package:allowance_merchant/dashboard.dart';
import 'package:allowance_merchant/input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithEmailAndPassword() async {
    // Implement Firebase Auth sign in with email and password here
    String email = _emailController.text;
    String password = _passwordController.text;
    // Perform Firebase authentication
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Dashboard(minPosFlow: email == "gtvapes0@gmail.com", isHop: email == "hopcask@gmail.com")));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        CustomInput(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          hintText: 'Email',
        ),
        SizedBox(height: 20),
        CustomInput(
          controller: _passwordController,
          hintText: 'Password',
          isPassword: true,
		  onSubmitted: (String val) {_signInWithEmailAndPassword();},
        ),
        SizedBox(height: 20),
        CustomButton(
          minHeight: 60,
          onPressed: _signInWithEmailAndPassword,
          text: 'Login',
        ),
      ],
    );
  }
}
