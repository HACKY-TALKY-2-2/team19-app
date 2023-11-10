class CameraModel {
  late final String id, longitude, latitiude;

  CameraModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        longitude = json['longitude'],
        latitiude = json['latitude'];
}
