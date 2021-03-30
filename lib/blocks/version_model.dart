import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

class VersionModel extends ChangeNotifier {

  String _projectCode;
  String _projectVersion;

  String get projectVersion => _projectVersion;
  String get projectCode => _projectCode;

  Future<void> readPlatformVersion() async {
// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _projectVersion = await GetVersion.projectVersion;
      _projectCode = await GetVersion.projectCode;

       notifyListeners();
    } on PlatformException {
      _projectVersion = '0.0.0';
      _projectCode = '0';
    }
  }
}