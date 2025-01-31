import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:time_sync/Widgets/loading.dart';
import '../../Widgets/HomePage_Widgets.dart';
import '../../Widgets/custom_snackbar.dart';
import '../../Widgets/editProgramBottomSheet.dart';
import '../../Widgets/showEmptyDesign.dart';
import '../../model/ProgramModel.dart';
import '../../provider/usersProvider.dart';
import '../../repository/programRepository.dart';
import '../../repository/usersRepository.dart';
import '../../constants/AppColor.dart';

class Today extends ConsumerStatefulWidget {
  Today({super.key, required this.selectedProgram});

  String selectedProgram;

  @override
  ConsumerState<Today> createState() => _TodayState();
}

class _TodayState extends ConsumerState<Today> {
  String? userProgramPreferences;
  String? userEmail;
  late String titleDate;
  var programResponse;
  List<ProgramModelRoutineItems>? roadMapElements = [];
  bool loading = true;
  bool havePlan = true;
  ProgramModel? userStateProgram;

  @override
  Widget build(BuildContext context) {
    titleDate = DateFormat.yMMMEd().format(DateTime.now());
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundColor,
        appBar: appBarSection(titleDate, context),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // handleRequest();
                handleRequestLocal();
                return profileDesign();
              }
              return nothingDesign();
            }),
        floatingActionButton: havePlan == false
            ? null
            : GestureDetector(
                onTap: () {
                  context.replaceNamed("ai");
                },
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.mainItemColor, borderRadius: BorderRadius.circular(20)),
                  child: Lottie.asset("assets/lottie/ai.json"),
                ),
              ));
  }

  handleRequest() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userInformation);
      if (user.program != "") {
        programResponse = await ref.read(programRepositoryProvider).getOneProgram(user.program);
        if (programResponse != null) {
          ref.watch(userProgramProvider.notifier).update(
            (state) {
              state = programResponse;
              return state;
            },
          );
          setState(() {
            loading = false;
            havePlan = true;
          });
        }
      } else {
        setState(() {
          loading = false;
          havePlan = false;
        });
      }
    });
  }

  handleRequestLocal() async {
    var jsonRes = await rootBundle.loadString("assets/data/program.json");
    var jsonResponse = jsonDecode(jsonRes);
    programResponse = ProgramModel.fromJson(jsonResponse);
    if (programResponse != null) {
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

  Future<void> removeProgramForUser() async {
    Future.microtask(() async {
      var user = ref.read(userInformation);
      var reqMap = {"username": user.username, "program": ""};
      String dataToSent = jsonEncode(reqMap);
      try {
        var response = await ref.read(usersRepositoryProvider).addProgram(user.Id, dataToSent);
        if (response != null) {
          ref.read(userInformation.notifier).update((state) {
            state.program = "";
            return state;
          });
          customSnackBar(context, "It successfully removed !!");
        } else {
          customSnackBar(context, "Please Try Again!!");
        }
      } catch (e) {
        customSnackBar(context, "An error occurred: $e");
      }
    });
  }

  // removeProgramForUser() async {
  //   var user = ref.read(userInformation);
  //   var reqMap = {"username": user.username, "program": ""};
  //   String dataToSent = jsonEncode(reqMap);
  //   var response = await ref.read(usersRepositoryProvider).addProgram(user.Id, dataToSent);
  //   if (response != null) {
  //     ref.read(userInformation.notifier).update(
  //       (state) {
  //         state.program = "";
  //         return state;
  //       },
  //     );
  //     customSnackBar(context, "It successfully removed !!");
  //   } else {
  //     customSnackBar(context, "Please Try Again Please!!");
  //   }
  // }

  nothingDesign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Lottie.asset("assets/lottie/nothing.json", width: 250, height: 250)),
        Text(
          "Please Login To \nYour Account!",
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            color: AppColors.mainItemColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.pushNamed("login");
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.amber),
            child: Center(
              child: Text(
                "LOGIN",
                style: GoogleFonts.nunito(
                    color: AppColors.mainItemColor, fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ),
        )
      ],
    );
  }

  profileDesign() {
    if (loading) {
      return TimeSyncLoading();
    }

    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        SizedBox(
          height: 135,
          child: Stack(
            children: [
              if (havePlan)
                Container(
                  padding: const EdgeInsets.only(bottom: 25, left: 14.0, top: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(100),
                    ),
                    color: AppColors.mainItemColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Your Daily",
                            style: GoogleFonts.nunito(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8, right: 0),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                              child: Text(
                                "Routine Plans",
                                style: GoogleFonts.nunito(
                                    color: AppColors.mainItemColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        margin: const EdgeInsets.only(left: 2, top: 8),
                        child: Text(
                          programResponse?.title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (havePlan)
                Positioned(
                  right: 15,
                  top: 0,
                  bottom: -78,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showBottomSheet(context);
                      },
                      color: Colors.amber,
                      highlightColor: Colors.transparent,
                      icon: const Icon(
                        Icons.more_vert_outlined,
                        color: AppColors.mainItemColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        havePlan ? roadMapSection() : showEmptyDesign(context),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.mainItemColor,
      barrierColor: Colors.amber.withOpacity(0.8),
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          color: AppColors.mainItemColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBottomSheetOption(
                context: context,
                text: "Add New Program",
                color: AppColors.backgroundColor,
                onTap: () {
                  Navigator.pop(context);
                  context.pushNamed("newprogram");
                  // _editProgram(context);
                },
              ),
              _buildBottomSheetOption(
                context: context,
                text: "Edit The Program",
                color: AppColors.backgroundColor,
                onTap: () {
                  Navigator.pop(context);
                  _editProgram(context);
                },
              ),
              _buildBottomSheetOption(
                context: context,
                text: "End Active Routine Plan",
                color: Colors.amber,
                onTap: voidForDeleteProgram,
              ),
            ],
          ),
        );
      },
    );
  }

  void _editProgram(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      barrierColor: AppColors.mainItemColor,
      isScrollControlled: true,
      enableDrag: false,
      constraints: const BoxConstraints.expand(),
      builder: (context) {
        return editProgramBottomSheetUpdate(context, programResponse);
      },
    );
  }

  Widget _buildBottomSheetOption({
    required BuildContext context,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: GoogleFonts.nunito(
            color: AppColors.mainItemColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void voidForDeleteProgram() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.mainItemColor,
          title: Text(
            "Are you sure you want to remove this program?",
            style: GoogleFonts.nunito(
                color: AppColors.backgroundColor, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          icon: const Icon(
            Icons.warning,
            color: Colors.amber,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "CANCEL",
                  style: GoogleFonts.nunito(
                      color: AppColors.backgroundColor, fontSize: 14, fontWeight: FontWeight.w700),
                )),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.amber),
              child: TextButton(
                  onPressed: () async {
                    removeProgramForUser();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "YES",
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontSize: 14, fontWeight: FontWeight.w700),
                  )),
            ),
          ],
        );
      },
    );
  }

  listTileItems(title, icon, VoidCallback callback, trailing) {
    return ListTile(
        title: Text(
          title,
          style: GoogleFonts.nunito(
              color: AppColors.backgroundColor,
              fontSize: trailing ? 16 : 18,
              fontWeight: trailing ? FontWeight.w700 : FontWeight.w900),
        ),
        leading: Icon(
          icon,
          color: AppColors.backgroundColor,
        ),
        trailing: trailing == true
            ? Icon(
                Icons.arrow_forward_ios_sharp,
                size: 18,
                color: AppColors.backgroundColor,
              )
            : const Icon(
                Icons.person,
                color: AppColors.mainItemColor,
              ),
        onTap: callback);
  }

  roadMapSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: roadMapElements?.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            return Stack(
              children: [
                roadMapLine(i, programResponse?.routineItems?.length),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 25, bottom: 10, right: 12, top: 8),
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          boxShadow: const [
                            BoxShadow(color: AppColors.mainItemColor, blurRadius: 8)
                          ],
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(14), topLeft: Radius.circular(14))),
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    programResponse?.routineItems?[i].title ?? "",
                                    style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
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
                                        programResponse?.routineItems?[i].time ?? "",
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
                              programResponse?.routineItems?[i].description ?? "",
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
            );
          },
        ),
      ),
    );
  }

  roadMapLine(i, lenght) {
    return Positioned(
      left: 5,
      top: -8,
      bottom: 0,
      child: i == 0
          ? Stack(
              children: [
                Container(
                  width: 2,
                  color: AppColors.mainItemColor,
                  margin: const EdgeInsets.only(left: 7, top: 20),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 15,
                    height: 15,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: AppColors.mainItemColor, borderRadius: BorderRadius.circular(500)),
                  ),
                ),
              ],
            )
          : i != lenght - 1
              ? Stack(
                  children: [
                    Container(
                      width: 2,
                      color: AppColors.mainItemColor,
                      margin: const EdgeInsets.only(left: 7),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 15,
                        height: 15,
                        margin: const EdgeInsets.only(top: 25),
                        decoration: BoxDecoration(
                            color: AppColors.mainItemColor,
                            borderRadius: BorderRadius.circular(500)),
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Container(
                      width: 2,
                      height: 30,
                      color: AppColors.mainItemColor,
                      margin: const EdgeInsets.only(left: 7),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 15,
                        height: 15,
                        margin: const EdgeInsets.only(top: 25),
                        decoration: BoxDecoration(
                            color: AppColors.mainItemColor,
                            borderRadius: BorderRadius.circular(500)),
                      ),
                    ),
                  ],
                ),
    );
  }
}
