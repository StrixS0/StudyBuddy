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
    apiKey: 'AIzaSyAnaFYK0liAFawlfDNznP7uvF5iv5jWL-A',
    appId: '1:83318175928:web:587cb25e0ee0b37f921c4d',
    messagingSenderId: '83318175928',
    projectId: 'piamoviles-e42b6',
    authDomain: 'piamoviles-e42b6.firebaseapp.com',
    storageBucket: 'piamoviles-e42b6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAAl3FIjKU157_DhzBkoliY3i8A82Xmq5k',
    appId: '1:83318175928:android:fe271a90dbb51865921c4d',
    messagingSenderId: '83318175928',
    projectId: 'piamoviles-e42b6',
    storageBucket: 'piamoviles-e42b6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCN-ZMoUx7ZSU4I6HE6GYErvA9GbaubejE',
    appId: '1:83318175928:ios:8f65b66a183785b6921c4d',
    messagingSenderId: '83318175928',
    projectId: 'piamoviles-e42b6',
    storageBucket: 'piamoviles-e42b6.appspot.com',
    iosBundleId: 'com.example.piaMoviles',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCN-ZMoUx7ZSU4I6HE6GYErvA9GbaubejE',
    appId: '1:83318175928:ios:c3a58c5cc8d207bf921c4d',
    messagingSenderId: '83318175928',
    projectId: 'piamoviles-e42b6',
    storageBucket: 'piamoviles-e42b6.appspot.com',
    iosBundleId: 'com.example.piaMoviles.RunnerTests',
  );
}
