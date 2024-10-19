import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/Indicator.dart';
import '../../Widgets/custom_snackbar.dart';
import '../../model/ProgramModel.dart';
import '../../provider/usersProvider.dart';
import '../../repository/programRepository.dart';
import '../../repository/usersRepository.dart';
import '../../utils/AppColor.dart';

class Detail extends ConsumerStatefulWidget {
  Detail({required this.Id});

  String Id;

  @override
  ConsumerState<Detail> createState() => _DetailState();
}

class _DetailState extends ConsumerState<Detail> {
  int touchedIndex = -1;
  List angles = [0.0, 10.0, 20.0, 30.0, 45.0, 55.0, 70.0, 90.0, 140.0, 170.0];
  List<ProgramModelRoutineItems>? roadMapElements = [];
  List<String> points = [];
  ProgramModel? programResponse;
  late double randomItem;
  bool selectDetail = true;
  String? programId;
  bool selectSchedule = false;
  bool favorite = false;
  String routineId = "";

  bool loading = true;
  bool isDone = false;

  handleRequest(String id) async {
    programResponse = await ref.watch(programRepositoryProvider).getOneProgram(id);
    if (programResponse != null) {
      programId = programResponse?.Id;
      for (int i = 0; i < programResponse!.points!.length; i++) {
        points.add(programResponse!.points![i]);
      }
      for (int i = 0; i < programResponse!.routineItems!.length; i++) {
        roadMapElements?.add(ProgramModelRoutineItems(
            Id: programResponse!.routineItems?[i].Id,
            title: programResponse!.routineItems?[i].title,
            description: programResponse!.routineItems?[i].description,
            time: programResponse!.routineItems?[i].time,
            isDone: programResponse!.routineItems?[i].isDone));
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
      handleRequest(widget.Id);
      ref.read(userInformation).username;
    });
  }

  @override
  Widget build(BuildContext context) {
    randomItem = 45.0;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.mainItemColor,
          elevation: 0,
          surfaceTintColor: AppColors.mainItemColor,
          foregroundColor: AppColors.backgroundColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: loading == false ? startButton() : Center(),
        body: Consumer(
          builder: (context, ref, child) {
            ref.watch(userInformation);
            return SizedBox(
              child: loading == false
                  ? ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: selectDetail
                          ? [
                              titleSection(),
                              tabSection(),
                              textSection(),
                              pirChatSection(),
                              pointsSection(),
                              SizedBox(
                                height: 100,
                              )
                            ]
                          : [
                              titleSection(),
                              tabSection(),
                              roadMapSection(),
                              SizedBox(
                                height: 100,
                              )
                            ],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mainItemColor,
                      ),
                    ),
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
    return Container(
      padding: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
          color: AppColors.mainItemColor,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 12)],
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(200))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            programResponse?.title ?? "",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                color: AppColors.backgroundColor, fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ],
      ),
    );
  }

  pirChatSection() {
    return Container(
      height: 240,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.mainItemColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 12)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 130,
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.mainItemColor,
            ),
            margin: EdgeInsets.only(right: 14),
            child: PieChart(
              PieChartData(
                startDegreeOffset: randomItem,
                sectionsSpace: 4,
                centerSpaceRadius: 5,
                sections: showingSections(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  textSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      margin: EdgeInsets.only(left: 2, right: 2),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          child: Text(
            programResponse?.description ?? "",
            textAlign: TextAlign.justify,
            style:
                GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ),
    );
  }

  pointsSection() {
    return Container(
      color: AppColors.backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      child: ListView.builder(
        itemCount: points.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SizedBox(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index != 0
                  ? Divider(
                      thickness: 1,
                      indent: 10,
                      color: AppColors.mainItemColor.withOpacity(0.2),
                    )
                  : Center(),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.star,
                  color: Colors.orangeAccent,
                  size: 14,
                ),
                label: Text(
                  points[index],
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                ),
              ),
            ],
          ));
        },
      ),
    );
  }

  tabSection() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.mainItemColor, width: 2)),
      child: Row(
        children: [
          Flexible(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectDetail = true;
                  selectSchedule = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    color: selectDetail ? AppColors.mainItemColor : AppColors.backgroundColor),
                child: Text(
                  "Detail",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      color: selectDetail ? AppColors.backgroundColor : AppColors.mainItemColor),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectSchedule = true;
                  selectDetail = false;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: selectSchedule ? AppColors.mainItemColor : AppColors.backgroundColor),
                child: Text(
                  "Schedule",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      color: selectSchedule ? AppColors.backgroundColor : AppColors.mainItemColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  tabButton(text, position) {
    return Flexible(
      flex: 5,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: position == "left"
                  ? BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))
                  : BorderRadius.only(
                      topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
              color: AppColors.mainItemColor),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(color: AppColors.backgroundColor),
          ),
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
                  margin: EdgeInsets.only(top: 50),
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
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.symmetric(vertical: 12),
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
                          SizedBox(width: 8),
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
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.symmetric(vertical: 12),
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
          child: Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Text(
                "Add to my Calendar",
                style: GoogleFonts.nunito(
                    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.mainItemColor),
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
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            return Stack(
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
                              ? AppColors.mainItemColor
                              : Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                  color: roadMapElements?[i].isDone == false
                                      ? Colors.amber
                                      : Colors.grey.shade500,
                                  borderRadius: BorderRadius.only(
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
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 16,
                                        color: AppColors.mainItemColor,
                                      ),
                                      SizedBox(
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
                                  color: AppColors.backgroundColor),
                            ),
                          )
                        ],
                      )),
                )
              ],
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
        : Center();
  }
}
