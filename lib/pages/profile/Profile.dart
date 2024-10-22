import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:time_sync/Widgets/Second_template.dart';
import 'package:time_sync/constants/strings.dart';
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

  bool havePlan = false;

  @override
  Widget build(BuildContext context) {
    titleDate = DateFormat.yMMMEd().format(DateTime.now());
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: havePlan ? AppColors.backgroundColor : AppColors.mainItemColor,
        appBar: havePlan
            ? appBarSection(titleDate, context)
            : const PreferredSize(preferredSize: Size(0, 0), child: Center()),
        body: havePlan ? _buildQuestions() : _buildWithAi(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: havePlan ? null : _buildWithAiButton());
  }

  _buildQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topRight,
          decoration: const BoxDecoration(
              color: AppColors.mainItemColor,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    "Choose your focus areas to personalize:",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                        color: AppColors.backgroundColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  child: Lottie.asset("assets/lottie/ai.json", height: 160, width: 160),
                ),
              ],
            ),
          ),
        ),
        questionsTitle("Do you have any fixed commitments?"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [boxItem("Work"), boxItem("School"), boxItem("NO")],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        questionsTitle("Which aspects are you focusing on?"),
        listAspects(),
        questionsTitle("Do you follow any specific diet or have dietary restrictions?"),
      ],
    );
  }

  listAspects() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: ListView.builder(
          itemCount: aspects.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.amber,
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))
                  ]),
              child: Text(
                aspects[index],
                style: GoogleFonts.nunito(
                    color: AppColors.mainItemColor, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            );
          },
        ));
  }

  boxItem(text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.amber,
            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))]),
        child: Text(
          text,
          style: GoogleFonts.nunito(
              color: AppColors.mainItemColor, fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  questionsTitle(text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Text(
        text,
        style: GoogleFonts.nunito(
            color: AppColors.mainItemColor, fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  _buildWithAi() {
    return Column(
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
    );
  }

  _buildWithAiButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          havePlan = !havePlan;
        });
      },
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
    );
  }
}
