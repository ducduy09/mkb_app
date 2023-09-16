// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class SettingScreen1 extends ChangeNotifier{
  bool _Dark = false;
  get Dark => _Dark;
  void setBrightness(bool value){
    _Dark = value;
    notifyListeners();
  }
}