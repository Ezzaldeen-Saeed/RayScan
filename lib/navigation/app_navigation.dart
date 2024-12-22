import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/main.dart';
import 'package:testnav/views/GetStarted/getStarted_view.dart';
import 'package:testnav/views/addPatient/addPatient_view.dart';
import 'package:testnav/views/addPatient/diagnosisDisplayer.dart';
import 'package:testnav/views/home/home_view.dart';
import 'package:testnav/views/profile/About.dart';
import 'package:testnav/views/profile/Help/help.dart';
import 'package:testnav/views/profile/notification.dart';
import 'package:testnav/views/profile/passwordManager.dart';
import 'package:testnav/views/profile/profile_view.dart';
import 'package:testnav/views/profile/settings.dart';
import 'package:testnav/views/search/patientProfile_view.dart';
import 'package:testnav/views/search/search_view.dart';
import 'package:testnav/views/signup_login/login_view.dart';
import 'package:testnav/views/signup_login/signup_view.dart';
import 'package:testnav/views/wrapper/main_wrapper.dart';

// Pages Names
//  - /login
//  - /signup
//  - /home
//  - /home/latestPatientProfile_subview
//  - /search
//  - /search/patientProfile_subview
//  - /profile
//  - /profile/Settings_subview
//  - /profile/Settings_subview/NotificationSettings_subview
//  - /profile/Settings_subview/PasswordManager_subview
//  - /profile/Help_subview
//  - /profile/About_subview
//  - /addPatient
//  - /addPatient/diagnosisDisplayer_subview

class AppNavigation {
  AppNavigation._();

  static late String initial;

  static Future<void> setInitial() async {
    bool isFinishedTutorial = await hs.isFinishedTutorial();
    bool isFirstTime = await hs.isFirstTime();
    bool isLoggedIn = await hs.isLoggedIn();
    initial = isFirstTime
        ? "/getStarted"
        : !isLoggedIn
            ? "/login"
            : !isFinishedTutorial
                ? "/home"
                : "/home";
    //TODO: Add the get started page
    // initial = "/addPatient";
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

      // Get Started Route
      GoRoute(
        path: '/getStarted',
        name: 'Get Started',
        builder: (BuildContext context, GoRouterState state) =>
            getStarted_view(),
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
              // Add Patient Route
              GoRoute(
                path: "/addPatient",
                name: "Add Patient",
                builder: (BuildContext context, GoRouterState state) =>
                    const AddPatientView(),
                routes: [
                  // Image Upload Subview
                  GoRoute(
                    path: "diagnosisDisplayer_subview",
                    name: "Diagnosis Displayer Page",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: Diagnosisdisplayer_subView(
                          data: state.extra
                              as Map<String, dynamic>?, // Pass the extra data
                        ),
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
              // Home Route
              GoRoute(
                path: "/home",
                name: "Home",
                builder: (BuildContext context, GoRouterState state) =>
                    HomeView(),
                routes: [
                  // Patient Profile Subview
                  GoRoute(
                    path: "latestPatientProfile_subview",
                    name: "Latest patient Profile Page",
                    pageBuilder: (context, state) {
                      // Pass the state to the widget
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: patientProfile_subview(
                          data: state.extra
                              as Map<String, dynamic>?, // Pass the extra data
                        ),
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

          /// Branch Search
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSearch,
            routes: <RouteBase>[
              GoRoute(
                path: '/search',
                name: "Search",
                builder: (BuildContext context, GoRouterState state) =>
                    const SearchView(),
                routes: [
                  // Patient Profile Subview
                  GoRoute(
                    path: "patientProfile_subview",
                    name: "patient Profile Page",
                    pageBuilder: (context, state) {
                      // Pass the state to the widget
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: patientProfile_subview(
                          data: state.extra
                              as Map<String, dynamic>?, // Pass the extra data
                        ),
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

          /// Branch Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                name: "Profile",
                builder: (context, state) => ProfileView(),
                routes: [
                  // Password Manager Subview
                  GoRoute(
                    path: "Settings_subview",
                    name: "Settings Page",
                    pageBuilder: (context, state) {
                      // Pass the state to the widget
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: Settings_subview(),
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
                    routes: [
                      // Notification Settings Subview
                      GoRoute(
                        path: "NotificationSettings_subview",
                        name: "Notification Settings Page",
                        pageBuilder: (context, state) {
                          // Pass the state to the widget
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: NotificationManager_subview(),
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
                      GoRoute(
                        path: "PasswordManager_subview",
                        name: "Password Manager Page",
                        pageBuilder: (context, state) {
                          // Pass the state to the widget
                          return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: Passwordmanager_subview(),
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
                  // Notification Manager Subview
                  GoRoute(
                    path: "Help_subview",
                    name: "Help Page",
                    pageBuilder: (context, state) {
                      // Pass the state to the widget
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: Help_subview(),
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
                  // About Subview
                  GoRoute(
                    path: "About_subview",
                    name: "About Page",
                    pageBuilder: (context, state) {
                      // Pass the state to the widget
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: About_subview(),
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
        ],
      ),
    ],
  );
}
