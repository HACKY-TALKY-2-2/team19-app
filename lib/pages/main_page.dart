import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/pages/search_page.dart';
import 'package:parking_app/pages/setting_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final Completer<GoogleMapController> _controller = Completer();

  ///로직적으로 currentPostion이 설정될 시 currentLatLng도 설정되도록 코드를 짤것
  Position? currentPosition;
  LatLng? currentLatLng;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    exampleGetApi();
    examplePostApi();
  }

  ///예제 코드 입니다.
  void exampleGetApi() async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        'http://parking-api.jseoplim.com/users',
        //쿼리 파라미터 넣는법
        // queryParameters: {
        //     'query': _controller.text,
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

  void examplePostApi() async {
    final Dio dio = Dio();
    try {
      final response = await dio.post(
        'http://parking-api.jseoplim.com/users',
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,

              //TODO: 솔직히 이거 두개 기능 차이 모르겠음
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,

              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },

              markers: currentLatLng != null
                  ? {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        position: currentLatLng!,
                        icon: BitmapDescriptor.defaultMarker,
                        infoWindow: const InfoWindow(
                          title: "Current Location",
                        ),
                      ),
                    }
                  : {},
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(70, 70)),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              16.0), // 원하는 BorderRadius 설정
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // 첫 번째 버튼 클릭 시 실행할 코드를 여기에 추가하세요.
                      SearchedAddres? result = await showDialog(
                        context: context,
                        barrierDismissible: true, // 다이얼로그 바깥을 터치해서 닫을 수 없도록 설정
                        builder: (BuildContext context) {
                          return const SearchPage(); // 화면 전체를 채우는 다이얼로그
                        },
                      );
                      if (result == null) return;
                      debugPrint("result: $result");
                      final GoogleMapController controller =
                          await _controller.future;

                      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
                        LatLng(result!.lat, result!.lng),
                        15.0,
                      );
                      controller.animateCamera(cameraUpdate);

                      setState(() {
                        currentLatLng = LatLng(result!.lat, result!.lng);
                      });
                    },
                    child: Container(
                      width: 20,
                      decoration: const BoxDecoration(),
                      child: Transform.scale(
                        scale: 1.8,
                        child: Image.asset(
                          'assets/icons/search_color.png',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 35),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(90, 90)),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              16.0), // 원하는 BorderRadius 설정
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // 두 번째 버튼 클릭 시 실행할 코드를 여기에 추가하세요.
                      _getCurrentLocation();
                    },
                    child: Container(
                      width: 20,
                      decoration: const BoxDecoration(),
                      child: Transform.scale(
                        scale: 2.5,
                        child: Image.asset(
                          'assets/icons/current_location_color.png',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 35),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(70, 70)),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              16.0), // 원하는 BorderRadius 설정
                        ),
                      ),
                    ),
                    onPressed: () {
                      // 세 번째 버튼 클릭 시 실행할 코드를 여기에 추가하세요.
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const SettingPage();
                        },
                      ));
                    },
                    child: Container(
                      width: 20,
                      decoration: const BoxDecoration(),
                      child: Transform.scale(
                        scale: 1.8,
                        child: Image.asset(
                          'assets/icons/user_color.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 90, // 하단 여백 조절
              right: 26, // 왼쪽 여백 조절
              child: Column(
                children: [
                  toggleWidget(
                    onImage: 'cctv_on.png',
                    offImage: 'cctv_off.png',
                  ),
                  toggleWidget(
                    onImage: 'complain_on.png',
                    offImage: 'complain_off.jpg',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///현재 위치 가져오고 그 위치로 이동까지 함.
  Future<void> _getCurrentLocation() async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

    // 1. 위치 권한 요청 최적화
    LocationPermission permission = await geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('위치 권한이 거부되었습니다.'),
      ));
      return;
    }

    try {
      // 2. 권한 요청과 위치 정보 가져오기를 병렬로 처리
      var permissionTask = geolocator.requestPermission();
      var positionTask = Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      var permissionResult = await permissionTask;
      if (permissionResult == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('위치 권한이 거부되었습니다.'),
        ));
        return;
      }

      var position = await positionTask;

      setState(() {
        currentPosition = position;
        currentLatLng = LatLng(position.latitude, position.longitude);
      });

      if (currentPosition != null) {
        _moveCameraToCurrentPosition();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _moveCameraToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
      LatLng(currentPosition!.latitude, currentPosition!.longitude),
      15.0,
    );

    controller.animateCamera(cameraUpdate);
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class toggleWidget extends StatefulWidget {
  final String onImage;
  final String offImage;
  bool isOn = false;

  toggleWidget({
    super.key,
    required this.onImage,
    required this.offImage,
  });

  @override
  State<toggleWidget> createState() => _toggleWidgetState();
}

class _toggleWidgetState extends State<toggleWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(60, 60)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // 원하는 BorderRadius 설정
            ),
          ),
        ),
        onPressed: () {
          // 첫 번째 버튼 클릭 시 실행할 코드를 여기에 추가하세요.
          setState(() {
            widget.isOn = !widget.isOn;
          });
        },
        child: Container(
          width: 20,
          decoration: const BoxDecoration(),
          child: Transform.scale(
            scale: 2,
            child: Image.asset(
              widget.isOn
                  ? 'assets/icons/${widget.onImage}'
                  : 'assets/icons/${widget.offImage}',
            ),
          ),
        ),
      ),
    );
  }
}
