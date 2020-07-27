import 'package:evgeshayoga/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

class InfoProviderModel extends ChangeNotifier {
  bool _initialized = false;
  String _version;
  String _buildNumber;

  String get version => _version;
  String get buildNumber => _buildNumber;

  void initialize() {
    if (_initialized) {
      return;
    }
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
        _initialized = true;
        notifyListeners();
    });
  }
}
