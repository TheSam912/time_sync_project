import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_sync/Widgets/loading.dart';
import 'package:time_sync/Widgets/loading.dart';
import '../../../Widgets/custom_snackbar.dart';
import '../../../provider/sliderProvider.dart';
import '../../../constants/AppColor.dart';
import '../../../repository/homeRepository.dart';

class Newprogram extends ConsumerStatefulWidget {
  @override
  ConsumerState<Newprogram> createState() => _NewprogramState();
}

class _NewprogramState extends ConsumerState<Newprogram> {
  SharedPreferences? prefs;
  int touchedIndex = -1;
  List angles = [0.0, 10.0, 20.0, 30.0, 45.0, 55.0, 70.0, 90.0, 140.0, 170.0];
  late double randomItem;
  double value1 = 30.0;
  double value2 = 30.0;
  double value3 = 30.0;
  double value4 = 30.0;
  double value5 = 30.0;
  double? sliderValue1;
  double? sliderValue2;
  double? sliderValue3;
  double? sliderValue4;
  double? sliderValue5;
  String sliceTitle1 = "";
  String sliceTitle2 = "";
  String sliceTitle3 = "";
  String sliceTitle4 = "";
  String sliceTitle5 = "";
  bool secondItem = false;
  bool thirdItem = false;
  bool forthItem = false;
  bool fifthItem = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController pointsController = TextEditingController();
  List<String>? pointList = [];
  var categoryList = [];
  bool loading = true;
  String selectedCategoryItem = "";

  @override
  void initState() {
    super.initState();
    sliderValue1 = ref.read(sliderValue1Provider);
  }

