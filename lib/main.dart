import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/pages/main_page.dart';
import 'package:parking_app/providers/main_provider.dart';
import 'package:parking_app/widgets/loading_indicator.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUuid();
  }

  void getUuid() async {
    var uuid = const Uuid().v4();
    String finalUuid = "";

    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    String? cookiesBySecureStorage = await secureStorage.read(key: 'userUuid');
    debugPrint("current UUID :$cookiesBySecureStorage");
    if (cookiesBySecureStorage == null) {
      await secureStorage.write(key: 'userUuid', value: uuid);
      finalUuid = uuid;
    } else {
      finalUuid = cookiesBySecureStorage.toString();
    }
    final Dio dio = Dio();
    try {
      final response = await dio.post(
        'http://parking-api.jseoplim.com/devices',
        //post는 body가 있어야한다.
        data: {
          'deviceToken': finalUuid,
        },
      );

      debugPrint("리스폰스 결과${response.data["detail"]}");
    } on DioException catch (e) {
      if (e.response != null) {
        // DioError contains response data
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending/receiving the request
        print('Error sending request!');
        print(e.message);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      theme: ThemeData(fontFamily: 'Yeongdeok'),
      home: _isLoading ? const LoadingIndicator() : const MainPage(),
    );
  }
}
