import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/AppColor.dart';

appBarSection(titleDate, context) {
  return AppBar(
    backgroundColor: AppColors.mainItemColor,
    centerTitle: false,
    title: Text(
      titleDate,
      style: GoogleFonts.nunito(
          color: AppColors.backgroundColor, fontSize: 18, fontWeight: FontWeight.w800),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    color: AppColors.mainItemColor,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        listTileItems(
                            "User: ${FirebaseAuth.instance.currentUser?.email.toString() ?? "Not Found / LOGIN"}",
                            Icons.person_3_outlined,
                            () {},
                            false),
                        listTileItems(
                            "Privacy And Policy", Icons.privacy_tip_outlined, () {}, true),
                        listTileItems("Rate Us", Icons.star_rate_outlined, () {}, true),
                        listTileItems("Contact Us", Icons.contact_support_outlined, () {}, true),
                        listTileItems("Fallow Us", Icons.support, () {}, true),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.settings,
              color: AppColors.backgroundColor,
            )),
      ),
    ],
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

homePageTop() {
  return Container(
    padding: const EdgeInsets.only(bottom: 30, left: 0),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
        color: AppColors.mainItemColor),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Row(
            children: [
              Text(
                "Today's",
                style: GoogleFonts.nunito(
                    color: AppColors.backgroundColor, fontWeight: FontWeight.w700, fontSize: 22),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                  child: Text(
                    "Actions !",
                    style: GoogleFonts.nunito(
                        color: AppColors.mainItemColor, fontWeight: FontWeight.w900, fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Text(
                "Tomorrow's",
                style: GoogleFonts.nunito(
                    color: AppColors.backgroundColor, fontWeight: FontWeight.w700, fontSize: 22),
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
                  "Success !",
                  style: GoogleFonts.nunito(
                      color: AppColors.mainItemColor, fontWeight: FontWeight.w900, fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
