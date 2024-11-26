import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/views/home/home_view.dart';
import 'package:testnav/views/home/sub_home_view.dart';
import 'package:testnav/views/player/player_view.dart';
import 'package:testnav/views/settings/settings_view.dart';
import 'package:testnav/views/settings/sub_setting_view.dart';
import 'package:testnav/views/wrapper/main_wrapper.dart';

import '../views/signup_login/login_view.dart';
import '../views/signup_login/signup_view.dart';

class AppNavigation {
  AppNavigation._();

  static String initial = "/login_view";

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorSettings =
      GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Brach Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: "/home",
                name: "Home",
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeView(),
                routes: [
                  GoRoute(
                    path: 'subHome',
                    name: 'subHome',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const SubHomeView(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// Brach Setting
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettings,
            routes: <RouteBase>[
              GoRoute(
                path: "/settings",
                name: "Settings",
                builder: (BuildContext context, GoRouterState state) =>
                    const SettingsView(),
                routes: [
                  GoRoute(
                    path: "subSetting",
                    name: "subSetting",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const SubSettingsView(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      /// signup_login
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/signup_login',
        name: "SignupLogin",
        builder: (BuildContext context, GoRouterState state) =>
        const LoginScreen(),
        routes: [
          GoRoute(
            path: "login_view",
            name: "Login",
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: const LoginScreen(),
                transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                    ) =>
                    FadeTransition(opacity: animation, child: child),
              );
            },
          ),
          GoRoute(
            path: "signup_view",
            name: "Signup",
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: const SignupScreen(),
                transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                    ) =>
                    FadeTransition(opacity: animation, child: child),
              );
            },
          ),
        ],
      ),

      /// Player
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/player',
        name: "Player",
        builder: (context, state) => PlayerView(
          key: state.pageKey,
        ),
      ),
    ],
  );
}
