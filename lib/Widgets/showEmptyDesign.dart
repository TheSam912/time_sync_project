import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../constants/AppColor.dart';

showEmptyDesign() {
  return Column(
    children: [
      SizedBox(height: 300, width: 300, child: Lottie.asset("assets/lottie/nothing.json")),
      Text(
        "You don't have\n any Active routine",
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
            color: AppColors.mainItemColor, fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ],
  );
}