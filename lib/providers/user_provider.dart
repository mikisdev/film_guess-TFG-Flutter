import 'dart:io';

import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? pictureUrl;
  String name;

  File? image;

  UserProvider(this.name, this.pictureUrl);

  bool isvalidform() {
    return formkey.currentState?.validate() ?? false;
  }

  void notifyListener() {
    notifyListeners();
  }

  //* al crear un nuevo usuario se le crea sin foto por lo que se pone esta de forma automática
  get getPicture {
    if (pictureUrl != null) return pictureUrl;

    return 'https://steamuserimages-a.akamaihd.net/ugc/795369537926935378/0BA040D30C76B548DD0F9787912948C10D952164/?imw=512&&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false';
  }
}
