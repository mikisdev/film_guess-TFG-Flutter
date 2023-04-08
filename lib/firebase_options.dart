// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAlHjFrjuHyRUcLfb6KcSIQY7k-ZJ7Yl5I',
    appId: '1:627267856862:web:6ee7009a69a3aade14d54f',
    messagingSenderId: '627267856862',
    projectId: 'flutter-tfg-3485d',
    authDomain: 'flutter-tfg-3485d.firebaseapp.com',
    databaseURL: 'https://flutter-tfg-3485d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutter-tfg-3485d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgyyly774FVNSJ8stDRVBLCNCyyznxB_k',
    appId: '1:627267856862:android:8ea638496a7386d514d54f',
    messagingSenderId: '627267856862',
    projectId: 'flutter-tfg-3485d',
    databaseURL: 'https://flutter-tfg-3485d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutter-tfg-3485d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbLvMEbY5LbKMU_v51YNTx_EM-EsCw_MU',
    appId: '1:627267856862:ios:d3f9ea4edacc3c6d14d54f',
    messagingSenderId: '627267856862',
    projectId: 'flutter-tfg-3485d',
    databaseURL: 'https://flutter-tfg-3485d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutter-tfg-3485d.appspot.com',
    iosClientId: '627267856862-b4vl1mlluni9eqjrchve8j4g4auc6j3q.apps.googleusercontent.com',
    iosBundleId: 'com.example.tfg03',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbLvMEbY5LbKMU_v51YNTx_EM-EsCw_MU',
    appId: '1:627267856862:ios:6ef6c28d38271b7c14d54f',
    messagingSenderId: '627267856862',
    projectId: 'flutter-tfg-3485d',
    databaseURL: 'https://flutter-tfg-3485d-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'flutter-tfg-3485d.appspot.com',
    iosClientId: '627267856862-ennierpui15q8k5tpkfngq93uarbb2u3.apps.googleusercontent.com',
    iosBundleId: 'com.example.tfg03.RunnerTests',
  );
}