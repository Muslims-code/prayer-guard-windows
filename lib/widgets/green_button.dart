import 'package:flutter/material.dart';

import '../constants.dart';

class GreenButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const GreenButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: const BorderSide(color: kGreen))),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          backgroundColor: MaterialStateProperty.all<Color>(kGreen),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
