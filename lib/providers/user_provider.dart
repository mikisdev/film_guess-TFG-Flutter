import 'dart:io';

import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String pictureUrl;
  String name;

  File? image;

  UserProvider(this.name, this.pictureUrl);

  bool isvalidform() {
    return formkey.currentState?.validate() ?? false;
  }

  void notifyListener() {
    notifyListeners();
  }
}
