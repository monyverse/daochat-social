// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_staging.dart';
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
    apiKey: 'AIzaSyBQJDQauzQ8L3vA0HaoXyMHxjAfTaxVHfk',
    appId: '1:1019886962700:web:4846ab413bc943b997adc0',
    messagingSenderId: '1019886962700',
    projectId: 'lemonade-development',
    authDomain: 'lemonade-development.firebaseapp.com',
    storageBucket: 'lemonade-development.appspot.com',
    measurementId: 'G-CJ2PDGK7DV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDqmuE_rWF1rT25EnGOuYubkq2WFwoMRs',
    appId: '1:1019886962700:android:0a92cdc86475e714340629',
    messagingSenderId: '1019886962700',
    projectId: 'lemonade-development',
    storageBucket: 'lemonade-development.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYBJZc55LlC-onxJYtKn8H00Y4gD7y9C8',
    appId: '1:1019886962700:ios:e169ddb278aeb42c340629',
    messagingSenderId: '1019886962700',
    projectId: 'lemonade-development',
    storageBucket: 'lemonade-development.appspot.com',
    iosBundleId: 'social.lemonade.app.staging',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYBJZc55LlC-onxJYtKn8H00Y4gD7y9C8',
    appId: '1:1019886962700:ios:e169ddb278aeb42c340629',
    messagingSenderId: '1019886962700',
    projectId: 'lemonade-development',
    storageBucket: 'lemonade-development.appspot.com',
    iosBundleId: 'com.lemonadesocial.app.RunnerTests',
  );
}
