import 'package:flutter/material.dart';
import '/models/camera_model.dart';
import 'package:dio/dio.dart';

class ApiService extends StatefulWidget {
  static const String baseUrl = "https://parking-api.jseoplim.com";
  static const String cameras = 'cameras';

  const ApiService({super.key});

  @override
  State<ApiService> createState() => _ApiServiceState();
}

class _ApiServiceState extends State<ApiService> {
  void getCameraApi() async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        'http://parking-api.jseoplim.com/$widget.cameras',
        //쿼리 파라미터 넣는법
        //queryParameters: {
        //     'rectangle': 'latitude, longitude',
        //     'key':
        //         'AIzaSyC8wLLyw_26SoLNnnUwdimZ5NXNhdAwGNA', // 여기에 실제 API 키를 넣으세요

        //     'language': 'ko',
        //   },
      );
      for (int i = 0; i < response.data.length; i++) {
        debugPrint("리스폰스 결과${response.data[i]}");
      }
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
  }

  void postCameraApi() async {
    final Dio dio = Dio();
    try {
      final response = await dio.post(
        'http://parking-api.jseoplim.com/$widget.cameras',
        //post는 body가 있어야한다.
        data: {
          'username': 'JohnDoe',
          'email': 'johndoe@example.com',
        },
      );
      for (int i = 0; i < response.data.length; i++) {
        debugPrint("리스폰스 결과${response.data[i]}");
      }
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCameraApi();
    postCameraApi();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
