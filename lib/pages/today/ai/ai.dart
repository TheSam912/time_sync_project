import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:time_sync/constants/AppColor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:time_sync/constants/strings.dart';
import 'package:time_sync/pages/today/provider/questions_provider.dart';

class ai extends ConsumerStatefulWidget {
  const ai({super.key});

  @override
  ConsumerState<ai> createState() => _aiState();
}

class _aiState extends ConsumerState<ai> {
  late String titleDate;
  bool havePlan = false;
  List<String> selectedCommitment = [];
  List<String> selectedAspect = [];
  List<String> selectedDiet = [];
  List<String> selectedChallenges = [];

  void toggleSelection(String challenge, list, provider) {
    setState(() {
      if (list.contains(challenge)) {
        list.remove(challenge);
      } else {
        list.add(challenge);
      }
    });
    ref.read(selectedCommitmentProvider);
    ref.read(selectedCommitmentProvider.notifier).update((state) {
      state = "fuck you";
      return state;
    });
  }

  @override
  Widget build(BuildContext context) {
    titleDate = DateFormat.yMMMEd().format(DateTime.now());
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: havePlan ? AppColors.backgroundColor : AppColors.mainItemColor,
        appBar: havePlan
            ? PreferredSize(
                preferredSize: const Size(0, 0),
                child: Container(
                  color: AppColors.mainItemColor,
                ))
            : null,
        body: havePlan ? _buildQuestions() : _buildWithAi(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: havePlan ? null : _buildWithAiButton());
  }

  Widget _buildQuestions() {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        appbarSection(),
        gridListSection("Do you have any fixed commitments?", fixedCommitments, "commitments"),
        gridListSection("Which aspects are you focusing on?", aspects, "aspect"),
        gridListSection("Do you follow any specific diet restrictions?", specificDiet, "diet"),
        gridListSection("What are your main challenges?", challenges, "challenge"),
        specifyOtherSection(),
        generateButton(),
      ],
    );
  }

  gridListSection(question, list, type) {
    bool isSelected = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          questionsTitle(question),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 3.5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              String item = list[index];
              switch (type) {
                case "commitments":
                  isSelected = selectedCommitment.contains(item);
                case "aspect":
                  isSelected = selectedAspect.contains(item);
                case "diet":
                  isSelected = selectedDiet.contains(item);
                case "challenge":
                  isSelected = selectedChallenges.contains(item);
              }
              return GestureDetector(
                onTap: () {
                  if (type == "commitments") {
                    toggleSelection(item, selectedCommitment, selectedCommitmentProvider);
                  }
                  if (type == "aspect") {
                    toggleSelection(item, selectedAspect, selectedAspectProvider);
                  }
                  if (type == "diet") {
                    toggleSelection(item, selectedDiet, selectedDietProvider);
                  }
                  if (type == "challenge") {
                    toggleSelection(item, selectedChallenges, selectedChallengeProvider);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? Colors.amber : AppColors.unselectedItemColor,
                      boxShadow: [
                        BoxShadow(
                            color: isSelected ? AppColors.unselectedItemColor : Colors.grey,
                            blurRadius: 5,
                            offset: const Offset(0, 5))
                      ]),
                  child: Text(
                    item,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 42,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.unselectedItemColor,
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))
                  ]),
              child: Text(
                "Other (Specify)",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    color: AppColors.mainItemColor, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }

  questionsTitle(text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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

  specifyOtherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Text(
            "Please specify any other points you want",
            style: GoogleFonts.nunito(
                color: AppColors.mainItemColor, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.backgroundColor,
              border: Border.all(color: AppColors.mainItemColor, width: 0.5)),
          child: TextField(
            maxLines: 6,
            scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            style: GoogleFonts.nunito(
                color: AppColors.mainItemColor, fontSize: 14, fontWeight: FontWeight.w500),
            cursorColor: AppColors.mainItemColor,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Write here ...",
              hintStyle:
                  GoogleFonts.nunito(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            onChanged: (value) {
              ref.watch(selectedTextProvider.notifier).update(
                    (state) => state = value,
                  );
            },
          ),
        )
      ],
    );
  }

  appbarSection() {
    return Container(
      alignment: Alignment.topRight,
      decoration: const BoxDecoration(
          color: AppColors.mainItemColor,
          borderRadius:
              BorderRadius.only(bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40))),
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
                    color: AppColors.backgroundColor, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              child: Lottie.asset("assets/lottie/ai.json", height: 160, width: 160),
            ),
          ],
        ),
      ),
    );
  }

  generateButton() {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                context.pushReplacementNamed("today");
              },
              child: Container(
                height: 60,
                width: 100,
                margin: const EdgeInsets.only(left: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.mainItemColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 8)]),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.nunito(
                      color: AppColors.backgroundColor, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  updateStatesAndSend();
                },
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(right: 14, left: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 8)]),
                  child: Text(
                    "Generate",
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  void updateStatesAndSend() {
    ref.read(selectedCommitmentProvider.notifier).update(
      (state) {
        state = selectedCommitment.toString();
        return state;
      },
    );
    ref.read(selectedAspectProvider.notifier).update(
      (state) {
        state = selectedAspect.toString();
        return state;
      },
    );
    ref.read(selectedDietProvider.notifier).update(
      (state) {
        state = selectedDiet.toString();
        return state;
      },
    );
    ref.read(selectedChallengeProvider.notifier).update(
      (state) {
        state = selectedChallenges.toString();
        return state;
      },
    );
    context.pushReplacementNamed("routinePlanAi");
  }
}
