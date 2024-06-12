import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class RedElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const RedElevatedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(232, 80, 91, 1),
        fixedSize: const Size(319, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.w900,
          fontSize: 20,
          letterSpacing: 3,
          color: const Color.fromRGBO(255, 251, 250, 1),
        ),
      ),
    );
  }
}