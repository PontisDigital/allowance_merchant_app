import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final bool? isPassword;
  final String hintText;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final Function()? onTap;
  final TextAlign? textAlign;

  const CustomInput({
    this.isPassword,
    required this.hintText,
    this.onChanged,
    this.keyboardType,
    this.onSubmitted,
	this.controller,
	this.onTap,
	this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
		onTap: onTap,
      cursorColor: Colors.white,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
	  textAlign: textAlign ?? TextAlign.left,
      obscureText: isPassword ?? false,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        fillColor: Colors.white,
        focusColor: Colors.white,
        hoverColor: Colors.white,
        labelText: hintText,
        labelStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
