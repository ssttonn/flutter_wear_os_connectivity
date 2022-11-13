part of models;

class DataItem {
  final Uri uri;
  final Uint8List data;
  final Map<String, dynamic> mapData;
  final Map<String, File> files;
  DataItem(
      {required this.uri,
      required this.data,
      required this.mapData,
      this.files = const {}});

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
        uri: Uri.tryParse(json["uri"]) ?? Uri(),
        data: json["data"] ?? Uint8List(0),
        mapData: (json["map"] as Map? ?? {})
            .map((key, value) => MapEntry(key.toString(), value)),
        files: (json["file_paths"] as Map? ?? {})
            .map((key, path) => MapEntry(key.toString(), File(path))));
  }
}
