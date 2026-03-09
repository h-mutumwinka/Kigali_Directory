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
    apiKey: 'AIzaSyB9jV1nyzrvB3J3-qEMlDhKw0h-kcwf2Ms',
    appId: '1:747802091428:web:REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: '747802091428',
    projectId: 'kigali-city-81f21',
    authDomain: 'kigali-city-81f21.firebaseapp.com',
    storageBucket: 'kigali-city-81f21.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9jV1nyzrvB3J3-qEMlDhKw0h-kcwf2Ms',
    appId: '1:747802091428:android:fd2af48870707245df6b31',
    messagingSenderId: '747802091428',
    projectId: 'kigali-city-81f21',
    storageBucket: 'kigali-city-81f21.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:YOUR_APP_ID:ios:YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.firebasestorage.app',
    iosBundleId: 'com.hero.kigaliCity',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: '1:YOUR_APP_ID:macos:YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.firebasestorage.app',
    iosBundleId: 'com.hero.kigaliCity',
  );
}
