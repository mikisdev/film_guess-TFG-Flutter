import 'package:flutter/material.dart';
import 'package:tfg_03/themes/app_theme.dart';

class TextForm extends StatelessWidget {
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final String? labelText;
  final IconData? suffixIcon;
  final bool autocorrect;
  final Function(String)? onChange;
  //* Código adaptado de https://blog.logrocket.com/flutter-form-validation-complete-guide/
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextAlign textAlign;

  const TextForm({
    super.key,
    this.keyboardType,
    this.obscureText = false,
    this.autocorrect = false,
    this.validator,
    this.onChange,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.initialValue,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign,
      initialValue: initialValue,
      autocorrect: autocorrect,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChange,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          suffixIcon: Icon(suffixIcon)),
      style: const TextStyle(color: AppTheme.secondaryColor),
    );
  }
}
