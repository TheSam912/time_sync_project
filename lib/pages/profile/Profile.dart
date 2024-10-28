import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../constants/AppColor.dart';
import '../../model/UserModel.dart';
import '../../provider/usersProvider.dart';
import 'auth/services/auth_service.dart';

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
        listTileItem(userEmail != "" ? "User: $userEmail" : "LOGIN / REGISTER",
            Icons.person_2_outlined, userEmail != "" ? () {} : () => context.pushNamed("login")),
        listTileItem("Log Out", Icons.logout, logoutDialog),
        listTileItem("Change Password", Icons.lock_open, () {}),
        listTileItem("Privacy And Policy", Icons.privacy_tip_outlined, () {}),
        listTileItem("Rate Us", Icons.star_rate_outlined, () {}),
        listTileItem("Contact Us", Icons.contact_support_outlined, () {}),
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

  listTileItem(text, icon, callback) {
    return GestureDetector(
      onTap: callback,
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

  void logoutDialog() {
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

  logOut() {
    AuthService authService = AuthService();
    authService.signOut();
    ref.watch(userInformation.notifier).update(
          (state) => state = UserModel(),
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
