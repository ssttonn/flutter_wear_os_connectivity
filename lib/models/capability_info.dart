part of models;

class CapabilityInfo {
  final String name;
  final Set<DataLayerAPIDevice> associatedDevices;
  CapabilityInfo({required this.name, required this.associatedDevices});

  factory CapabilityInfo.fromJson(Map<String, dynamic> json) {
    return CapabilityInfo(
        name: json["name"] as String? ?? "",
        associatedDevices: (json["associatedNodes"] as List? ?? [])
            .map((nodeJson) => DataLayerAPIDevice.fromRawData(
                channel,
                (nodeJson as Map? ?? {})
                    .map((key, value) => MapEntry(key.toString(), value))))
            .toSet());
  }
}
