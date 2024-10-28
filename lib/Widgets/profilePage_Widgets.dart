import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/ProgramModel.dart';
import '../provider/usersProvider.dart';

import '../constants/AppColor.dart';

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

editProgramBottomSheet(context,ProgramModel program) {
  return Consumer(
    builder: (BuildContext context, WidgetRef ref, Widget? child) {
      var programResponse = ref.watch(userProgramProvider);

      return ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
                color: AppColors.mainItemColor,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(50))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.mainItemColor,
                  ),
                ),
                Text(
                  "Customize The Program",
                  style: GoogleFonts.nunito(
                      color: AppColors.backgroundColor, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: programResponse.routineItems?.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  // return Dismissible(
                  //   confirmDismiss: (direction) async {
                  //     if (direction == DismissDirection.startToEnd) {
                  //       /// delete item
                  //       return false;
                  //     } else if (direction == DismissDirection.endToStart) {
                  //       /// edit item
                  //       showModalBottomSheet(
                  //         context: context,
                  //         backgroundColor: AppColors.backgroundColor,
                  //         barrierColor: Colors.amber.withOpacity(0.7),
                  //         enableDrag: false,
                  //         isScrollControlled: true,
                  //         builder: (context) {
                  //           return dialogItemForUpdate(i, context);
                  //         },
                  //       );
                  //       return false;
                  //     }
                  //     return false;
                  //   },
                  //   key: UniqueKey(),
                  //   secondaryBackground: Container(
                  //     color: Colors.amber,
                  //     alignment: Alignment.centerRight,
                  //     padding: EdgeInsets.only(right: 12),
                  //     child: Icon(
                  //       Icons.edit,
                  //       color: AppColors.mainItemColor,
                  //     ),
                  //   ),
                  //   background: Container(
                  //     color: Colors.red,
                  //     alignment: Alignment.centerLeft,
                  //     padding: EdgeInsets.only(left: 12),
                  //     child: Icon(
                  //       Icons.delete,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   child: Container(
                  //       width: double.infinity,
                  //       margin: const EdgeInsets.only(left: 12, bottom: 10, right: 12, top: 8),
                  //       decoration: BoxDecoration(
                  //           color: AppColors.backgroundColor,
                  //           boxShadow: [BoxShadow(color: AppColors.mainItemColor, blurRadius: 8)],
                  //           borderRadius: BorderRadius.circular(14)),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //               width: double.infinity,
                  //               padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  //               decoration: BoxDecoration(
                  //                   color: Colors.amber,
                  //                   borderRadius: BorderRadius.only(
                  //                       topRight: Radius.circular(14),
                  //                       topLeft: Radius.circular(14))),
                  //               alignment: Alignment.centerRight,
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text(
                  //                     ref.watch(userProgramProvider).routineItems?[i].title ?? "",
                  //                     style: GoogleFonts.nunito(
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w900,
                  //                         color: AppColors.mainItemColor),
                  //                   ),
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.center,
                  //                     children: [
                  //                       Icon(
                  //                         Icons.timer_outlined,
                  //                         size: 16,
                  //                         color: AppColors.mainItemColor,
                  //                       ),
                  //                       SizedBox(
                  //                         width: 5,
                  //                       ),
                  //                       Text(
                  //                         ref.watch(userProgramProvider).routineItems?[i].time ?? "",
                  //                         style: GoogleFonts.nunito(
                  //                             fontSize: 12,
                  //                             fontWeight: FontWeight.w700,
                  //                             color: AppColors.mainItemColor),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               )),
                  //           Padding(
                  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  //             child: Text(
                  //               ref.watch(userProgramProvider).routineItems?[i].description ?? "",
                  //               maxLines: 10,
                  //               overflow: TextOverflow.ellipsis,
                  //               style: GoogleFonts.nunito(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w700,
                  //                   color: AppColors.mainItemColor),
                  //             ),
                  //           )
                  //         ],
                  //       )),
                  // );
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.backgroundColor,
                        barrierColor: Colors.amber.withOpacity(0.7),
                        enableDrag: false,
                        isScrollControlled: true,
                        builder: (context) {
                          return dialogItemForUpdate(i, context);
                        },
                      );
                    },
                    child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 12, bottom: 10, right: 12, top: 8),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            boxShadow: [const BoxShadow(color: AppColors.mainItemColor, blurRadius: 8)],
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
                                        topRight: Radius.circular(14),
                                        topLeft: Radius.circular(14))),
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      programResponse.routineItems?[i].title ?? "",
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
                                          programResponse.routineItems?[i].time ?? "",
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
                                programResponse.routineItems?[i].description ?? "",
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
                  );
                },
              ),
            ),
          )
        ],
      );
    },
  );
}

