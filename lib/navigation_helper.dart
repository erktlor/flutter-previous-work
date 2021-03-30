import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wevpn/screens/getstarted/vpn_profile.dart';
import 'package:wevpn/screens/login/login.dart';

import 'blocks/settings_model.dart';
import 'screens/getstarted/choose_theme.dart';
import 'screens/getstarted/getstarted_signup.dart';
import 'screens/getstarted/select_plan.dart';
import 'screens/intro.dart';
import 'screens/main/main.dart';
import 'screens/settings/settings.dart';
import 'screens/splash.dart';

const _splash_path = '/splash';
const _main_path = '/';
const _login_path = '/login';
const _intro_path = '/intro';
const _start_trial_path = '/intro/trial';
const _select_plan = '/intro/plan';
const _vpn_profile_path = '/intro/vpn';
const _choose_theme_path = '/intro/theme';
const _settings_path = '/settings';

enum NavigationRoute {
  Splash,
  Main,
  Login,
  Settings,
  Intro,
  StartTrial,
  SelectPlan,
  VpnProfile,
  ChooseTheme
}

extension NavigationRouteExtension on NavigationRoute {
  String get path {
    switch (this) {
      case NavigationRoute.Splash:
        return _splash_path;
      case NavigationRoute.Main:
        return _main_path;
      case NavigationRoute.Login:
        return _login_path;
      case NavigationRoute.Settings:
        return _settings_path;
      case NavigationRoute.Intro:
        return _intro_path;
      case NavigationRoute.StartTrial:
        return _start_trial_path;
      case NavigationRoute.SelectPlan:
        return _select_plan;
      case NavigationRoute.VpnProfile:
        return _vpn_profile_path;
      case NavigationRoute.ChooseTheme:
        return _choose_theme_path;
      default:
        return null;
    }
  }
}

class NavigationHelper {
  static Widget getWidget(String path) {
    Widget page;
    switch (path) {
      case _splash_path:
        page = Consumer<AccountModel>(builder: (context, startModel, _) {
          if (startModel.initialRoute == NavigationRoute.Splash.path) {
            return SplashScreen();
          } else if (startModel.initialRoute == NavigationRoute.Intro.path) {
            return Intro();
          } else if (startModel.initialRoute == NavigationRoute.Login.path) {
            return Login();
          } else {
            return Main();
          }
        });
        break;
      case _main_path:
        page = Main();
        break;
      case _login_path:
        page = Login();
        break;
      case _intro_path:
        page = Intro();
        break;
      case _start_trial_path:
        page = GetStartedSignupStep();
        break;
      case _select_plan:
        page = SelectPlanStep();
        break;
      case _vpn_profile_path:
        page = VpnProfileStep();
        break;
      case _choose_theme_path:
        page = ChooseThemeStep();
        break;
      case _settings_path:
        page = SettingsPage();
    }
    return page;
  }
  static Route<dynamic> generateRoute(RouteSettings settings) {

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => getWidget(settings.name),
    );
  }
}
