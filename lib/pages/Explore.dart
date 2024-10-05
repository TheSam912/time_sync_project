import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Widgets/HomePage_Widgets.dart';
import '../repository/homeRepository.dart';
import '../utils/AppColor.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<Explore> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {
  late String titleDate;
  var categoryList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // ref.read(categoryPageRequests);
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
        return Center(child: CircularProgressIndicator());
      },
      loading: () {
        loading = true;
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    handleRequest();
    var now = DateTime.now();
    titleDate = DateFormat.yMMMEd().format(now);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarSection(titleDate,context),
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20, left: 14.0, top: 20),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100)),
                color: AppColors.mainItemColor),
            child: Row(
              children: [
                Text(
                  "All Our",
                  style: GoogleFonts.nunito(
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "Routine Plans",
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          categoryList.isNotEmpty
              ? Container(
                  margin: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: categoryList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.pushNamed('category', queryParameters: {
                            'category': categoryList[index].title
                          });
                        },
                        child: Container(
                          height: 70,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.backgroundColor,
                              border: Border.all(
                                  color: AppColors.mainItemColor, width: 2)),
                          child: Text(
                            categoryList[index].title ?? "",
                            style: GoogleFonts.nunito(
                                color: AppColors.mainItemColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(),
        ],
      ),
    );
  }
}
