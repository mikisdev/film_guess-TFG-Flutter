import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

//* FUENTE: https://www.youtube.com/watch?v=iAxgbE-a2SI&t=636s&ab_channel=C%C3%B3digoCorrecto

//* para subir una imagen a firebase storage
final FirebaseStorage storage = FirebaseStorage.instance;

//* devuelve la url de la imagen que hemos subido
Future<String?> uploadImage(File? image) async {
  if (image == null) return null;

  //* me da el nombre de la imagen
  final String nameFile = image.path.split('/').last;

  //* Referencia de donde vamos a subir el archivo
  Reference ref = storage.ref().child('userPicture').child(nameFile);

  //* Subimos la imagen al storage
  final UploadTask uploadTask = ref.putFile(image);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  //* URL de la imagen ya subida
  final String url = await snapshot.ref.getDownloadURL();

  if (snapshot.state == TaskState.success) {
    return url;
  } else {
    return null;
  }
}
