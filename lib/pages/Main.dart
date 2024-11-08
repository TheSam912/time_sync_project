import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../constants/AppColor.dart';
import '../model/UserModel.dart';
import '../provider/usersProvider.dart';
import '../repository/usersRepository.dart';
import '../routes/route.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  bool fetchedProgram = false;
  var user;
  bool changed = false;
  bool onBoardingShowed = false;

  @override
  void initState() {
    super.initState();
    user = ref.read(userInformation);
    Future.delayed(
      3000.ms,
      () => setState(() {
        onBoardingShowed = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
    return Scaffold(
      backgroundColor: onBoardingShowed ? AppColors.backgroundColor : AppColors.mainItemColor,
      body: onBoardingShowed
          ? StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userEmail = snapshot.data?.email;
                  if (!fetchedProgram) {
                    _getUserActiveProgram(userEmail);
                    fetchedProgram = true; // Mark as fetched
                  }
                  return widget.navigationShell;
                }
                return widget.navigationShell;
              },
            )
          : Container(
              alignment: Alignment.center,
              color: AppColors.mainItemColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    color: Colors.white,
                    width: size.width / 1.4,
                  )
                      .animate(delay: 300.ms)
                      .flipV(duration: 400.ms)
                      .tint(duration: 1100.ms, color: Colors.amber, delay: 800.ms)
                ],
              ),
            )
              .animate(delay: 300.ms)
              .tint(duration: 1100.ms, color: AppColors.backgroundColor, delay: 2000.ms),
      bottomNavigationBar: onBoardingShowed
          ? BottomNavigationBar(
              backgroundColor: AppColors.mainItemColor,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.amber,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/icons/home.svg",
                      color: indexBottomNavbar == 0 ? Colors.amber : Colors.grey.shade700,
                      width: 28,
                      height: 28,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/icons/explore.svg",
                      color: indexBottomNavbar == 1 ? Colors.amber : Colors.grey.shade700,
                      width: 28,
                      height: 28,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/icons/calendar.png",
                      color: indexBottomNavbar == 2 ? Colors.amber : Colors.grey.shade700,
                      width: 25,
                      height: 25,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/icons/user.png",
                      color: indexBottomNavbar == 3 ? Colors.amber : Colors.grey.shade700,
                      width: 28,
                      height: 28,
                    ),
                    label: ''),
              ],
              currentIndex: indexBottomNavbar,
              onTap: (int index) => _onTap(context, index, ref),
            )
          : null,
    );
  }

  Future<void> _getUserActiveProgram(String? username) async {
    final response = await ref.watch(usersRepositoryProvider).getUser(username);
    if (response != null) {
      final userRes = UserModel.fromJson(response);
      ref.watch(userInformation.notifier).update((state) => userRes);
      user = ref.watch(userInformation);
      if (user.program != "") {
        if (changed == false) {
          ref.watch(indexBottomNavbarProvider.notifier).update(
                (state) => 2,
              );
          widget.navigationShell.goBranch(
            2,
            initialLocation: 2 == widget.navigationShell.currentIndex,
          );
          changed = true;
        }
      }
    }
  }

  void _onTap(BuildContext context, int index, ref) {
    ref.watch(indexBottomNavbarProvider.notifier).update((state) => index);
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
