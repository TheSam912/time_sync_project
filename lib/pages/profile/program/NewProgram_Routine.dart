import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../Widgets/custom_snackbar.dart';
import '../../../utils/AppColor.dart';
import '../../../utils/request.dart';
import '../../../model/ProgramModel.dart';
import '../../../provider/programProvider.dart';
import '../../../provider/sliderProvider.dart';

class NewProgramRoutine extends ConsumerStatefulWidget {
  NewProgramRoutine(
      {super.key,
      required this.title,
      required this.description,
      required this.category,
      required this.sliceTitle1,
      required this.sliceTitle2,
      required this.sliceTitle3,
      required this.sliceTitle4,
      required this.sliceTitle5,
      required this.pointList});

  String title;
  String description;
  String category;
  String sliceTitle1;
  String sliceTitle2;
  String sliceTitle3;
  String sliceTitle4;
  String sliceTitle5;
  List<ProgramModelSliceItems> pointList;

  @override
  ConsumerState<NewProgramRoutine> createState() => _NewProgramRoutineState();
}

class _NewProgramRoutineState extends ConsumerState<NewProgramRoutine> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<ProgramModelRoutineItems> routineList = [];

  double? sliderValue1;
  double? sliderValue2;
  double? sliderValue3;
  double? sliderValue4;
  double? sliderValue5;

  String prevTitle = "";
  String prevDescription = "";
  String prevFromTime = "";
  String prevToTime = "";

  @override
  void initState() {
    super.initState();
    widget.pointList.add(
        ProgramModelSliceItems(sliceTitle: "slice title 1", sliceValue: "slice description 1"));
    widget.pointList.add(
        ProgramModelSliceItems(sliceTitle: "slice title 2", sliceValue: "slice description 2"));
    widget.pointList.add(
        ProgramModelSliceItems(sliceTitle: "slice title 3", sliceValue: "slice description 3"));
    ref.read(newProgram_startTime);
    ref.read(newProgram_endTime);
  }

  handleRequest(mapReq) async {
    String dataToSent = jsonEncode(mapReq);
    var res = await MyRequest.apiPostRequestNewProgram("/api/program", dataToSent);
    if (res != null) {
      customSnackBar(context, "Program Successfully Submitted!");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      customSnackBar(context, "Error happened !!!");
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

  Future customTimePicker(start, initialTime) async {
    ref.read(newProgram_startTime);
    ref.read(newProgram_endTime);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      builder: (context) {
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: CupertinoDatePicker(
                  backgroundColor: AppColors.backgroundColor,
                  use24hFormat: true,
                  initialDateTime:
                      initialTime.toString().isEmpty ? DateTime.now() : DateTime.parse(initialTime),
                  mode: CupertinoDatePickerMode.time,
                  onDateTimeChanged: (value) {
                    if (start) {
                      ref.watch(newProgram_startTime.notifier).update(
                        (state) {
                          state = value.toString();
                          return state;
                        },
                      );
                      ref.watch(newProgram_endTime.notifier).update(
                        (state) {
                          state = value.toString();
                          return state;
                        },
                      );
                    } else {
                      ref.watch(newProgram_endTime.notifier).update(
                        (state) {
                          state = value.toString();
                          return state;
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextButton(
                    onPressed: () {
                      if (start) {
                        if (ref.watch(newProgram_startTime) == "00:00") {
                          ref.watch(newProgram_startTime.notifier).update(
                            (state) {
                              state = DateTime.now().toString();
                              return state;
                            },
                          );
                        }
                      } else {
                        if (ref.watch(newProgram_endTime) == "00:00") {
                          ref.watch(newProgram_endTime.notifier).update(
                            (state) {
                              state = DateTime.now().toString();
                              return state;
                            },
                          );
                        }
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.nunito(
                          color: AppColors.mainItemColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    sliderValue1 = ref.watch(sliderValue1Provider);
    sliderValue2 = ref.watch(sliderValue2Provider);
    sliderValue3 = ref.watch(sliderValue3Provider);
    sliderValue4 = ref.watch(sliderValue4Provider);
    sliderValue5 = ref.watch(sliderValue5Provider);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainItemColor,
        foregroundColor: AppColors.backgroundColor,
        actions: [
          routineList.isNotEmpty
              ? TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      barrierColor: AppColors.backgroundColor,
                      constraints: BoxConstraints.expand(),
                      builder: (context) {
                        return bottomSheetItems();
                      },
                    );
                  },
                  label: Text(
                    "Add Item",
                    style: GoogleFonts.nunito(color: Colors.amber, fontWeight: FontWeight.w700),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: Colors.amber,
                  ),
                )
              : Center()
        ],
      ),
      body: routineList.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                SizedBox(
                  child: ListView.builder(
                    itemCount: routineList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Stack(
                        children: [
                          roadMapLine(i),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.only(left: 25, bottom: 10, right: 12, top: 8),
                                decoration: BoxDecoration(
                                    color: routineList[i].isDone == false
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
                                            color: routineList[i].isDone == false
                                                ? Color((Random().nextDouble() * 0xFFFFFF).toInt())
                                                    .withOpacity(0.5)
                                                : Colors.grey.shade500,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(14),
                                                topLeft: Radius.circular(14))),
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              routineList[i].title ?? "",
                                              style: GoogleFonts.nunito(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.backgroundColor),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.timer_outlined,
                                                  size: 16,
                                                  color: AppColors.backgroundColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  routineList[i].time ?? "",
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.backgroundColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      child: Text(
                                        routineList[i].description ?? "",
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
                )
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 200, width: 200, child: Lottie.asset("assets/lottie/nothing.json")),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Routine List Is Empty!!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), color: AppColors.mainItemColor),
                    child: TextButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            barrierColor: AppColors.backgroundColor,
                            constraints: BoxConstraints.expand(),
                            builder: (context) {
                              return bottomSheetItems();
                            },
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.amber,
                        ),
                        label: Text(
                          "Add New Item",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                              color: Colors.amber, fontSize: 14, fontWeight: FontWeight.w700),
                        )),
                  )
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: routineList.length >= 2
          ? Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 100),
              decoration:
                  BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(20)),
              child: TextButton.icon(
                  onPressed: () {
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
                                "Are You Done With It? Submit It?",
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
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.red),
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
                                      var map = {
                                        "title": widget.title,
                                        "description": widget.description,
                                        "category": widget.category,
                                        "sliceItems": [
                                          {
                                            "sliceTitle": widget.sliceTitle1,
                                            "sliceValue": sliderValue1
                                          },
                                          {
                                            "sliceTitle": widget.sliceTitle2,
                                            "sliceValue": sliderValue2
                                          },
                                          {
                                            "sliceTitle": widget.sliceTitle3,
                                            "sliceValue": sliderValue3
                                          },
                                          {
                                            "sliceTitle": widget.sliceTitle4,
                                            "sliceValue": sliderValue4
                                          },
                                          {
                                            "sliceTitle": widget.sliceTitle5,
                                            "sliceValue": sliderValue5
                                          }
                                        ],
                                        "author": "Sam",
                                        "points": "a lot",
                                        "routineItems": routineList
                                      };
                                      handleRequest(map);
                                    },
                                    child: Container(
                                      width: 150,
                                      margin: EdgeInsets.only(top: 20),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.amber),
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
                  },
                  label: Text(
                    "Submit",
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontSize: 16, fontWeight: FontWeight.w700),
                  )),
            )
          : Center(),
    );
  }

  inputWidget(hint, controller) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainItemColor),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.backgroundColor),
      child: TextField(
        controller: controller,
        maxLines: hint == "Description" ? 6 : 1,
        textInputAction: TextInputAction.go,
        style: GoogleFonts.nunito(color: AppColors.mainItemColor, fontSize: 16),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: GoogleFonts.nunito(color: Colors.grey.shade600, fontSize: 16)),
        onChanged: (value) {
          setState(() {
            if (hint == "Description") {
              prevDescription = value;
            } else if (hint == "Title") {
              prevTitle = value;
            }
          });
        },
      ),
    );
  }

  roadMapLine(i) {
    return routineList.isNotEmpty
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
                : routineList.length - 1 != i
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

  addButton() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50, left: 14, right: 14, bottom: 50),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.backgroundColor,
              ),
              child: Text(
                "Cancel",
                style: GoogleFonts.nunito(
                    color: AppColors.mainItemColor, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              String time =
                  "${ref.read(newProgram_startTime).toString().split(" ")[1].substring(0, 5)} ${ref.read(newProgram_endTime).toString().split(" ")[1].substring(0, 5)}";
              //var generatedId = DateTime.now().microsecondsSinceEpoch.toString();
              setState(() {
                routineList.add(ProgramModelRoutineItems(
                  // Id: generatedId,
                  isDone: false,
                  title: titleController.text,
                  description: descriptionController.text,
                  time: time,
                ));
              });
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50, left: 14, right: 14, bottom: 50),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.amber,
              ),
              child: Text(
                "ADD",
                style: GoogleFonts.nunito(
                    color: AppColors.mainItemColor, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheetItems() {
    return Consumer(
      builder: (context, ref, child) {
        return Container(
          color: AppColors.mainItemColor,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  inputWidget("Title", titleController),
                  inputWidget("Description", descriptionController),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            "From",
                            style: GoogleFonts.nunito(
                                color: AppColors.backgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              customTimePicker(
                                  true,
                                  ref.watch(newProgram_startTime) == "00:00"
                                      ? ""
                                      : ref.watch(newProgram_startTime));
                            },
                            child: Container(
                                width: 120,
                                height: 55,
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.backgroundColor),
                                child: Text(
                                  ref.watch(newProgram_startTime) != "00:00"
                                      ? ref
                                          .watch(newProgram_startTime)
                                          .toString()
                                          .split(" ")[1]
                                          .substring(0, 5)
                                      : ref.watch(newProgram_startTime),
                                  style: GoogleFonts.nunito(
                                      color: AppColors.mainItemColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "To",
                            style: GoogleFonts.nunito(
                                color: AppColors.backgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              customTimePicker(
                                  false,
                                  ref.watch(newProgram_endTime) == "00:00"
                                      ? ref.watch(newProgram_startTime)
                                      : ref.watch(newProgram_endTime));
                            },
                            child: Container(
                                width: 120,
                                height: 55,
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.backgroundColor),
                                child: Text(
                                  ref.watch(newProgram_endTime) != "00:00"
                                      ? ref
                                          .watch(newProgram_endTime)
                                          .toString()
                                          .split(" ")[1]
                                          .substring(0, 5)
                                      : ref.watch(newProgram_endTime),
                                  style: GoogleFonts.nunito(
                                      color: AppColors.mainItemColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 16, top: 30),
                    child: Text(
                      "Preview",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.nunito(
                          color: AppColors.backgroundColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    color: AppColors.backgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Stack(
                      children: [
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(left: 25, bottom: 10, right: 12, top: 8),
                            decoration: BoxDecoration(
                                color: AppColors.mainItemColor,
                                borderRadius: BorderRadius.circular(14)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(14),
                                            topLeft: Radius.circular(14))),
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          prevTitle,
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
                                            Row(
                                              children: [
                                                Text(
                                                  ref.watch(newProgram_startTime) != "00:00"
                                                      ? ref
                                                          .read(newProgram_startTime)
                                                          .toString()
                                                          .split(" ")[1]
                                                          .substring(0, 5)
                                                      : "",
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.mainItemColor),
                                                ),
                                                Text(
                                                  ref.watch(newProgram_startTime) != "00:00"
                                                      ? " - "
                                                      : "",
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.mainItemColor),
                                                ),
                                                Text(
                                                  ref.watch(newProgram_endTime) != "00:00"
                                                      ? ref
                                                          .read(newProgram_endTime)
                                                          .toString()
                                                          .split(" ")[1]
                                                          .substring(0, 5)
                                                      : "",
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.mainItemColor),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  child: Text(
                                    prevDescription,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.backgroundColor),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
              addButton()
            ],
          ),
        );
      },
    );
  }
}
