import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/ProgramModel.dart';
import '../constants/AppColor.dart';

Duration _duration = Duration(hours: 0, minutes: 0);

editProgramBottomSheetUpdate(BuildContext context, ProgramModel program) {
  return Consumer(
    builder: (context, ref, child) {
      // Future.delayed(
      //   Duration.zero,
      //   () {
      //     ref.watch(updateUserProgramProvider.notifier).update(
      //       (state) {
      //         state = program;
      //         return state;
      //       },
      //     );
      //   },
      // );
      return Container(
        color: AppColors.backgroundColor,
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            header(context),
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: program.routineItems?.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 12, bottom: 10, right: 12, top: 8),
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          boxShadow: [BoxShadow(color: AppColors.mainItemColor, blurRadius: 8)],
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
                                      topRight: Radius.circular(14), topLeft: Radius.circular(14))),
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "${program.routineItems?[index].title}",
                                          hintStyle: GoogleFonts.nunito(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.mainItemColor.withOpacity(0.5)),
                                        ),
                                        style: GoogleFonts.nunito(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.mainItemColor),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Row(
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
                                        Text(
                                          "${program.routineItems?[index].time}",
                                          style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.mainItemColor),
                                        ),
                                      ],
                                    ),
                                    onTap: () async {},
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "${program.routineItems?[index].description}",
                                hintStyle: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.mainItemColor.withOpacity(0.5)),
                              ),
                              style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.mainItemColor),
                              maxLines: 3,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    },
  );
}

header(context) {
  return Container(
    padding: EdgeInsets.only(top: 60, bottom: 30),
    decoration: BoxDecoration(
        color: AppColors.mainItemColor,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.close,
            color: AppColors.mainItemColor,
          ),
        ),
        Text(
          "Customize The Program",
          style: GoogleFonts.nunito(
              color: AppColors.backgroundColor, fontSize: 18, fontWeight: FontWeight.w800),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: AppColors.backgroundColor,
            ),
          ),
        ),
      ],
    ),
  );
}
