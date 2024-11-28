import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/main.dart';
import 'package:testnav/views/addPatient/addPatient_view.dart';
import 'package:testnav/views/addPatient/imageUploadPage_view.dart';
import 'package:testnav/views/home/home_view.dart';
import 'package:testnav/views/profile/profile_view.dart';
import 'package:testnav/views/search/search_view.dart';
import 'package:testnav/views/signup_login/login_view.dart';
import 'package:testnav/views/signup_login/signup_view.dart';
import 'package:testnav/views/wrapper/main_wrapper.dart';

// Pages Names
//  - /login
//  - /signup
//  - /home
//  - /search
//  - /profile
//  - /addPatient
//  - /addPatient/imageUpload_subview

class AppNavigation {
  AppNavigation._();

  static late String initial;

  static Future<void> setInitial() async {
    bool isLoggedIn = await hs.isLoggedIn();
    // initial = isLoggedIn ? "/home" : "/login";
    initial = "/addPatient/imageUpload_subview";
    log("Since User Is Logged In Initial Route: $initial");
  }

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorAddPatient =
      GlobalKey<NavigatorState>(debugLabel: 'shellAddPatient');
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
          /// Branch addPatient
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAddPatient,
            routes: <RouteBase>[
              GoRoute(
                path: "/addPatient",
                name: "Add Patient",
                builder: (BuildContext context, GoRouterState state) =>
                    const AddPatientView(),
                routes: [
                  GoRoute(
                    path: "imageUpload_subview",
                    name: "Image Upload Page",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: ImageUpload_subview(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeUpwardsPageTransitionsBuilder()
                                .buildTransitions(
                          null,
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Branch Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: "/home",
                name: "Home",
                builder: (BuildContext context, GoRouterState state) =>
                    HomeView(),
              ),
            ],
          ),

          /// Branch Search
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

          /// Branch Profile
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
