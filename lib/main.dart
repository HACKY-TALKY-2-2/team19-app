import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/pages/main_page.dart';
import 'package:parking_app/providers/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MainProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUuid();
  }

  void getUuid() async {
    var uuid = Uuid().v4();
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    String? cookiesBySecureStorage = await secureStorage.read(key: 'userUuid');
    debugPrint("current UUID :" + cookiesBySecureStorage.toString());
    if (cookiesBySecureStorage == null) {
      await secureStorage.write(key: 'userUuid', value: uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MainPage(),
    );
  }
}
