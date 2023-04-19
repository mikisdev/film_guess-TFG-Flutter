import 'package:flutter/material.dart';

class GuessGameProvider extends ChangeNotifier {
  String movie = '';
  String guess = '';
  double sigma = 26;
  bool win = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  bool isFail() {
    if (guess != movie) {
      if (sigma > 6) {
        sigma -= 5;
        win = false;
        notifyListeners();
        return win;
      } else {
        win = false;
        notifyListeners();
        return win;
      }
    } else {
      print('HAS ACERTADO');
      win = true;
      notifyListeners();
      return win;
    }
  }
}
