import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  getToken();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received: ${message.notification?.title}, ${message.notification?.body}');
  });
  runApp(const ProviderScope(child: MyApp()));
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => ProviderScope(child: MyApp()),
  //   ),
  // );
}

void getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  if (Platform.isIOS) {
  } else {
    String? token = await messaging.getToken();
    print("FCM Token: $token");
  }
}

void setupFirebaseMessaging() {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.requestPermission(
    sound: true,
    badge: true,
    alert: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message while in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TimeSync',
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
