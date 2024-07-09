import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoProviderModel extends ChangeNotifier {
  bool _initialized = false;
  String _version = "";
  String _buildNumber = "";

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
