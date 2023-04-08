import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tfg_03/controller/validations_controller.dart';
import 'package:tfg_03/providers/providers.dart';
import 'package:tfg_03/services/auth_service.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/widgets/widgets.dart';

//Todo: GUARDAR NOMBRE DE USUARIO Y CORREO EN LA BASE DE DATOS
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const BackGround(),
        SingleChildScrollView(
          child: Column(
            children: [
              const HeaderLogo(
                height: 200,
                width: 250,
              ),
              ChangeNotifierProvider(
                create: (_) => SignUpFormProvider(),
                child: const _Form(),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

//*Widget del formulario
class _Form extends StatelessWidget {
  const _Form({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final signUpFormProvider = Provider.of<SignUpFormProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Form(
          //* KEY
          key: signUpFormProvider.formKey,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //*Email
              TextForm(
                autocorrect: true,
                keyboardType: TextInputType.emailAddress,
                hintText: 'ejemplo@gmail.com',
                labelText: 'Correo electrónico',
                suffixIcon: Icons.mail_outline,
                onChange: (value) => signUpFormProvider.email = value,
                validator: (value) {
                  if (value == null) return 'Campo requerido';
                  return value.isValidEmail ? null : 'Correo no válido';
                },
              ),
              const SizedBox(
                height: 30,
              ),
              //*Usuario
              TextForm(
                autocorrect: true,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Usuario',
                labelText: 'Usuario',
                suffixIcon: Icons.person_outline,
                onChange: (value) => signUpFormProvider.name = value,
                validator: (value) {
                  if (value == null) return 'Campo requerido';
                  return (value.length >= 4)
                      ? null
                      : 'El usuario debe tener al menos 4 caractéres';
                },
              ),
              const SizedBox(
                height: 30,
              ),

              //* Contraseña
              TextForm(
                obscureText: true,
                hintText: '*********',
                labelText: 'Contraseña',
                suffixIcon: Icons.lock_outline,
                onChange: (value) => signUpFormProvider.password = value,
                validator: (value) {
                  //TODO: Implementar una mejor validación
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe tener al menos 6 caracteres';
                },
              ),
              const SizedBox(
                height: 30,
              ),

              //* Repetir ontraseña
              TextForm(
                obscureText: true,
                hintText: '*********',
                labelText: 'Repetir Contraseña',
                suffixIcon: Icons.lock_outline,
                onChange: (value) => signUpFormProvider.repeatPassword = value,
                validator: (value) {
                  //TODO: Implementar una mejor validación

                  return (identical(value, signUpFormProvider.repeatPassword))
                      ? null
                      : 'Las contraseñas no coinciden';
                },
              ),
              const SizedBox(
                height: 30,
              ),

              //* Boton registrarse
              ElevatedButton(
                  onPressed: () async {
                    if (!signUpFormProvider.isValidForm()) return;

                    final authService =
                        Provider.of<AuthService>(context, listen: false);
                    final String? errorMessage = await authService.signUp(
                        email: signUpFormProvider.email,
                        password: signUpFormProvider.password,
                        name: signUpFormProvider.name);

                    if (errorMessage == null) {
                      //* se ha creado el usuario
                      Navigator.pushReplacementNamed(context, 'login');
                    } else {
                      //* error al registrar el usuario
                      //Todo: Mostrar mensje de error
                      print(errorMessage);
                    }
                  },
                  child: const Text('Registrarse')),
              const SizedBox(
                height: 30,
              ),

              //* TextButton crear cuenta
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'login'),
                  child: const Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(color: AppTheme.secondaryColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
