import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:time_sync/Widgets/loading.dart';
import 'package:time_sync/pages/explore/Category.dart';
import '../../Widgets/HomePage_Widgets.dart';
import '../../Widgets/custom_snackbar.dart';
import '../../Widgets/editProgramBottomSheet.dart';
import '../../Widgets/showEmptyDesign.dart';
import '../../model/ProgramModel.dart';
import '../../model/UserModel.dart';
import '../../provider/usersProvider.dart';
import '../../repository/programRepository.dart';
import '../../repository/usersRepository.dart';
import '../../constants/AppColor.dart';
import '../profile/auth/Login.dart';
import '../profile/auth/services/auth_service.dart';

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
                handleRequest();
                return profileDesign();
              }
              return const Login();
            }),
        floatingActionButton: havePlan
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

  logOut() {
    AuthService authService = AuthService();
    authService.signOut();
    ref.watch(userInformation.notifier).update(
          (state) => state = UserModel(),
        );
  }

  removeProgramForUser() async {
    var user = ref.read(userInformation);
    var reqMap = {"username": user.username, "program": ""};
    String dataToSent = jsonEncode(reqMap);
    var response = await ref.read(usersRepositoryProvider).addProgram(user.Id, dataToSent);
    if (response != null) {
      ref.read(userInformation.notifier).update(
        (state) {
          state.program = "";
          return state;
        },
      );
      customSnackBar(context, "It successfully removed !!");
    } else {
      customSnackBar(context, "Please Try Again Please!!");
    }
  }

  profileDesign() {
    return loading == false
        ? ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              SizedBox(
                  height: 120,
                  child: Stack(
                    children: [
                      havePlan
                          ? Container(
                              padding:
                                  const EdgeInsets.only(bottom: 20, left: 14.0, top: 20, right: 30),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.only(bottomRight: Radius.circular(100)),
                                  color: AppColors.mainItemColor),
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
                                            fontSize: 22),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius: BorderRadius.circular(5)),
                                        child: Text(
                                          "Routine Plan",
                                          style: GoogleFonts.nunito(
                                              color: AppColors.mainItemColor,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20),
                                        ),
                                      )
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
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Center(),
                      havePlan
                          ? Positioned(
                              right: 15,
                              top: 0,
                              bottom: -60,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: Colors.amber, shape: BoxShape.circle),
                                child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: AppColors.mainItemColor,
                                        barrierColor: Colors.amber.withOpacity(0.8),
                                        builder: (context) {
                                          return Container(
                                            width: MediaQuery.of(context).size.width,
                                            color: AppColors.mainItemColor,
                                            height: 150,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);

                                                    showModalBottomSheet(
                                                      context: context,
                                                      backgroundColor: AppColors.backgroundColor,
                                                      barrierColor: AppColors.mainItemColor,
                                                      isScrollControlled: true,
                                                      enableDrag: false,
                                                      constraints: const BoxConstraints.expand(),
                                                      builder: (context) {
                                                        // return editProgramBottomSheet(
                                                        //     context, programResponse);
                                                        return editProgramBottomSheetUpdate(
                                                            context, programResponse);
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width - 50,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.symmetric(vertical: 12),
                                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                                    decoration: BoxDecoration(
                                                        color: AppColors.backgroundColor,
                                                        borderRadius: BorderRadius.circular(12)),
                                                    child: Text(
                                                      "Edit The Program",
                                                      style: GoogleFonts.nunito(
                                                          color: AppColors.mainItemColor,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    voidForDeleteProgram();
                                                  },
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width - 50,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.symmetric(vertical: 12),
                                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.circular(12)),
                                                    child: Text(
                                                      "Delete",
                                                      style: GoogleFonts.nunito(
                                                          color: AppColors.backgroundColor,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    color: Colors.amber,
                                    highlightColor: Colors.transparent,
                                    icon: const Icon(
                                      Icons.more_vert_outlined,
                                      color: AppColors.mainItemColor,
                                    )),
                              ),
                            )
                          : const Center()
                    ],
                  )),
              havePlan ? roadMapSection() : showEmptyDesign(context)
            ],
          )
        : TimeSyncLoading();
    // floatingActionButton: FloatingActionButton(
    // backgroundColor: AppColors.mainItemColor,
    // child: Icon(
    // Icons.add,
    // color: AppColors.backgroundColor,
    // ),
    // onPressed: () {
    // context.pushNamed('newprogram');
    // },
    // );
  }

  void logoutDialog() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.mainItemColor,
          title: Text(
            "Are you want to logout?",
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
                  onPressed: () {
                    logOut();
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
                  onPressed: () {
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
          itemCount: programResponse?.routineItems?.length,
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
