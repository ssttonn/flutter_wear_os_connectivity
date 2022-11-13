part of models;

class WearOsDevice {
  ///An opaque string that represents a node in the Android Wear network.
  final String id;

  ///The name of the device.
  final String name;

  ///A [bool] value indicating that this device can be considered geographically nearby the local device.
  final bool isNearby;

  late Future<String?> Function() getCompanionPackageName;

  WearOsDevice({required this.id, required this.name, required this.isNearby});

  factory WearOsDevice.fromJson(Map<String, dynamic> json) => WearOsDevice(
      id: json["id"] as String? ?? "",
      name: json["name"] as String? ?? "",
      isNearby: json["isNearby"] as bool? ?? false);

  factory WearOsDevice.fromRawData(MethodChannel channel, Map data) {
    WearOsDevice _deviceInfo = WearOsDevice.fromJson(
        data.map((key, value) => MapEntry(key.toString(), value)));
    _deviceInfo.getCompanionPackageName = () =>
        channel.invokeMethod("getCompanionPackageForDevice", _deviceInfo.id);
    return _deviceInfo;
  }
}
