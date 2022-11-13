part of models;

class WearOSMessage {
  final Uint8List data;
  final String path;
  final int requestId;
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
