part of models;

class CapabilityInfo {
  ///Name of capability
  final String name;

  ///A Set of [WearOsDevice] indicating which devices associated with corresponding capability.
  final Set<WearOsDevice> associatedDevices;
  CapabilityInfo({required this.name, required this.associatedDevices});

  factory CapabilityInfo.fromJson(Map<String, dynamic> json) {
    return CapabilityInfo(
        name: json["name"] as String? ?? "",
        associatedDevices: (json["associatedNodes"] as List? ?? [])
            .map((nodeJson) => WearOsDevice.fromRawData(
                channel,
                (nodeJson as Map? ?? {})
                    .map((key, value) => MapEntry(key.toString(), value))))
            .toSet());
  }
}