dialogItemForUpdate(i, context) {
  return Consumer(
    builder: (context, ref, child) {
      var programResponse = ref.read(userProgramProvider);
      print("========${programResponse.routineItems?[i].title}");
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: AppColors.backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      timePickerBox(
                          context, programResponse.routineItems?[i].time, true, "left", i),
                      const SizedBox(
                        width: 14,
                      ),
                      timePickerBox(
                          context, programResponse.routineItems?[i].time, false, "right", i),
                    ],
                  ),
                ),
                inputWidget(programResponse.routineItems?[i].title, titleController, "title", i),
                inputWidget(programResponse.routineItems?[i].description, descriptionController,
                    "description", i),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              child: Row(
                children: [
                  bottomSheetButtons(context, "Cancel", true, i),
                  const SizedBox(
                    width: 12,
                  ),
                  bottomSheetButtons(context, "Save Changes", false, i),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

timePickerBox(context, time, bool start, String leftOrRight, i) {
  String from = "From: ${time.toString().split(" - ")[0].trim()}";
  String end = "To: ${time.toString().split(" - ")[1].substring(0, 4).trim()}";
  return Expanded(
    child: GestureDetector(
      onTap: () {
        if (leftOrRight == "left") {
          customTimePicker(context, i);
        } else {
          customTimePicker(context, i);
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mainItemColor)),
        child: Text(
          start ? from : end,
          style: GoogleFonts.nunito(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}

Future customTimePicker(context, i) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.backgroundColor,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          return SizedBox(
            height: 280,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CupertinoDatePicker(
                    backgroundColor: AppColors.backgroundColor,
                    use24hFormat: true,
                    initialDateTime: DateTime.now(),
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (value) {
                      // print(value.toString().split(" ")[1].substring(0, 5));
                      // ref.watch(userProgramProvider.notifier).update(
                      //   (state) {
                      //     print(state.routineItems?[i].time);
                      //     return state;
                      //   },
                      // );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Submit",
                        style: GoogleFonts.nunito(
                            color: AppColors.mainItemColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      )),
                )
              ],
            ),
          );
        },
      );
    },
  );
}

inputWidget(hint, controller, type, i) {
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
      maxLines: type != "title" ? 5 : 1,
      onSubmitted: (value) {},
      style: GoogleFonts.nunito(color: AppColors.mainItemColor, fontSize: 16),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.nunito(color: Colors.grey.shade600, fontSize: 16)),
    ),
  );
}

bottomSheetButtons(context, String text, bool cancel, i) {
  return Consumer(
    builder: (context, ref, child) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            if (cancel == true) {
              Navigator.pop(context);
            } else {
              String updatedTitle = titleController.text;
              if (updatedTitle != "") {
                ref.watch(userProgramProvider.notifier).update(
                  (state) {
                    state.routineItems?[i].title = updatedTitle;
                    return state;
                  },
                );
                print(
                    "=========================${ref.watch(userProgramProvider).routineItems?[i].title}");
                Navigator.pop(context);
              }
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: cancel ? Colors.amber : AppColors.mainItemColor),
            child: Text(
              text,
              style: GoogleFonts.nunito(
                  color: cancel ? AppColors.mainItemColor : AppColors.backgroundColor),
            ),
          ),
        ),
      );
    },
  );
}
