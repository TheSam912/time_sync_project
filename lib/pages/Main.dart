import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../constants/AppColor.dart';
import '../routes/route.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
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
                "assets/icons/ai.png",
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

  void _onTap(BuildContext context, int index, ref) {
    ref.read(indexBottomNavbarProvider.notifier).update((state) => index);
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