  handleRequest() async {
    var categoryResponse = ref.watch(categoryPageRequests);
    categoryResponse.when(
      data: (data) {
        setState(() {
          categoryList = data.elementAt(0);
          loading = false;
        });
      },
      error: (error, stackTrace) {
        loading = true;
        return TimeSyncLoading();
      },
      loading: () {
        loading = true;
        return TimeSyncLoading();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    handleRequest();
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
        centerTitle: true,
        title: Text(
          "Create New Program",
          style: GoogleFonts.nunito(
              fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.backgroundColor),
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          inputWidget("Title", titleController, false),
          inputWidget("Description", descriptionController, false),
          categoryDialog(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: AppColors.mainItemColor, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 12, top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            sliceValueInput(
                                AppColors.pieColor1, sliceTitle1, sliderValue1.toString(), 1),
                            secondItem
                                ? sliceValueInput(
                                    AppColors.pieColor2, sliceTitle2, sliderValue2.toString(), 2)
                                : const Center(),
                            thirdItem
                                ? sliceValueInput(
                                    AppColors.pieColor3, sliceTitle3, sliderValue3.toString(), 3)
                                : const Center(),
                            forthItem
                                ? sliceValueInput(
                                    AppColors.pieColor4, sliceTitle4, sliderValue4.toString(), 4)
                                : const Center(),
                            fifthItem
                                ? sliceValueInput(
                                    AppColors.pieColor5, sliceTitle5, sliderValue5.toString(), 5)
                                : const Center(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Slider(
                                value: sliderValue1 ?? 1,
                                min: 0,
                                max: 10,
                                activeColor: AppColors.pieColor1,
                                inactiveColor: Colors.grey.shade500,
                                thumbColor: AppColors.pieColor1,
                                label: sliderValue1?.round().toString() ?? "",
                                onChanged: (double value) {
                                  sliderValue1 = value.round().toDouble();
                                  ref.read(sliderValue1Provider.notifier).update(
                                        (state) => sliderValue1 ?? 0,
                                      );
                                }),
                            secondItem
                                ? Slider(
                                    value: sliderValue2 ?? 1,
                                    min: 0,
                                    max: 10,
                                    activeColor: AppColors.pieColor2,
                                    inactiveColor: Colors.grey.shade500,
                                    thumbColor: AppColors.pieColor2,
                                    label: sliderValue2?.round().toString() ?? "",
                                    onChanged: (double value) {
                                      if (value != 0.0) {
                                        sliderValue2 = value.round().toDouble();
                                        ref.read(sliderValue2Provider.notifier).update(
                                              (state) => sliderValue2 ?? 0,
                                            );
                                      }
                                    },
                                    onChangeEnd: (value) {
                                      if (value == 0) {
                                        setState(() {
                                          secondItem = false;
                                        });
                                      }
                                    },
                                  )
                                : const Center(),
                            thirdItem
                                ? Slider(
                                    value: sliderValue3 ?? 1,
                                    min: 0,
                                    max: 10,
                                    activeColor: AppColors.pieColor3,
                                    inactiveColor: Colors.grey.shade500,
                                    thumbColor: AppColors.pieColor3,
                                    label: sliderValue3?.round().toString() ?? "",
                                    onChanged: (double value) {
                                      if (value != 0.0) {
                                        sliderValue3 = value.round().toDouble();
                                        ref.read(sliderValue3Provider.notifier).update(
                                              (state) => sliderValue3 ?? 0,
                                            );
                                      }
                                    },
                                    onChangeEnd: (value) {
                                      if (value == 0) {
                                        setState(() {
                                          thirdItem = false;
                                        });
                                      }
                                    },
                                  )
                                : const Center(),
                            forthItem
                                ? Slider(
                                    value: sliderValue4 ?? 1,
                                    min: 0,
                                    max: 10,
                                    activeColor: AppColors.pieColor4,
                                    inactiveColor: Colors.grey.shade500,
                                    thumbColor: AppColors.pieColor4,
                                    label: sliderValue4?.round().toString() ?? "",
                                    onChanged: (double value) {
                                      if (value != 0.0) {
                                        sliderValue4 = value.round().toDouble();
                                        ref.read(sliderValue4Provider.notifier).update(
                                              (state) => sliderValue4 ?? 0,
                                            );
                                      }
                                    },
                                    onChangeEnd: (value) {
                                      if (value == 0) {
                                        setState(() {
                                          forthItem = false;
                                        });
                                      }
                                    },
                                  )
                                : const Center(),
                            fifthItem
                                ? Slider(
                                    value: sliderValue5 ?? 1,
                                    min: 0,
                                    max: 10,
                                    activeColor: AppColors.pieColor5,
                                    inactiveColor: Colors.grey.shade500,
                                    thumbColor: AppColors.pieColor5,
                                    label: sliderValue5?.round().toString() ?? "",
                                    onChanged: (double value) {
                                      if (value != 0.0) {
                                        sliderValue5 = value.round().toDouble();
                                        ref.read(sliderValue5Provider.notifier).update(
                                              (state) => sliderValue5 ?? 0,
                                            );
                                      }
                                    },
                                    onChangeEnd: (value) {
                                      if (value == 0) {
                                        setState(() {
                                          fifthItem = false;
                                        });
                                      }
                                    },
                                  )
                                : const Center(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (fifthItem == false)
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xff303030),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (secondItem != true) {
                              secondItem = true;
                            } else if (thirdItem != true)
                              thirdItem = true;
                            else if (forthItem != true)
                              forthItem = true;
                            else if (fifthItem != true) fifthItem = true;
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.amber,
                        )),
                  )
                else
                  const Center(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Preview:",
                      style: GoogleFonts.nunito(
                          color: AppColors.backgroundColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: secondItem ? 3 : 0,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          inputWidget("Important Points For This Routine", pointsController, true),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pointList?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 70,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            label: Text(
                              pointList?[index] ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.nunito(
                                  color: AppColors.mainItemColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: null,
                            icon: const Icon(
                              Icons.control_point,
                              color: AppColors.mainItemColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                pointList?.removeAt(index);
                              });
                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            )),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              if (inputValidator() == true && sliceValidator() == true) {
                prefs?.setStringList("pointList", pointList ?? []);
                context.pushNamed('newprogram_routine', queryParameters: {
                  'title': titleController.text,
                  "description": descriptionController.text,
                  "category": selectedCategoryItem,
                  "sliceTitle1": sliceTitle1,
                  "sliceTitle2": sliceTitle2,
                  "sliceTitle3": sliceTitle3,
                  "sliceTitle4": sliceTitle4,
                  "sliceTitle5": sliceTitle5,
                });
              }
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 50, left: 14, right: 14),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.mainItemColor,
              ),
              child: Text(
                "Continue",
                style: GoogleFonts.nunito(
                    color: AppColors.backgroundColor, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }

  sliceValueInput(color, value, percent, index) {
    return Container(
      height: 43,
      margin: const EdgeInsets.symmetric(vertical: 3),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                  color: AppColors.backgroundColor),
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: value != "" ? value : "Slice title",
                  hintStyle: GoogleFonts.nunito(
                      color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                style: GoogleFonts.nunito(
                    color: AppColors.mainItemColor, fontSize: 14, fontWeight: FontWeight.w500),
                onSubmitted: (value) {
                  setState(() {
                    switch (index) {
                      case 1:
                        sliceTitle1 = value;
                      case 2:
                        sliceTitle2 = value;
                      case 3:
                        sliceTitle3 = value;
                      case 4:
                        sliceTitle4 = value;
                      case 5:
                        sliceTitle5 = value;
                    }
                  });
                },
                onChanged: (value) {
                  setState(() {
                    switch (index) {
                      case 1:
                        sliceTitle1 = value;
                      case 2:
                        sliceTitle2 = value;
                      case 3:
                        sliceTitle3 = value;
                      case 4:
                        sliceTitle4 = value;
                      case 5:
                        sliceTitle5 = value;
                    }
                  });
                },
              ),
            ),
          ),
          Container(
            width: 60,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
            child: Text(
              percent != "0.0" ? "${percent.toString().split(".")[0]}0 %" : "0",
              style: GoogleFonts.nunito(
                  color: AppColors.backgroundColor, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }

  categoryDialog() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                  color: AppColors.mainItemColor, borderRadius: BorderRadius.circular(20)),
              child: categoryList.isNotEmpty
                  ? ListView.builder(
                      itemCount: categoryList.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.backgroundColor, width: 0.5)),
                            child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedCategoryItem = categoryList[index].title;
                                    Navigator.pop(context);
                                  });
                                },
                                icon: const Icon(
                                  Icons.category,
                                  size: 20,
                                  color: Colors.amber,
                                ),
                                label: Text(categoryList[index].title,
                                    style: GoogleFonts.nunito(
                                      color: AppColors.backgroundColor,
                                      fontSize: 16,
                                    ))),
                          ),
                        );
                      },
                    )
                  : SizedBox(height: 50, width: 50, child: TimeSyncLoading()),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.mainItemColor),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.backgroundColor),
        child: Text(
          selectedCategoryItem == "" ? "Select Category" : selectedCategoryItem.toString(),
          style: GoogleFonts.nunito(
              color: selectedCategoryItem == "" ? Colors.grey.shade600 : AppColors.mainItemColor,
              fontSize: 16,
              fontWeight: selectedCategoryItem != "" ? FontWeight.w700 : FontWeight.w400),
        ),
      ),
    );
  }

  inputWidget(hint, controller, isPoint) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainItemColor),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.backgroundColor),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.go,
        maxLines: hint == "Description" ? 8 : 1,
        onSubmitted: (value) {
          if (hint == "Important Points For This Routine") {
            setState(() {
              if (pointsController.text == "") {
                customSnackBar(context, "Please check item you want to input! It can't be empty");
              } else {
                isPoint == true ? pointList?.add(pointsController.text) : null;
                isPoint == true ? pointsController.clear() : null;
              }
            });
          }
        },
        style: GoogleFonts.nunito(color: AppColors.mainItemColor, fontSize: 16),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: GoogleFonts.nunito(color: Colors.grey.shade600, fontSize: 16)),
      ),
    );
  }

  void addToPointList(value) {
    setState(() {
      pointList?.add(value);
    });
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
              value: ref.watch(sliderValue1Provider),
              title: '',
              radius: 65,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: AppColors.pieColor2,
              value: secondItem ? ref.watch(sliderValue2Provider) : 0,
              title: '',
              radius: 65,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: AppColors.pieColor3,
              value: thirdItem ? ref.watch(sliderValue3Provider) : 0,
              title: '',
              radius: 65,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: AppColors.pieColor4,
              value: forthItem ? ref.watch(sliderValue4Provider) : 0,
              title: '',
              radius: 65,
              borderSide: isTouched
                  ? const BorderSide(color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 4:
            return PieChartSectionData(
              color: AppColors.pieColor5,
              value: fifthItem ? ref.watch(sliderValue5Provider) : 0,
              title: '',
              radius: 65,
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

  bool sliceValidator() {
    if (secondItem) {
      if (sliceTitle2.length <= 2 || sliceTitle2 == "") {
        customSnackBar(
            context, "Check Slice 2 Please !! It can't be null or less that 3 character");
        return false;
      }
    } else {
      return true;
    }
    if (thirdItem) {
      if (sliceTitle3.length <= 2 || sliceTitle3 == "") {
        customSnackBar(
            context, "Check Slice 3 Please !! It can't be null or less that 3 character");
        return false;
      }
    } else {
      return true;
    }

    if (forthItem) {
      if (sliceTitle4.length <= 2 || sliceTitle4 == "") {
        customSnackBar(
            context, "Check Slice 4 Please !! It can't be null or less that 3 character");
        return false;
      }
    } else {
      return true;
    }
    if (fifthItem) {
      if (sliceTitle5.length <= 2 || sliceTitle5 == "") {
        customSnackBar(
            context, "Check Slice 5 Please !! It can't be null or less that 3 character");
        return false;
      }
    } else {
      return true;
    }
    return true;
  }

  bool inputValidator() {
    if (titleController.text.isEmpty) {
      customSnackBar(context, "Enter Title Please !!");
      return false;
    } else if (descriptionController.text.isEmpty) {
      customSnackBar(context, "Enter Description Please !!");
      return false;
    } else if (selectedCategoryItem == "") {
      customSnackBar(context, "Select Category Please !!");
      return false;
    } else if (sliceTitle1.length <= 2 || sliceTitle1 == "") {
      customSnackBar(context, "Check Slice 1 Please !! It can't be null or less that 3 character");
      return false;
    } else if (pointList?.length == 0) {
      customSnackBar(context, "Please enter at least 1 point for this program");
      return false;
    } else {
      return true;
    }
  }
}
