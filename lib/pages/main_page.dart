import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();
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
        child: GoogleMap(
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
                    markerId: MarkerId("currentLocation"),
                    position: LatLng(
                        currentPosition!.latitude, currentPosition!.longitude),
                    icon: BitmapDescriptor.defaultMarker,
                    infoWindow: InfoWindow(
                      title: "Current Location",
                    ),
                  ),
                }
              : {},
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getCurrentLocation,
        label: Text('현재 위치로 이동'),
        icon: Icon(Icons.location_on),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    LocationPermission permission = await geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
