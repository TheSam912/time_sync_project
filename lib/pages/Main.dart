import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../constants/AppColor.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.mainItemColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/home.svg",
                color: navigationShell.currentIndex == 0 ? Colors.amber : Colors.grey.shade700,
                width: 28,
                height: 28,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/explore.svg",
                color: navigationShell.currentIndex == 1 ? Colors.amber : Colors.grey.shade700,
                width: 28,
                height: 28,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/user.png",
                color: navigationShell.currentIndex == 2 ? Colors.amber : Colors.grey.shade700,
                width: 25,
                height: 25,
              ),
              label: ''),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
