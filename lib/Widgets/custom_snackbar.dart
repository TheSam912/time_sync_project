import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/AppColor.dart';

customSnackBar(BuildContext context, message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.amber,
      duration: const Duration(milliseconds: 1000),
      content: Text(
        message,
        style: GoogleFonts.nunito(
            color: AppColors.mainItemColor, fontWeight: FontWeight.w700, fontSize: 16),
      )));
}
