import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteBlock extends StatelessWidget {
  final String title;
  final String text;
  final Color color;

  const NoteBlock({
    super.key,
    required this.title,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16.03,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(100, 100, 100, 1),
            ),
          ),
          const SizedBox(height: 8.0),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(129, 129, 129, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}