import 'package:flutter/material.dart';

class BiometricAuthModel extends ChangeNotifier {
  bool _biometricEnabled = false;

  bool get biometricEnabled => _biometricEnabled;

  set biometricEnabled(bool value) {
    _biometricEnabled = value;
    notifyListeners();
  }
}
