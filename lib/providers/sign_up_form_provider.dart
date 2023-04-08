import 'package:flutter/material.dart';

class SignUpFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String repeatPassword = '';

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
