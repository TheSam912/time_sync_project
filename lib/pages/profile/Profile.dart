import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:time_sync/Widgets/Second_template.dart';
import '../../Widgets/HomePage_Widgets.dart';
import '../../model/ProgramModel.dart';
import '../../constants/AppColor.dart';

class Profile extends ConsumerStatefulWidget {
  Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  late String titleDate;

  bool showAppbar = false;

  @override
  Widget build(BuildContext context) {
    titleDate = DateFormat.yMMMEd().format(DateTime.now());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainItemColor,
      appBar: showAppbar
          ? appBarSection(titleDate, context)
          : const PreferredSize(preferredSize: Size(0, 0), child: Center()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Lottie.asset("assets/lottie/ai.json"),
          ),
          Text(
            "Create your new personal plan\nwith AI suggestions",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                color: AppColors.backgroundColor, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {},
        child: Container(
          width: 200,
          height: 50,
          margin: const EdgeInsets.only(top: 12, bottom: 30),
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.amber),
          child: Text(
            "Start",
            style: GoogleFonts.nunito(
                color: AppColors.mainItemColor, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
