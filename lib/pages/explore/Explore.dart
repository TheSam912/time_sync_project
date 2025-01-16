import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time_sync/model/CategoryModel.dart';

import '../../Widgets/HomePage_Widgets.dart';
import '../../Widgets/loading.dart';
import '../../repository/homeRepository.dart';
import '../../constants/AppColor.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  ConsumerState<Explore> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {
  var mainDuration = const Duration(milliseconds: 1000);
  late String titleDate;
  List categoryList = [];
  bool loading = true;

  Future<void> _handleRequest() async {
    var categoryResponse = ref.watch(categoryPageRequests);
    categoryResponse.when(
      data: (data) {
        setState(() {
          categoryList = data.elementAt(0);
          loading = false;
        });
      },
      error: (error, stackTrace) {
        setState(() {
          loading = false;
        });
      },
      loading: () {
        setState(() {
          loading = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    titleDate = DateFormat.yMMMEd().format(DateTime.now());
    _handleRequest();
    categoryList = [
      CategoryModel(Id: "",title: "Loss Weight"),
      CategoryModel(Id: "",title: "OCD"),
      CategoryModel(Id: "",title: "ADHD"),
      CategoryModel(Id: "",title: "Balanced"),
      CategoryModel(Id: "",title: "Productivity"),
      CategoryModel(Id: "",title: "Fitness"),
    ];
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarSection(titleDate, context),
      body: loading
          ? TimeSyncLoading()
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                _buildHeader(),
                _buildCategoryLabel(),
                categoryList.isNotEmpty ? _buildCategoryGrid(context) : const Center(),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return FadeInDown(
      duration: mainDuration,
      child: Container(
        padding: const EdgeInsets.only(bottom: 30, left: 14.0, top: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
          color: AppColors.mainItemColor,
        ),
        child: Row(
          children: [
            FadeInLeft(
              duration: mainDuration,
              delay: mainDuration + 200.ms,
              child: Text(
                "All Our",
                style: GoogleFonts.nunito(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
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
                  "Routine Plans Category",
                  style: GoogleFonts.nunito(
                      color: AppColors.mainItemColor, fontWeight: FontWeight.w900, fontSize: 20),
                ),
              ).animate(delay: 1800.ms).shimmer(duration: 1000.ms).flip(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 20),
      child: FadeInLeft(
        delay: mainDuration + 1800.ms,
        child: Text(
          "Our Categories:",
          style: GoogleFonts.nunito(
            color: AppColors.mainItemColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
        ),
        itemCount: categoryList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final category = categoryList[index];
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                'category',
                queryParameters: {'category': category.title},
              );
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.backgroundColor,
                boxShadow: const [
                  BoxShadow(color: Colors.grey, blurRadius: 1, offset: Offset(0, 5)),
                ],
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Text(
                category.title ?? "",
                style: GoogleFonts.nunito(
                  color: AppColors.mainItemColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
                .animate(delay: mainDuration + 1200.ms)
                .slideX(duration: 1500.ms, begin: 5, end: 0, curve: Curves.easeInOutSine),
          );
        },
      ),
    );
  }
}
