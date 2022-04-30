import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle mystyle(double size,[Color color,FontWeight fw = FontWeight.w500]){
  return GoogleFonts.montserrat(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}