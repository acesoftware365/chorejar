import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

FirebaseOptions get firebaseOptions {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return FirebaseOptions(
      apiKey: "AIzaSyDqpb0so4zRPIpxNE1loI0G1VVz_JXh1Bc",
      appId: "1:196479268137:ios:546fb5c0bb0c1c84a13338",
      messagingSenderId: "196479268137",
      projectId: "chorejar-liisgo-2026",
      iosBundleId: "com.liisgo.chorejar",
    );
  }
  return FirebaseOptions(
    apiKey: "AIzaSyDIN5IR4_e1hASMbhWJyFUrKQWI9XOyyV8",
    appId: "1:196479268137:android:54497d166f9346e1a13338",
    messagingSenderId: "196479268137",
    projectId: "chorejar-liisgo-2026",
  );
}
