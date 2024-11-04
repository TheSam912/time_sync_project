import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_sync/pages/profile/auth/Login.dart';
import 'package:time_sync/pages/today/ai/ai.dart';
import 'package:time_sync/pages/today/ai/ai_response.dart';
import 'package:time_sync/pages/today/ai/routine_plan_ai.dart';
import 'package:time_sync/pages/today/today.dart';
import '../pages/explore/Category.dart';
import '../pages/home/Detail.dart';
import '../pages/profile/program/EditProgram.dart';
import '../pages/explore/Explore.dart';
import '../pages/profile/auth/ForgetPassword.dart';
import '../pages/profile/program/NewProgram.dart';
import '../pages/profile/Profile.dart';
import '../pages/home/Home.dart';
import '../pages/Main.dart';
import '../pages/profile/auth/Register.dart';
import '../pages/profile/program/NewProgram_Routine.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorExploreKey = GlobalKey<NavigatorState>(debugLabel: 'shellExplore');
final _shellNavigatorTodayKey = GlobalKey<NavigatorState>(debugLabel: 'shellToday');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

Widget myTransition(child, animation) {
  return FadeTransition(opacity: CurveTween(curve: Curves.easeIn).animate(animation), child: child);
}

final indexBottomNavbarProvider = StateProvider<int>((ref) {
  return 0;
});

final GoRouter router =
    GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: "/home", routes: <RouteBase>[
  GoRoute(
    path: '/detail',
    name: "detail",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: Detail(
          Id: state.uri.queryParameters['Id'] ?? "",
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  GoRoute(
    path: '/category',
    name: "category",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: Category(category: state.uri.queryParameters['category'] ?? ""),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  GoRoute(
    path: '/newprogram',
    name: "newprogram",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: Newprogram(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  GoRoute(
    path: '/newprogram_routine',
    name: "newprogram_routine",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: NewProgramRoutine(
          title: state.uri.queryParameters['title'] ?? "",
          description: state.uri.queryParameters['description'] ?? "",
          category: state.uri.queryParameters['category'] ?? "",
          sliceTitle1: state.uri.queryParameters['sliceTitle1'] ?? "",
          sliceTitle2: state.uri.queryParameters['sliceTitle2'] ?? "",
          sliceTitle3: state.uri.queryParameters['sliceTitle3'] ?? "",
          sliceTitle4: state.uri.queryParameters['sliceTitle4'] ?? "",
          sliceTitle5: state.uri.queryParameters['sliceTitle5'] ?? "",
          pointList: const [],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  GoRoute(
    path: '/login',
    name: "login",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: const Login(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  GoRoute(
    path: '/register',
    name: "register",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: const Register(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  GoRoute(
    path: '/forgetPassword',
    name: "forgetPassword",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: const ForgetPasswordPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  GoRoute(
    path: '/editProgram',
    name: "editProgram",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: const EditProgram(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  GoRoute(
    path: '/ai',
    name: "ai",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: const ai(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  // GoRoute(
  //   path: '/routinePlanAi',
  //   name: "routinePlanAi",
  //   parentNavigatorKey: _rootNavigatorKey,
  //   pageBuilder: (BuildContext context, GoRouterState state) {
  //     return CustomTransitionPage(
  //       key: state.pageKey,
  //       name: state.name,
  //       child: const RoutinePlanAi(),
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //         return myTransition(child, animation);
  //       },
  //     );
  //   },
  // ),
  GoRoute(
    path: '/aiResponse',
    name: "aiResponse",
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: const AiResponse(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return myTransition(child, animation);
        },
      );
    },
  ),
  StatefulShellRoute.indexedStack(
      builder:
          (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
        return MainPage(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(navigatorKey: _shellNavigatorHomeKey, routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: const Home(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return myTransition(child, animation);
                },
              );
            },
          )
        ]),
        StatefulShellBranch(navigatorKey: _shellNavigatorExploreKey, routes: [
          GoRoute(
            path: '/explore',
            name: 'explore',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: const Explore(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return myTransition(child, animation);
                },
              );
            },
          )
        ]),
        StatefulShellBranch(navigatorKey: _shellNavigatorTodayKey, routes: [
          GoRoute(
            path: '/today',
            name: 'today',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: Today(
                  selectedProgram: state.uri.queryParameters['selectedProgram'] ?? "",
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return myTransition(child, animation);
                },
              );
            },
          )
        ]),
        StatefulShellBranch(navigatorKey: _shellNavigatorProfileKey, routes: [
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: Profile(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return myTransition(child, animation);
                },
              );
            },
          )
        ]),
      ])
]);
