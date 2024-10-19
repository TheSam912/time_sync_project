import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/Second_template.dart';
import '../../model/UserModel.dart';
import '../../provider/usersProvider.dart';
import '../../repository/usersRepository.dart';
import '../../Widgets/HomePage_Widgets.dart';
import '../../model/ProgramModel.dart';
import '../../repository/homeRepository.dart';
import '../../utils/AppColor.dart';
import '../../utils/internet_connection_checker.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  int touchedIndex = -1;
  int categoryIndex = 0;
  late String titleDate;
  bool loading = true;
  List? categoryList;
  bool? isConnected;
  List? programList;
  List? selectedProgramList;
  ProgramModel? programResponse;
  String? programId;
  List<ProgramModelRoutineItems>? roadMapElements = [];
  List<String> points = [];

  @override
  void initState() {
    super.initState();
    initPlatform();
    ref.read(homePageRequests);
  }

  Future initPlatform() async {
    await execute(InternetConnectionChecker(), context);
  }

  handleRequest() async {
    isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected == true) {
      if (categoryIndex == 0) {
        var homeResponse = ref.watch(homePageRequests);
        homeResponse.when(
          data: (data) {
            setState(() {
              categoryList = data.elementAt(0);
              programList = data.elementAt(1);
              loading = false;
            });
          },
          error: (error, stackTrace) {
            loading = true;
            print(error);
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.mainItemColor,
            ));
          },
          loading: () {
            loading = true;
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.mainItemColor,
            ));
          },
        );
      }
    }
  }

  userActiveProgram(username) async {
    var response = await ref.watch(usersRepositoryProvider).getUser(username);
    if (response != null) {
      var user = UserModel.fromJson(response);
      ref.watch(userInformation.notifier).update(
            (state) => state = user,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    handleRequest();
    var now = DateTime.now();
    titleDate = DateFormat.yMMMEd().format(now);
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: appBarSection(titleDate, context),
        body: loading == false
            ? StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var user = snapshot.data?.email.toString();
                    userActiveProgram(user);
                  }
                  return Consumer(
                    builder: (context, ref, child) {
                      ref.watch(userInformation);
                      return SizedBox(
                        child: loading == false
                            ? homeDesign()
                            : Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mainItemColor,
                                ),
                              ),
                      );
                    },
                  );
                })
            : Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainItemColor,
                ),
              ));
  }

  homeDesign() {
    return SizedBox(
      child: loading == false
          ? ListView(
              physics: ClampingScrollPhysics(),
              children: [
                homePageTop(),
                Container(
                  height: 45,
                  margin: EdgeInsets.only(top: 12, bottom: 8, left: 8),
                  child: ListView.builder(
                    itemCount: categoryList!.length + 1,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return index != 0
                          ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: index == categoryIndex
                                      ? AppColors.mainItemColor
                                      : AppColors.backgroundColor,
                                  border: Border.all(color: AppColors.mainItemColor, width: 2)),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    categoryIndex = index;
                                    selectedProgramList = [];
                                    for (int i = 0; i < programList!.length; i++) {
                                      if (categoryList?[categoryIndex - 1].title ==
                                          programList?[i].category) {
                                        selectedProgramList?.add(programList?[i]);
                                      }
                                    }
                                  });
                                },
                                child: Text(
                                  categoryList?[index - 1].title.toString() ?? "",
                                  style: GoogleFonts.nunito(
                                      color: index == categoryIndex
                                          ? Colors.amber
                                          : AppColors.mainItemColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: index == categoryIndex
                                      ? AppColors.mainItemColor
                                      : AppColors.backgroundColor,
                                  border: Border.all(color: AppColors.mainItemColor, width: 2)),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    categoryIndex = index;
                                  });
                                },
                                child: Text(
                                  "All",
                                  style: GoogleFonts.nunito(
                                      color: index == categoryIndex
                                          ? Colors.amber
                                          : AppColors.mainItemColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            );
                    },
                  ),
                ),
                categoryIndex == 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: programList?.length,
                        itemBuilder: (context, index) {
                          return SecondTemplate(
                            Id: programList?[index].Id.toString() ?? "",
                            title: programList?[index].title.toString() ?? "",
                            description: programList?[index].description.toString() ?? "",
                            value1: calculateValue(index, 0),
                            value2: calculateValue(index, 1),
                            value3: calculateValue(index, 2),
                            value4: calculateValue(index, 3),
                            value5: calculateValue(index, 4),
                          );
                        },
                      )
                    : selectedProgramList != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: selectedProgramList?.length,
                            itemBuilder: (context, index) {
                              return SecondTemplate(
                                Id: selectedProgramList?[index].Id.toString() ?? "",
                                title: selectedProgramList?[index].title.toString() ?? "",
                                description:
                                    selectedProgramList?[index].description.toString() ?? "",
                                value1: calculateValue1(index, 0),
                                value2: calculateValue1(index, 1),
                                value3: calculateValue1(index, 2),
                                value4: calculateValue1(index, 3),
                                value5: calculateValue1(index, 4),
                              );
                            },
                          )
                        : Center()
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  double calculateValue(index, i) {
    return double.parse(programList?[index].sliceItems?[i].sliceValue.toString() ?? "");
  }

  double calculateValue1(index, i) {
    return double.parse(selectedProgramList?[index].sliceItems?[i].sliceValue.toString() ?? "");
  }
}
