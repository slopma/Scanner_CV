
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBmbLej5R3GWhUdYmlQ_8u-cIWAyJ81CT4',
    appId: '1:668526041352:web:908787b22b30ddd60974bd',
    messagingSenderId: '668526041352',
    projectId: 'analisiscv-a2a77',
    authDomain: 'analisiscv-a2a77.firebaseapp.com',
    storageBucket: 'analisiscv-a2a77.firebasestorage.app',
    measurementId: 'G-B5XMPLDS0G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYlYCmC0rp5_P3e1TW0egBOgG7GeJDN4E',
    appId: '1:668526041352:android:5c31bf418e295e810974bd',
    messagingSenderId: '668526041352',
    projectId: 'analisiscv-a2a77',
    storageBucket: 'analisiscv-a2a77.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBmbLej5R3GWhUdYmlQ_8u-cIWAyJ81CT4',
    appId: '1:668526041352:web:c29d77ae48a33aa40974bd',
    messagingSenderId: '668526041352',
    projectId: 'analisiscv-a2a77',
    authDomain: 'analisiscv-a2a77.firebaseapp.com',
    storageBucket: 'analisiscv-a2a77.firebasestorage.app',
    measurementId: 'G-FQ2H7FEDHJ',
  );

}