import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  var user;
  bool changed = false;

  @override
  void initState() {
    super.initState();
    user = ref.read(userInformation);
  }

  @override
  Widget build(BuildContext context) {
    var indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
    return Scaffold(
      // body:widget.navigationShell
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userEmail = snapshot.data?.email;
            _getUserActiveProgram(userEmail);
            return widget.navigationShell;
          }
          return widget.navigationShell;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
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
    ref.read(indexBottomNavbarProvider.notifier).update((state) => index);
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
