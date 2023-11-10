import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/pages/main_page.dart';
import 'package:parking_app/providers/main_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider())
      ],
      child: const MaterialApp(
        title: 'Flutter Google Maps Demo',
        home: MainPage(),
      ),
    );
  }
}
