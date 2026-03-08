// firebase_options.dart — Generated for crimson-arena-fd70b
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return android;
      case TargetPlatform.iOS:     return ios;
      default: throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:            'AIzaSyDs5UWLz-riAMSAfuQSG8FRvWl5-MKumzY',
    appId:             '1:1081897740476:android:44a9c0533d0ff7b60c08b9',
    messagingSenderId: '1081897740476',
    projectId:         'crimson-arena-fd70b',
    databaseURL:       'https://crimson-arena-fd70b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket:     'crimson-arena-fd70b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey:            'AIzaSyDs5UWLz-riAMSAfuQSG8FRvWl5-MKumzY',
    appId:             '1:1081897740476:ios:44a9c0533d0ff7b60c08b9',
    messagingSenderId: '1081897740476',
    projectId:         'crimson-arena-fd70b',
    databaseURL:       'https://crimson-arena-fd70b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket:     'crimson-arena-fd70b.firebasestorage.app',
    iosBundleId:       'com.crimsonarena.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey:            'AIzaSyDs5UWLz-riAMSAfuQSG8FRvWl5-MKumzY',
    appId:             '1:1081897740476:web:44a9c0533d0ff7b60c08b9',
    messagingSenderId: '1081897740476',
    projectId:         'crimson-arena-fd70b',
    databaseURL:       'https://crimson-arena-fd70b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket:     'crimson-arena-fd70b.firebasestorage.app',
    authDomain:        'crimson-arena-fd70b.firebaseapp.com',
  );
}
