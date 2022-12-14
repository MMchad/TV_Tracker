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
    apiKey: 'AIzaSyBhbMaiESwIyVUHSoDIYJhuhfC8rATWJxM',
    appId: '1:559574412689:web:69146958743d9f630afe30',
    messagingSenderId: '559574412689',
    projectId: 'tv-tracker-dc626',
    authDomain: 'tv-tracker-dc626.firebaseapp.com',
    storageBucket: 'tv-tracker-dc626.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9R6l-0Tro0Gp6fdbuxHMzAHxCInaIS8Y',
    appId: '1:559574412689:android:63a80092d0b8660a0afe30',
    messagingSenderId: '559574412689',
    projectId: 'tv-tracker-dc626',
    storageBucket: 'tv-tracker-dc626.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEts2sC3HjMVvqtDuU1MVn1wNwoCavFjg',
    appId: '1:559574412689:ios:bf98d1cafd7aaf750afe30',
    messagingSenderId: '559574412689',
    projectId: 'tv-tracker-dc626',
    storageBucket: 'tv-tracker-dc626.appspot.com',
    iosClientId: '559574412689-vaqq3jq1u82t29udbjncm3kos12360o3.apps.googleusercontent.com',
    iosBundleId: 'com.example.tvTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEts2sC3HjMVvqtDuU1MVn1wNwoCavFjg',
    appId: '1:559574412689:ios:bf98d1cafd7aaf750afe30',
    messagingSenderId: '559574412689',
    projectId: 'tv-tracker-dc626',
    storageBucket: 'tv-tracker-dc626.appspot.com',
    iosClientId: '559574412689-vaqq3jq1u82t29udbjncm3kos12360o3.apps.googleusercontent.com',
    iosBundleId: 'com.example.tvTracker',
  );
}
