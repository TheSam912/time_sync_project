import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time_sync/Widgets/loading.dart';
import '../../Widgets/HomePage_Widgets.dart';
import '../../Widgets/Indicator.dart';
import '../../Widgets/custom_snackbar.dart';
import '../../model/ProgramModel.dart';
import '../../provider/usersProvider.dart';
import '../../repository/programRepository.dart';
import '../../repository/usersRepository.dart';
import '../../constants/AppColor.dart';

class Detail extends ConsumerStatefulWidget {
  Detail({required this.Id});

  String Id;

  @override
  ConsumerState<Detail> createState() => _DetailState();
}

class _DetailState extends ConsumerState<Detail> {
  var mainDuration = 500.ms;
  late String titleDate;
  int touchedIndex = -1;
  List<ProgramModelRoutineItems>? roadMapElements = [];
  List<String> points = [];
  ProgramModel? programResponse;
  late double randomItem;
  bool animated = true;
  String? programId;
  bool selectSchedule = false;
  String routineId = "";
  bool loading = true;
  bool isDone = false;

  handleRequest(String id) async {
    programResponse = await ref.watch(programRepositoryProvider).getOneProgram(id);
    if (programResponse != null) {
      programId = programResponse?.Id;
      points.addAll(programResponse!.points ?? []);
      var items = programResponse!.routineItems;
      if (items != null) {
        roadMapElements = items is List<Map<String, dynamic>>
            ? items.map((item) => ProgramModelRoutineItems.fromJson(item)).toList()
            : List<ProgramModelRoutineItems>.from(items);
      }
      setState(() {
        loading = false;
      });
    }
  }

  handleRequestLocal() async {
    var jsonRes = await rootBundle.loadString("assets/data/program.json");
    var jsonResponse = jsonDecode(jsonRes);
    programResponse = ProgramModel.fromJson(jsonResponse);
    if (programResponse != null) {
      programId = programResponse?.Id;
      points.addAll(programResponse!.points ?? []);
      var items = programResponse!.routineItems;
      if (items != null) {
        roadMapElements = items is List<Map<String, dynamic>>
            ? items.map((item) => ProgramModelRoutineItems.fromJson(item)).toList()
            : List<ProgramModelRoutineItems>.from(items);
      }
      setState(() {
        loading = false;
      });
    }
  }

  addProgramForUser() async {
    var user = ref.watch(userInformation);
    var reqMap = {"username": user.username, "program": programId};
    String dataToSent = jsonEncode(reqMap);
    var response = await ref.watch(usersRepositoryProvider).addProgram(user.Id, dataToSent);
    if (response != null) {
      ref.watch(userInformation.notifier).update(
        (state) {
          state.program = programResponse?.Id;

          return state;
        },
      );
      customSnackBar(context, "It successfully added !!");
    } else {
      customSnackBar(context, "Please Try Again Please!!");
    }
  }

