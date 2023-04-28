import 'package:flutter/material.dart';

class GuessGameProvider extends ChangeNotifier {
  String movie = '';
  String guess = '';
  double sigma = 26;
  bool win = false;
  bool lost = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void isFail() {
    if (guess != movie) {
      if (sigma > 6) {
        sigma -= 5;
        notifyListeners();
      } else {
        lost = true;
        notifyListeners();
      }
    } else {
      print('HAS ACERTADO');
      win = true;
      notifyListeners();
    }
  }
}
