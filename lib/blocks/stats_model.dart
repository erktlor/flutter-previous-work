import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wevpn/screens/main/status.dart';

class StatsModel extends ChangeNotifier {
  final _random = new Random();
  int _up = 0;
  int _down = 0;
  DateTime _startedTime;
  Duration _duration = Duration();
  Timer _timer;

  String getUp() => "$_up kbps";

  String getDown() => "$_down kbps";

  String getDuration() {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    return "${twoDigits(_duration.inMinutes)}:${twoDigits(_duration.inSeconds - _duration.inMinutes * 60)}";
  }

  stop() {
    _up = 0;
    _down = 0;
    _duration = Duration();
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    notifyListeners();
  }

  int nextRandom(int min, int max) => min + _random.nextInt(max - min);

  start({int seconds = 3}) {
    _startedTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: seconds), (timer) {
      _duration = DateTime.now().difference(_startedTime);
      _down = nextRandom(30, 50);
      _up = nextRandom(10, 20);
      notifyListeners();
    });
    _down = 39;
    _up = 15;
    _duration = DateTime.now().difference(_startedTime);
    notifyListeners();
  }

  void update(Status status) {
    if (status == Status.CONNECTED) {
      start(seconds: 1);
    } else {
      stop();
    }
  }

}
