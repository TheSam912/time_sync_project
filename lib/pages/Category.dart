import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../Widgets/Second_template.dart';
import '../repository/programRepository.dart';
import '../utils/AppColor.dart';

class Category extends ConsumerStatefulWidget {
  Category({super.key, required this.category});

  String category;

  @override
  ConsumerState<Category> createState() => _CategoryState();
}

class _CategoryState extends ConsumerState<Category> {
  late String titleDate;
  List programList = [];
  bool loading = true;

  handleRequest() async {
    List response =
        await ref.watch(programRepositoryProvider).getProgramByCategory(widget.category);
    if (response.isNotEmpty) {
      programList = response;
    }
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    titleDate = DateFormat.yMMMEd().format(now);
    Future.delayed(
      Duration.zero,
      () async {
        await handleRequest();
        if (programList.isNotEmpty) {
          setState(() {
            loading = false;
          });
        }
      },
    );
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainItemColor,
        elevation: 0,
        surfaceTintColor: AppColors.mainItemColor,
        foregroundColor: AppColors.backgroundColor,
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: AppColors.backgroundColor,
            )),
        centerTitle: false,
        title: Text(
          titleDate,
          style: GoogleFonts.nunito(
              color: AppColors.backgroundColor, fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: loading == false
          ? ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 30, left: 14.0, top: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
                      color: AppColors.mainItemColor),
                  child: Row(
                    children: [
                      Text(
                        "Routine Plans for",
                        style: GoogleFonts.nunito(
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.amber, borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          widget.category,
                          style: GoogleFonts.nunito(
                              color: AppColors.mainItemColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: programList.length,
                  itemBuilder: (context, index) {
                    return SecondTemplate(
                      Id: programList[index].Id.toString(),
                      title: programList[index].title.toString(),
                      description: programList[index].description.toString(),
                      value1: 30.0,
                      value2: 30.0,
                      value3: 30.0,
                      value4: 30.0,
                      value5: 30.0,
                    );
                  },
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                      height: 200, width: 200, child: Lottie.asset("assets/lottie/nothing.json")),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Nothing Found !!!",
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
    );
  }

  double calculateValue(index, i) {
    return double.parse(programList[index].sliceItems?[i].sliceValue.toString() ?? "");
  }
}
