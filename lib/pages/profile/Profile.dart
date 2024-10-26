import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../constants/AppColor.dart';

class Profile extends ConsumerStatefulWidget {
  Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  late String titleDate;

  @override
  Widget build(BuildContext context) {
    titleDate = DateFormat.yMMMEd().format(DateTime.now());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size(0, 0),
          child: Container(
            color: AppColors.mainItemColor,
          )),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return profileDesign(snapshot.data!.email);
            }
            return profileDesign("");
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: socialButtons(),
    );
  }

  profileDesign(userEmail) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        topBarSection(),
        listTileItem(
            userEmail != "" ? "User: $userEmail" : "LOGIN / REGISTER", Icons.person_2_outlined),
        listTileItem("Log Out", Icons.logout),
        listTileItem("Change Password", Icons.lock_open),
        listTileItem("Privacy And Policy", Icons.privacy_tip_outlined),
        listTileItem("Rate Us", Icons.star_rate_outlined),
        listTileItem("Contact Us", Icons.contact_support_outlined),
      ],
    );
  }

  socialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        socialItem("telegram"),
        socialItem("social"),
        socialItem("internet"),
        socialItem("youtube"),
      ],
    );
  }

  socialItem(image) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.mainItemColor),
        child: Image.asset(
          "assets/icons/$image.png",
        ),
      ),
    );
  }

  listTileItem(text, icon) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 70,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: AppColors.backgroundColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      text,
                      style: GoogleFonts.nunito(
                          color: AppColors.mainItemColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 16),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 0.5,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  topBarSection() {
    return Container(
      height: 130,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
          color: AppColors.mainItemColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Row(
              children: [
                Text(
                  "Profile",
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
                      "Page",
                      style: GoogleFonts.nunito(
                          color: AppColors.mainItemColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                    child: Text(
                      titleDate,
                      style: GoogleFonts.nunito(
                          color: AppColors.mainItemColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
