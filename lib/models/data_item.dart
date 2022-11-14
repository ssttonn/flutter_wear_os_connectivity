part of models;

class DataItem {
  ///A unique URI path represents data route within the Android Wear network.
  final Uri pathURI;

  ///An Uin8List payload that represents the encoded data.
  final Uint8List data;

  ///A human-readable [Map] data of [data].
  final Map<String, dynamic> mapData;

  ///List of files contained inside this[DataItem]
  final Map<String, File> files;
  DataItem(
      {required this.pathURI,
      required this.data,
      required this.mapData,
      this.files = const {}});

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
        pathURI: Uri.tryParse(json["uri"]) ?? Uri(),
        data: json["data"] ?? Uint8List(0),
        mapData: (json["map"] as Map? ?? {})
            .map((key, value) => MapEntry(key.toString(), value)),
        files: (json["file_paths"] as Map? ?? {})
            .map((key, path) => MapEntry(key.toString(), File(path))));
  }
}
