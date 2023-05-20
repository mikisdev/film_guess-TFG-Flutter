import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:tfg_03/services/services.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/widgets/widgets.dart';
import 'package:tfg_03/providers/providers.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final fireBaseService = Provider.of<FireBaseService>(context);

    return Scaffold(
      body: Stack(
        children: [
          const BackGround(),

          //* Seleccionar foto con cámara
          const Positioned(
            top: 280,
            left: 100,
            child: _CameraButton(),
          ),

          //* Seleccionar imagen de la galería
          const Positioned(
            top: 280,
            right: 100,
            child: _GalleryButton(),
          ),

          const _Profile(),

          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: _DeleteAccount(
              authService: authService,
            ),
          )
        ],
      ),
      //*Botón de guardar
      floatingActionButton: _SaveButton(
          fireBaseService: fireBaseService, authService: authService),
    );
  }
}

//* Icono para acceder a la galeria
class _GalleryButton extends StatelessWidget {
  const _GalleryButton();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authService = Provider.of<AuthService>(context);

    return IconButton(
        onPressed: () async {
          final picker = ImagePicker();

          final XFile? pickedFile = await picker.pickImage(
              source: ImageSource.gallery, imageQuality: 100);

          if (pickedFile == null) {
            print('No seleccionó nada');
            return;
          }

          print('Tenemos una imagen ${pickedFile.path}');

          userProvider.image = File(pickedFile.path);
          print(userProvider.image);
          authService.notifyListener();
        },
        icon: const Icon(
          Icons.photo_outlined,
          color: Colors.grey,
        ));
  }
}

//* Icono para acceder a lac ámara
class _CameraButton extends StatelessWidget {
  const _CameraButton();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return IconButton(
        onPressed: () async {
          final picker = ImagePicker();

          final XFile? pickedFile = await picker.pickImage(
              source: ImageSource.camera, imageQuality: 100);

          if (pickedFile == null) {
            print('No seleccionó nada');
            return;
          }

          print('Tenemos una imagen ${pickedFile.path}');

          userProvider.image = File(pickedFile.path);
          print(userProvider.image);
          userProvider.notifyListener();
        },
        icon: const Icon(
          Icons.camera_alt_outlined,
          color: Colors.grey,
        ));
  }
}

//* boton para guardar los cambios en firebase
class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.fireBaseService,
    required this.authService,
  });

  final FireBaseService fireBaseService;
  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(255, 28, 29, 59),
      onPressed: () async {
        if (!userProvider.isvalidform()) return;

        final String? imageUrl = await uploadImage(userProvider.image);

        if (imageUrl == null && userProvider.name != null) {
          await fireBaseService.updateName(
              authService.readUId(), userProvider.name!);
        }
        if (userProvider.name == null && imageUrl != null) {
          userProvider.pictureUrl = imageUrl;
          await fireBaseService.updatePicture(
              authService.readUId(), userProvider.pictureUrl!);
        } else {
          userProvider.pictureUrl = imageUrl;
          await fireBaseService.updatePictureAndName(authService.readUId(),
              userProvider.name!, userProvider.pictureUrl!);
        }
        userProvider.notifyListener();
        NotificationsService.showSnackbar('Datos guardados', Colors.blue);
      },
      child: const Icon(
        Icons.save_outlined,
        color: AppTheme.secondaryColor,
      ),
    );
  }
}

//* Imagen de perfil
class _Profile extends StatelessWidget {
  const _Profile();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authService = Provider.of<AuthService>(context);
    print('IMAGEN: ${userProvider.image}');
    return FutureBuilder(
      future: getUserData(authService.readUId()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Container();

        final user = snapshot.data;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            //* si ha subido una imagen nueva
            if (userProvider.image != null)
              CircleAvatar(
                  maxRadius: 100,
                  backgroundImage: const AssetImage('assets/no-image.jpg'),
                  foregroundImage: FileImage(userProvider.image!)),
            //* la que ya tenia puesta en la base de datos
            if (userProvider.image == null)
              CircleAvatar(
                maxRadius: 100,
                backgroundImage: const AssetImage('assets/no-image.jpg'),
                foregroundImage: NetworkImage(user['picture']),
              ),
            const SizedBox(
              height: 40,
            ),
            _Form(user: user),
            const SizedBox(
              height: 40,
            ),

            Expanded(child: Container())
          ],
        );
      },
    );
  }
}

//* Botón para eliminar la cuenta
class _DeleteAccount extends StatelessWidget {
  final AuthService authService;

  const _DeleteAccount({
    super.key,
    required this.authService,
  });

  //*Metodo para cuando se use un dispositivo ios
  void displayDialogIOS(BuildContext context) {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Eliminar cuenta'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'La cuenta se eliminará de forma permanente, ¿estás seguro de que quieres hacerlo?'),
                SizedBox(height: 20),
                Image(
                  image: AssetImage('assets/icon.PNG'),
                  height: 100,
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () async {
                    await authService.deleteUser().then((value) {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, 'login');
                    });
                  },
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        });
  }

  //*Metodo para cuando se use un dispositivo Andorid
  void displayDialogAndroid(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Text('Eliminar cuenta'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'La cuenta se eliminará de forma permanente, ¿estás seguro de que quieres hacerlo?'),
                SizedBox(height: 20),
                Image(
                  image: AssetImage('assets/icon.PNG'),
                  height: 100,
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await authService.deleteUser().then((value) {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, 'login');
                    });
                  },
                  child: const Text('Eliminar',
                      style: TextStyle(
                        color: Colors.red,
                      ))),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll<Color>(
              Color.fromARGB(255, 193, 25, 13)),
          elevation: MaterialStateProperty.all<double>(8),
          shadowColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 82, 2, 2).withOpacity(0.8)),
        ),

        //* comprobar si es un dispositivo android o ios
        onPressed: () => Platform.isIOS
            ? displayDialogIOS(context)
            : displayDialogAndroid(context),
        child: const Text(
          "Eliminar cuenta",
          style: TextStyle(color: AppTheme.secondaryColor),
        ));
  }
}

//* Formulario para cambiar el nombre
class _Form extends StatelessWidget {
  const _Form({
    required this.user,
  });

  final user;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Form(
          key: userProvider.formkey,
          child: TextForm(
            validator: (value) {
              if (value == null) return 'Campo obiglatorio';
              if (value.length < 3) return 'tiene que contener más de 3 letras';
              return null;
            },
            onChange: (value) => userProvider.name = value,
            initialValue: user['name'],
            textAlign: TextAlign.center,
          )),
    );
  }
}
