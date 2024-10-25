import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../constants/AppColor.dart';

showEmptyDesign(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        children: [
          SizedBox(height: 250, width: 250, child: Lottie.asset("assets/lottie/nothing.json")),
          Text(
            "You Don't Have\n Any Active Routine",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                color: AppColors.mainItemColor, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      // Container(
      //   height: 70,
      //   alignment: Alignment.center,
      //   margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(20),
      //       color: Colors.amber,
      //       boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 12)]),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image.asset(
      //         "assets/icons/ai.png",
      //         width: 35,
      //         height: 35,
      //       ),
      //       const SizedBox(
      //         width: 8,
      //       ),
      //       Text(
      //         "Build Personal Routine With AI",
      //         style: GoogleFonts.nunito(
      //             color: AppColors.mainItemColor, fontSize: 16, fontWeight: FontWeight.w700),
      //       ),
      //     ],
      //   ),
      // )
    ],
  );
}
