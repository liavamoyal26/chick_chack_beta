import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText({
    super.key,
    required this.outText,
    required this.size,
    required this.color,
  });

  const StyledText.white(this.outText, {super.key,required this.size})
      : color = Colors.white;

  const StyledText.title(this.outText, {super.key})
      : color = Colors.blueGrey,
        size = 50.0;

  final String outText;
  final double size;
  final Color color;

  @override
  Widget build(context) {
    return Text(
      outText,
      style: GoogleFonts.aladin(
        // TextStyle(
        color: color,
        fontSize: size,
      ),
    );
  }
}
