import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wevpn/screens/main/status.dart';

class ConnectionModel extends ChangeNotifier {

  Status _status = Status.NONE;
  Status get status => _status;

  static const connectingTimeout = Duration(seconds: 5);
  static const disconnectingTimeout = Duration(seconds: 1);

  bool get isConnected => Status.CONNECTED == _status;

  bool get canConnect => [Status.NONE, Status.DISCONNECTED].contains(_status);

  bool get canDisconnect => [Status.CONNECTING, Status.CONNECTED].contains(_status);

  Timer _connectionTimer;

  void connect() {
    if (_status == Status.NONE || _status == Status.DISCONNECTED) {
      _status = Status.CONNECTING;
      notifyListeners();

      _replaceTimer(connectingTimeout, () {
        if (_status == Status.CONNECTING) {
          _status = Status.CONNECTED;
          notifyListeners();
        }
      });
    }

  }

  void disconnect() {

    if (_status == Status.CONNECTING) {
      _status = Status.DISCONNECTED;
      notifyListeners();
      _replaceTimer(disconnectingTimeout, () {
        _skipToNone();
      });
    } else if (_status == Status.CONNECTED) {
      _status = Status.DISCONNECTING;
      notifyListeners();

      _replaceTimer(disconnectingTimeout, () {
        if (_status == Status.DISCONNECTING) {
          _status = Status.DISCONNECTED;
          notifyListeners();

          _replaceTimer(disconnectingTimeout, () {
            _skipToNone();
          });
        }
      });

    }
  }

  void _skipToNone() {
    if (_status == Status.DISCONNECTED) {
      _status = Status.NONE;
      notifyListeners();
    }
  }

  _replaceTimer(Duration duration, VoidCallback callback) {
    if (_connectionTimer != null) {
      _connectionTimer.cancel();
    }

    _connectionTimer = Timer(duration, callback);
  }
}