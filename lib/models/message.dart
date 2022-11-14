part of models;

class WearOSMessage {
  ///An Uin8List payload that represents message data.
  final Uint8List data;

  ///A unique `String` path represents message route within the Android Wear network.
  final String path;

  ///The [String] uniquely identifies the [WearOSMessage] once it is sent.
  final int requestId;

  /// The device ID of the sender.
  final String sourceNodeId;

  WearOSMessage(
      {required this.data,
      required this.path,
      required this.requestId,
      required this.sourceNodeId});

  factory WearOSMessage.fromJson(Map<String, dynamic> json) => WearOSMessage(
      data: json["data"] ?? Uint8List(0),
      path: json["path"] as String? ?? "",
      requestId: json["requestId"] as int? ?? 0,
      sourceNodeId: json["sourceNodeId"] as String? ?? "");
}
