import 'package:allowance_merchant/utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final double? minHeight;

  const CustomButton({
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.style,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ??
            SafeGoogleFont(
              'Outfit',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
      ),
      style: style ??
          ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Color.fromRGBO(0, 61, 166, 1)),
            minimumSize: MaterialStateProperty.all(
                Size(double.infinity, minHeight ?? 35)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
    );
  }
}
