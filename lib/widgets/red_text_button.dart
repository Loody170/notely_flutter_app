import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RedTextButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final VoidCallback onPressed;

  const RedTextButton({
    super.key,
    required this.text,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
          color: const Color.fromRGBO(232, 80, 91, 1),
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}