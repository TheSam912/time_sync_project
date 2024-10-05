import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/Category.dart';
import '../pages/Detail.dart';
import '../pages/EditProgram.dart';
import '../pages/Explore.dart';
import '../pages/ForgetPassword.dart';
import '../pages/NewProgram.dart';
import '../pages/NewProgram_Routine.dart';
import '../pages/Profile.dart';
import '../pages/Home.dart';
import '../pages/Main.dart';
import '../pages/Register.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorExploreKey = GlobalKey<NavigatorState>(debugLabel: 'shellExplore');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

Widget myTransition(child, animation) {
  return FadeTransition(opacity: CurveTween(curve: Curves.easeIn).animate(animation), child: child);
}

final GoRouter router =
    GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: '/home', routes: <RouteBase>[
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
          pointList: [],
        ),
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
        child: Register(),
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
        child: ForgetPasswordPage(),
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
        child: EditProgram(),
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
                child: Home(),
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
                child: Explore(),
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
                child: Profile(
                  selectedProgram: state.uri.queryParameters['selectedProgram'] ?? "",
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return myTransition(child, animation);
                },
              );
            },
          )
        ]),
      ])
]);
