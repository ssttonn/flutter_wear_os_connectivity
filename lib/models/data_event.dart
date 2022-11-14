part of models;

class DataEvent {
  ///The [DataEventType] enum value indicating which type of event is it. Can be [DataEventType.changed] or [DataEventType.deleted].
  final DataEventType type;

  ///The [DataItem] associated with this event.
  final DataItem dataItem;

  /// A [bool] value indicating if this data is valid
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
