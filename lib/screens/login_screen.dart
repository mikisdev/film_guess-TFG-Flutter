import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tfg_03/controller/validations_controller.dart';
import 'package:tfg_03/providers/providers.dart';
import 'package:tfg_03/services/auth_service.dart';
import 'package:tfg_03/services/services.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(
      children: [
        BackGround(),
        SingleChildScrollView(
          child: Column(
            children: [
              HeaderLogo(
                height: 200,
                width: 250,
              ),
              _Form()
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
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          //* KEY
          key: loginFormProvider.formKey,

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
                onChange: (value) => loginFormProvider.email = value,
                validator: (val) {
                  if (val == null) return 'Campo requerido';
                  return val.isValidEmail ? null : 'Correo no válido';
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
                onChange: (value) => loginFormProvider.password = value,
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

              //* Boton iniciar sesión
              ElevatedButton(
                  onPressed: loginFormProvider.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          if (!loginFormProvider.isValidForm()) return;

                          loginFormProvider.isLoading = true;

                          final String? errorMessage = await authService.signIn(
                              loginFormProvider.email,
                              loginFormProvider.password);

                          if (errorMessage == null) {
                            //*se inicia sesión
                            Navigator.pushReplacementNamed(context, 'home');
                          } else {
                            loginFormProvider.isLoading = false;
                            //* error al iniciar sesión
                            NotificationsService.showSnackbar(errorMessage);
                            print(errorMessage);
                          }
                        },
                  child: Text(loginFormProvider.isLoading
                      ? 'Espere...'
                      : 'Iniciar Sesión')),
              const SizedBox(
                height: 50,
              ),

              //* TextButton crear cuenta
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'sign_up'),
                  child: const Text(
                    'Crear una cuenta',
                    style: TextStyle(color: AppTheme.secondaryColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
