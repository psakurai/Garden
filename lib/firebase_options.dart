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
    apiKey: 'AIzaSyBWfolKgu3J2TdDyMy3_H-_jLTnMMuH1GM',
    appId: '1:550952461267:web:4c3c3b02d3a069a7618526',
    messagingSenderId: '550952461267',
    projectId: 'garden-381804',
    authDomain: 'garden-381804.firebaseapp.com',
    storageBucket: 'garden-381804.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZNbygUtj4IDNsqUt9xbr24E8EnX4FNtc',
    appId: '1:550952461267:android:e337d98a6c5040bc618526',
    messagingSenderId: '550952461267',
    projectId: 'garden-381804',
    storageBucket: 'garden-381804.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbIMcupKw3Fy4N_3QVVgMuWhA9ShS7LPI',
    appId: '1:550952461267:ios:4129c55b1a880c01618526',
    messagingSenderId: '550952461267',
    projectId: 'garden-381804',
    storageBucket: 'garden-381804.appspot.com',
    iosClientId: '550952461267-ub1f2eu6ici7c9u1c6o13rk1mviu396u.apps.googleusercontent.com',
    iosBundleId: 'com.example.garden',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbIMcupKw3Fy4N_3QVVgMuWhA9ShS7LPI',
    appId: '1:550952461267:ios:4129c55b1a880c01618526',
    messagingSenderId: '550952461267',
    projectId: 'garden-381804',
    storageBucket: 'garden-381804.appspot.com',
    iosClientId: '550952461267-ub1f2eu6ici7c9u1c6o13rk1mviu396u.apps.googleusercontent.com',
    iosBundleId: 'com.example.garden',
  );
}
