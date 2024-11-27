import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/main.dart';
import 'package:testnav/views/addPatient/addPatient_view.dart';
import 'package:testnav/views/home/home_view.dart';
import 'package:testnav/views/profile/profile_view.dart';
import 'package:testnav/views/search/search_view.dart';
import 'package:testnav/views/signup_login/login_view.dart';
import 'package:testnav/views/signup_login/signup_view.dart';
import 'package:testnav/views/wrapper/main_wrapper.dart';

class AppNavigation {
  AppNavigation._();

  static late String initial;

  static Future<void> setInitial() async {
    bool isLoggedIn = await hs.isLoggedIn();
    initial = isLoggedIn ? "/home" : "/login";
    log("Since User Is Logged In Initial Route: $initial");
  }

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorSettings =
      GlobalKey<NavigatorState>(debugLabel: 'shellSettings');
  static final _shellNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: 'shellProfile');
  static final _shellNavigatorSearch =
      GlobalKey<NavigatorState>(debugLabel: 'shellSearch');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Login Route
      GoRoute(
        path: '/login',
        name: 'Login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginView(),
      ),

      // Signup Route
      GoRoute(
        path: '/signup',
        name: 'Signup',
        builder: (BuildContext context, GoRouterState state) =>
            const SignupView(),
      ),

      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Brach addPatient
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettings,
            routes: <RouteBase>[
              GoRoute(
                path: "/addPatient",
                name: "Add Patient",
                builder: (BuildContext context, GoRouterState state) =>
                    const AddPatientView(),
                // When adding the Pages Inside the Home
                // routes: [
                //   GoRoute(
                //     path: "subSetting",
                //     name: "subSetting",
                //     pageBuilder: (context, state) {
                //       return CustomTransitionPage<void>(
                //         key: state.pageKey,
                //         child: const SubSettingsView(),
                //         transitionsBuilder: (
                //           context,
                //           animation,
                //           secondaryAnimation,
                //           child,
                //         ) =>
                //             FadeTransition(opacity: animation, child: child),
                //       );
                //     },
                //   ),
                // ],
              ),
            ],
          ),

          /// Brach Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: "/home",
                name: "Home",
                builder: (BuildContext context, GoRouterState state) =>
                    HomeView(),
                // When adding the Pages Inside the Home
                // routes: [
                //   GoRoute(
                //     path: 'subHome',
                //     name: 'subHome',
                //     pageBuilder: (context, state) => CustomTransitionPage<void>(
                //       key: state.pageKey,
                //       child: const SubHomeView(),
                //       transitionsBuilder:
                //           (context, animation, secondaryAnimation, child) =>
                //               FadeTransition(opacity: animation, child: child),
                //     ),
                //   ),
                // ],
              ),
            ],
          ),

          /// Brach Search
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearch,
            routes: <RouteBase>[
              GoRoute(
                path: '/search',
                name: "Search",
                builder: (context, state) => SearchView(),
              ),
            ],
          ),

          /// Brach Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                name: "Profile",
                builder: (context, state) => ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}