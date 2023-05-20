import 'dart:io';

import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? pictureUrl;
  String? name;

  File? image;

  bool _isKeyboardVisible = false;

  bool get isKeyboardVisible {
    return _isKeyboardVisible;
  }

  set isKeyboardVisible(bool value) {
    _isKeyboardVisible = value;
    notifyListeners();
  }

  bool isvalidform() {
    return formkey.currentState?.validate() ?? false;
  }

  void notifyListener() {
    notifyListeners();
  }
}
