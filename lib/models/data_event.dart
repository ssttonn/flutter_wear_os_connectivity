part of models;

class DataEvent {
  final DataEventType type;
  final DataItem dataItem;
  final bool isDataValid;

  DataEvent(
      {required this.type, required this.dataItem, required this.isDataValid});
  factory DataEvent.fromJson(Map<String, dynamic> json) => DataEvent(
        type: DataEventType.values[(json["type"] as int? ?? 1) - 1],
        dataItem: DataItem.fromJson((json["dataItem"] as Map? ?? {})
            .map((key, value) => MapEntry(key.toString(), value))),
        isDataValid: json["isDataValid"] as bool? ?? false,
      );
}
