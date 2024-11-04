import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Widgets/loading.dart';
import '../../../constants/AppColor.dart';
import '../../../constants/public.dart';
import '../../../model/ProgramModel.dart';
import '../../../utils/ai_request.dart';
import '../../../utils/regEx.dart';
import '../provider/questions_provider.dart';

class RoutinePlanAi extends ConsumerStatefulWidget {
  const RoutinePlanAi({super.key});

  @override
  ConsumerState<RoutinePlanAi> createState() => _RoutinePlanAiState();
}

class _RoutinePlanAiState extends ConsumerState<RoutinePlanAi> {
  String? kCommitments, kAspects, kDiets, kChallenges, kText;
  ProgramModel? routinePlan;
  List<ProgramModelRoutineItems>? roadMapElements = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchValues();
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   fetchAndDisplayRoutinePlan();
    // });
    fetchAndDisplayRoutinePlanLocal();
  }

  fetchValues() {
    kCommitments = regExString(ref.read(selectedCommitmentProvider));
    kAspects = regExString(ref.read(selectedAspectProvider));
    kDiets = regExString(ref.read(selectedDietProvider));
    kChallenges = regExString(ref.read(selectedChallengeProvider));
    kText = regExString(ref.read(selectedTextProvider));
  }

  Future<void> fetchAndDisplayRoutinePlanLocal({int retries = 3}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      Map<String, dynamic> jsonResponse = {};
      var jsonRes = await rootBundle.loadString("assets/data/ai_response.json");
      jsonResponse = jsonDecode(jsonRes);
      final fetchedRoutinePlan = ProgramModel.fromJson(jsonResponse);
      var items = fetchedRoutinePlan.routineItems;
      if (items != null) {
        roadMapElements = items is List<Map<String, dynamic>>
            ? items.map((item) => ProgramModelRoutineItems.fromJson(item)).toList()
            : List<ProgramModelRoutineItems>.from(items);
      }
      setState(() {
        routinePlan = fetchedRoutinePlan;
        isLoading = false;
      });
        } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Could not load the routine plan. Please check your network and try again.";
      });
    }
  }

  Future<void> fetchAndDisplayRoutinePlan({int retries = 3}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedRoutinePlan = await fetchRoutinePlan(
        apiKey: openAiKey,
        fixedCommitments: kCommitments.toString(),
        goals: kAspects.toString(),
        dietPreferences: kDiets.toString(),
        challenges: kChallenges.toString(),
        additionalPreferences: kText.toString(),
      );

      if (fetchedRoutinePlan != null) {
        var items = fetchedRoutinePlan.routineItems;
        if (items != null) {
          roadMapElements = items is List<Map<String, dynamic>>
              ? items.map((item) => ProgramModelRoutineItems.fromJson(item)).toList()
              : List<ProgramModelRoutineItems>.from(items);
        }
        setState(() {
          routinePlan = fetchedRoutinePlan;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load the routine plan after retries.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Could not load the routine plan. Please check your network and try again.";
      });
    }
  }

  List<PieChartSectionData> showingSections() {
    return routinePlan?.sliceItems?.map((sliceItem) {
          return PieChartSectionData(
            color: Colors
                .primaries[routinePlan!.sliceItems!.indexOf(sliceItem) % Colors.primaries.length],
            value: double.tryParse(sliceItem.sliceValue.toString()) ?? 0.0,
            // title: "${sliceItem.sliceTitle} (${sliceItem.sliceValue}%)",
            title: "${sliceItem.sliceValue}%",
            titleStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            radius: 100,
          );
        }).toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Routine Plan"),
      ),
      body: isLoading
          ? Center(child: TimeSyncLoading()) // Loading indicator
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => fetchAndDisplayRoutinePlan(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the title and description of the plan
                      Text(
                        routinePlan?.title ?? "Routine Plan",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        routinePlan?.description ?? "Your personalized daily routine",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),

                      // Pie chart for slice items
                      const Text(
                        "Focus Areas",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: 0,
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: showingSections(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Display key points
                      if (routinePlan?.points != null) ...[
                        const Text(
                          "Key Points",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ...routinePlan!.points!.map((point) => ListTile(
                              leading: const Icon(Icons.check_circle_outline, color: Colors.blue),
                              title: Text(point),
                            )),
                      ],
                      const SizedBox(height: 24),

                      // Routine items list
                      const Text(
                        "Daily Routine",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      routinePlan?.routineItems != null
                          // ? ListView.builder(
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     itemCount: routinePlan!.routineItems!.length,
                          //     itemBuilder: (context, index) {
                          //       final item = routinePlan!.routineItems![index];
                          //       return ListTile(
                          //         title: Text(item.title ?? "Routine Item"),
                          //         subtitle: Text(item.description ?? "No description"),
                          //         trailing: Text(item.time ?? "No time specified"),
                          //         leading: Icon(
                          //           item.isDone ?? false
                          //               ? Icons.check_circle
                          //               : Icons.radio_button_unchecked,
                          //           color: item.isDone ?? false ? Colors.green : Colors.grey,
                          //         ),
                          //       );
                          //     },
                          //   )
                          ? roadMapSection()
                          : const Text("No routine items available"),
                    ],
                  ),
                ),
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
            return Stack(
              children: [
                roadMapLine(i),
                GestureDetector(
                  onTap: () {},
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
                                        fontSize: 12,
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
                                            fontSize: 10,
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
                                  fontSize: 12,
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
        : const Center();
  }
}
