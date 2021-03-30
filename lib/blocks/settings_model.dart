import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wevpn/screens/getstarted/select_plan.dart';

import '../navigation_helper.dart';

class SettingsConnectionModel extends ChangeNotifier {

  bool _launchOnStartup = true;
  bool get launchOnStartup => _launchOnStartup;
  set launchOnStartup(bool value) {
    _launchOnStartup = value;
    notifyListeners();
  }

  bool _connectOnLaunch = false;
  bool get connectOnLaunch => _connectOnLaunch;
  set connectOnLaunch(bool value) {
    if (_connectOnLaunch != value) {
      _connectOnLaunch = value;
      notifyListeners();
    }
  }
}

enum ProtocolMode {AUTO, UDP, TCP}

class SettingsProtocolModel extends ChangeNotifier {

  ProtocolMode _mode = ProtocolMode.AUTO;

  ProtocolMode get mode => _mode;
  set mode(ProtocolMode value) {
    if (_mode != value) {
      _mode = value;
      notifyListeners();
    }
  }
}

class SettingsPrivacyModel extends ChangeNotifier {

  bool _vpnKill = true;

  bool get vpnKill => _vpnKill;
  set vpnKill(bool value) {
    if (_vpnKill != value) {
      _vpnKill = value;
      notifyListeners();
    }
  }

  bool _autoReconnect = false;

  bool get autoReconnect => _autoReconnect;
  set autoReconnect(bool value) {
    if (_autoReconnect != value) {
      _autoReconnect = value;
      notifyListeners();
    }
  }
}

class SettingsAutoUpdateModel extends ChangeNotifier {

  bool _enabled = false;

  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      notifyListeners();
    }
  }
}

class AccountModel extends ChangeNotifier {
  static const String _intro_key = 'intro';
  static const String _email_key = 'email';
  static const String _plan_key = 'plan';

  bool _active = false;
  DateTime _renewDate = DateTime.now().add(Duration(days: 24));

  SharedPreferences _prefs;

  String get email => _prefs.getString(_email_key);

  List<Plan> get plans => [
    Plan(id: 0, name: 'Yearly', otherName: 'One-Year Plan', description: '\$69.96 Billed every 12 months', badge: '-47%', trialDaysTitle: 'Start your 7-day free trial.', trialDaysSubtitle: 'Then \$69.96 every 12 months'),
    Plan(id: 1, name: 'Monthly', otherName: 'One-Month Plan', description: '\$10.99 Billed every month', trialDaysTitle: 'Start your 3-day free trial.', trialDaysSubtitle: 'Then \$10.99 every month'),
  ];

  set email(String value) {
    if (value != email) {
      _prefs.setString(_email_key, value);
      notifyListeners();
    }
  }

  Plan get plan {
    if (_prefs.getInt(_plan_key) == null) {
      _prefs.setInt(_plan_key, 0);
    }
    return plans[_prefs.getInt(_plan_key)];
  }

  set plan(Plan value) {
    if (value.id != plan.id) {
      _prefs.setInt(_plan_key, value.id);
      notifyListeners();
    }
  }

  bool get active => _active;

  set active(bool value) {
    if (_active != value) {
      _active = value;
      notifyListeners();
    }
  }

  DateTime get renewDate => _renewDate;

  bool _started = false;

  String get initialRoute {
    if (_started) {
      final email = _prefs.get(_email_key);
      final intro = _prefs.get(_intro_key);

      String route;
      if (email != null) {
        route = NavigationRoute.Main.path;
      } else if (intro == null && intro != false) {
        route = NavigationRoute.Intro.path;
      } else {
        route = NavigationRoute.Login.path;
      }
      print('started -- $route');
      return route;
    } else {
      return NavigationRoute.Splash.path;
    }
  }

  Future<void> start() async {
    _prefs = await SharedPreferences.getInstance();

    Future.delayed(Duration(seconds: 5), () {
      _started = true;
      notifyListeners();
    });
  }

  void introPassed({bool needLogin : false}) {
    _prefs.setBool(_intro_key, true);
    if (needLogin) {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    email = null;
    await start();
  }
}