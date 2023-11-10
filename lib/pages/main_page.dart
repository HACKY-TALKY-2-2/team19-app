import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/pages/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? currentPosition;

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

              markers: currentPosition != null
                  ? {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        position: LatLng(currentPosition!.latitude,
                            currentPosition!.longitude),
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
                    onPressed: () {
                      // 첫 번째 버튼 클릭 시 실행할 코드를 여기에 추가하세요.
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const SearchPage();
                        },
                      ));
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
                    isOn: true,
                  ),
                  toggleWidget(
                    onImage: 'complain_on.png',
                    offImage: 'complain_on.png',
                    isOn: false,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    LocationPermission permission = await geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('위치 권한이 거부되었습니다.'),
      ));
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
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
  bool isOn;

  toggleWidget({
    super.key,
    required this.onImage,
    required this.offImage,
    required this.isOn,
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
