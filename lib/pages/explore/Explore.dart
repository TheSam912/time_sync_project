import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Widgets/HomePage_Widgets.dart';
import '../../repository/homeRepository.dart';
import '../../utils/AppColor.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  ConsumerState<Explore> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {
  late String titleDate;
  List categoryList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _handleRequest();
  }

  Future<void> _handleRequest() async {
    var categoryResponse = ref.read(categoryPageRequests);
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

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarSection(titleDate, context),
      body: loading
          ? const Center(child: CircularProgressIndicator())
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
    return Container(
      padding: const EdgeInsets.only(bottom: 20, left: 14.0, top: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
        color: AppColors.mainItemColor,
      ),
      child: Row(
        children: [
          Text(
            "All Our",
            style: GoogleFonts.nunito(
              color: AppColors.backgroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "Routine Plans",
              style: GoogleFonts.nunito(
                color: AppColors.mainItemColor,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 20),
      child: Text(
        "Our Categories:",
        style: GoogleFonts.nunito(
          color: AppColors.mainItemColor,
          fontSize: 20,
          fontWeight: FontWeight.w800,
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
            ),
          );
        },
      ),
    );
  }
}