  // toggleRequest() async {
  //   var mapReq = {"_id": routineId};
  //   var res = await MyRequest.apiPostRequest(
  //       "/api/program/toggle/$programId", mapReq);
  //   if (res != null) {
  //     points.clear();
  //     roadMapElements?.clear();
  //     handleRequest(widget.Id);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // handleRequest(widget.Id);
      handleRequestLocal();
      ref.read(userInformation).username;
    });
  }

  @override
  Widget build(BuildContext context) {
    titleDate = DateFormat.yMMMEd().format(DateTime.now());
    randomItem = 45.0;
    Future.delayed(
        4000.ms,
        () => setState(() {
              animated = false;
            }));
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: appBarSection(titleDate, context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: loading == false ? startButton() : const Center(),
        body: Consumer(
          builder: (context, ref, child) {
            ref.watch(userInformation);
            return SizedBox(
              child: loading == false ? ExploreDesign() : TimeSyncLoading(),
            );
          },
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      5,
      (i) {
        final isTouched = i == touchedIndex;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: AppColors.pieColor1,
              value: double.parse(programResponse?.sliceItems![0].sliceValue.toString() ?? ""),
              title: '',
              radius: 85,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: AppColors.pieColor2,
              value: double.parse(programResponse?.sliceItems![1].sliceValue.toString() ?? ""),
              title: '',
              radius: 85,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: AppColors.pieColor3,
              value: double.parse(programResponse?.sliceItems![2].sliceValue.toString() ?? ""),
              title: '',
              radius: 85,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: AppColors.pieColor4,
              value: double.parse(programResponse?.sliceItems![3].sliceValue.toString() ?? ""),
              title: '',
              radius: 85,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 4:
            return PieChartSectionData(
              color: AppColors.pieColor5,
              value: double.parse(programResponse?.sliceItems![4].sliceValue.toString() ?? ""),
              title: '',
              radius: 85,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );

          default:
            throw Error();
        }
      },
    );
  }

  titleSection() {
    return FadeInDown(
      duration: mainDuration,
      child: Container(
        padding: const EdgeInsets.only(bottom: 35),
        decoration: const BoxDecoration(
            color: AppColors.mainItemColor,
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 12)],
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(80))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: FadeInLeft(
                duration: mainDuration,
                delay: mainDuration,
                child: Text(
                  programResponse?.title ?? "",
                  style: GoogleFonts.nunito(
                      color: AppColors.backgroundColor, fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
            ),
            Container(
              height: 28,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 12, left: 14),
              padding: const EdgeInsets.only(left: 2),
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
              child: Row(
                children: [
                  Text(
                    "#${programResponse?.category}",
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  Expanded(
                      child: Container(
                    height: 2.5,
                    margin: const EdgeInsets.only(left: 12),
                    color: AppColors.mainItemColor,
                  ))
                ],
              ),
            ).animate(delay: 500.ms).shimmer(duration: 1000.ms).flip(),
          ],
        ),
      ),
    );
  }

  pieChartSection() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.mainItemColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 12)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Row(
              children: [
                Text(
                  "Focus Area:",
                  style: GoogleFonts.nunito(
                      color: AppColors.backgroundColor, fontWeight: FontWeight.w800, fontSize: 20),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                    child: const Text(
                      "",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 130,
                padding: const EdgeInsets.only(left: 20),
                decoration: const BoxDecoration(
                  color: AppColors.mainItemColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Indicator(
                      color: programResponse?.sliceItems?[0].sliceTitle == ""
                          ? AppColors.mainItemColor
                          : AppColors.pieColor1,
                      text: programResponse?.sliceItems?[0].sliceTitle ?? "",
                      isSquare: false,
                      size: touchedIndex == 0 ? 14 : 12,
                      textColor:
                          touchedIndex == 0 ? AppColors.mainTextColor1 : AppColors.mainTextColor3,
                    ),
                    Indicator(
                      color: programResponse?.sliceItems?[1].sliceTitle == ""
                          ? AppColors.mainItemColor
                          : AppColors.pieColor2,
                      text: programResponse?.sliceItems?[1].sliceTitle ?? "",
                      isSquare: false,
                      size: touchedIndex == 1 ? 14 : 12,
                      textColor:
                          touchedIndex == 1 ? AppColors.mainTextColor1 : AppColors.mainTextColor3,
                    ),
                    Indicator(
                      color: programResponse?.sliceItems?[2].sliceTitle == ""
                          ? AppColors.mainItemColor
                          : AppColors.pieColor3,
                      text: programResponse?.sliceItems?[2].sliceTitle ?? "",
                      isSquare: false,
                      size: touchedIndex == 2 ? 14 : 12,
                      textColor:
                          touchedIndex == 2 ? AppColors.mainTextColor1 : AppColors.mainTextColor3,
                    ),
                    Indicator(
                      color: programResponse?.sliceItems?[3].sliceTitle == ""
                          ? AppColors.mainItemColor
                          : AppColors.pieColor4,
                      text: programResponse?.sliceItems?[3].sliceTitle ?? "",
                      isSquare: false,
                      size: touchedIndex == 2 ? 14 : 12,
                      textColor:
                          touchedIndex == 2 ? AppColors.mainTextColor1 : AppColors.mainTextColor3,
                    ),
                    Indicator(
                      color: programResponse?.sliceItems?[4].sliceTitle == ""
                          ? AppColors.mainItemColor
                          : AppColors.pieColor5,
                      text: programResponse?.sliceItems?[4].sliceTitle ?? "",
                      isSquare: false,
                      size: touchedIndex == 2 ? 14 : 12,
                      textColor:
                          touchedIndex == 2 ? AppColors.mainTextColor1 : AppColors.mainTextColor3,
                    )
                  ],
                ),
              ),
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mainItemColor,
                ),
                margin: const EdgeInsets.only(right: 14),
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: randomItem,
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                    sections: showingSections(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    ).animate(delay: mainDuration).shimmer(duration: 1000.ms).scaleX();
  }

  textSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      margin: const EdgeInsets.only(left: 2, right: 2),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          child: FadeInLeft(
            delay: mainDuration,
            child: Text(
              programResponse?.description ?? "",
              textAlign: TextAlign.justify,
              style: GoogleFonts.nunito(
                  color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  pointsSection() {
    return Container(
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                FadeInLeft(
                  delay: mainDuration,
                  child: Text(
                    "Points:",
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: FadeInRight(
                    delay: mainDuration,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                      child: const Text(
                        "",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              itemCount: points.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SizedBox(
                        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.circle,
                        color: Colors.orangeAccent,
                        size: 12,
                      ),
                      label: Text(
                        points[index],
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.nunito(
                            fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                    ),
                  ],
                ))
                    .animate(delay: mainDuration)
                    .slideY(duration: 1300.ms, begin: 10, end: 0, curve: Curves.easeInOutSine);
              },
            ),
          ),
        ],
      ),
    );
  }

  ExploreDesign() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          titleSection(),
          tabItemDesign(),
          Expanded(
            child: SizedBox(
              height: 500,
              child: TabBarView(
                children: [
                  ListView(
                    children: [textSection(), pieChartSection(), pointsSection(), spacer100()],
                  ),
                  ListView(
                    children: [roadMapSection(), spacer100()],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  tabItemDesign() {
    return FadeInLeft(
      delay: mainDuration,
      child: Container(
        margin: const EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.mainItemColor, width: 2),
        ),
        child: TabBar(
          labelStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          labelColor: AppColors.mainItemColor,
          dividerHeight: 0,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: AppColors.backgroundColor,
          indicatorColor: Colors.transparent,
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              return null;
            },
          ),
          unselectedLabelColor: AppColors.mainItemColor.withOpacity(0.5),
          tabs: const [
            Tab(
              icon: null,
              text: 'Details',
            ),
            Tab(
              icon: null,
              text: 'Schedule',
            ),
          ],
        ),
      ),
    );
  }

  startButton() {
    return Consumer(
      builder: (context, ref, child) {
        var user = ref.watch(userInformation);
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: AppColors.mainItemColor,
              barrierColor: Colors.amber.withOpacity(0.7),
              elevation: 10,
              isDismissible: false,
              builder: (context) {
                return Container(
                  height: 210,
                  margin: const EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.mainItemColor,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Add To Your Daily Routine Plan?",
                        style: GoogleFonts.nunito(
                            color: AppColors.backgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12), color: Colors.red),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.nunito(
                                      color: AppColors.backgroundColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (user.program == "") {
                                if (user.username != null ||
                                    user.Id != null ||
                                    user.program != null ||
                                    user.program == "null") {
                                  addProgramForUser();
                                } else {
                                  customSnackBar(
                                      context, "Please Login To Your Account And Try Again!!");
                                }
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
                                customSnackBar(context, "You have already have a active program!");
                              }
                            },
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12), color: Colors.amber),
                              child: Center(
                                child: Text(
                                  "YES",
                                  style: GoogleFonts.nunito(
                                      color: AppColors.mainItemColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            );
            // addToCalendar();
          },
          child: FadeIn(
            delay: mainDuration + 4000.ms,
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
              decoration:
                  BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  "Add to my Calendar",
                  style: GoogleFonts.nunito(
                      fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.mainItemColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  roadMapSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: roadMapElements?.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            return FadeInLeft(
              delay: mainDuration,
              child: Stack(
                children: [
                  roadMapLine(i),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        routineId = roadMapElements?[i].Id.toString() ?? "";
                      });
                      //toggleRequest();
                    },
                    child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 25, bottom: 10, right: 12, top: 8),
                        decoration: BoxDecoration(
                            color: roadMapElements?[i].isDone == false
                                ? AppColors.backgroundColor
                                : Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                    color: roadMapElements?[i].isDone == false
                                        ? Colors.amber
                                        : Colors.grey.shade500,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(14), topLeft: Radius.circular(14))),
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      roadMapElements?[i].title ?? "",
                                      style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.mainItemColor),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.timer_outlined,
                                          size: 16,
                                          color: AppColors.mainItemColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          roadMapElements?[i].time ?? "",
                                          style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.mainItemColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              child: Text(
                                roadMapElements?[i].description ?? "",
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.mainItemColor),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  roadMapLine(i) {
    return roadMapElements?.length != 0
        ? Positioned(
            left: 5,
            top: -8,
            bottom: 0,
            child: i == 0
                ? Stack(
                    children: [
                      Container(
                        width: 2,
                        color: Colors.black,
                        margin: const EdgeInsets.only(left: 7, top: 20),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 15,
                          height: 15,
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              color: Colors.black, borderRadius: BorderRadius.circular(500)),
                        ),
                      ),
                    ],
                  )
                : roadMapElements!.length - 1 != i
                    ? Stack(
                        children: [
                          Container(
                            width: 2,
                            color: Colors.black,
                            margin: const EdgeInsets.only(left: 7),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 15,
                              height: 15,
                              margin: const EdgeInsets.only(top: 25),
                              decoration: BoxDecoration(
                                  color: Colors.black, borderRadius: BorderRadius.circular(500)),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.black,
                            margin: const EdgeInsets.only(left: 7),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 15,
                              height: 15,
                              margin: const EdgeInsets.only(top: 25),
                              decoration: BoxDecoration(
                                  color: Colors.black, borderRadius: BorderRadius.circular(500)),
                            ),
                          ),
                        ],
                      ),
          )
        : const Center();
  }

  spacer100() {
    return const SizedBox(
      height: 100,
    );
  }
}
