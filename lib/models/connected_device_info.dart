part of models;

class DataLayerAPIDevice {
  final String id;
  final String name;
  final bool isNearby;

  late Future<String?> Function() getCompanionPackageName;

  DataLayerAPIDevice(
      {required this.id, required this.name, required this.isNearby});

  factory DataLayerAPIDevice.fromJson(Map<String, dynamic> json) =>
      DataLayerAPIDevice(
          id: json["id"] as String? ?? "",
          name: json["name"] as String? ?? "",
          isNearby: json["isNearby"] as bool? ?? false);

  factory DataLayerAPIDevice.fromRawData(MethodChannel channel, Map data) {
    DataLayerAPIDevice _deviceInfo = DataLayerAPIDevice.fromJson(
        data.map((key, value) => MapEntry(key.toString(), value)));
    _deviceInfo.getCompanionPackageName = () =>
        channel.invokeMethod("getCompanionPackageForDevice", _deviceInfo.id);
    return _deviceInfo;
  }
}
