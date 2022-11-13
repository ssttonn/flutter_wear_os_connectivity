library flutter_wear_os_connectivity;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_smart_watch_platform_interface/flutter_smart_watch_platform_interface.dart';

import 'helpers/index.dart';
import 'models/index.dart';

export 'helpers/index.dart'
    show
        UriFilterType,
        CapabilityFilterType,
        MessagePriority,
        DataEventType,
        ObservableType;
export "models/index.dart";

part 'wear_os_observer.dart';
part 'channel.dart';

class FlutterWearOsConnectivity extends FlutterSmartWatchPlatformInterface {
  static registerWith() {
    FlutterSmartWatchPlatformInterface.instance = FlutterWearOsConnectivity();
  }

  late WearOSObserver _wearOSObserver;

  /// Call this method to detect if your phone supports for DataLayerAPI
  @override
  Future<bool> isSupported() async {
    bool? isSupported = await channel.invokeMethod("isSupported");
    return isSupported ?? false;
  }

  /// First call this method to configure all necessary dependencies to interact with Data Layer API
  Future configureWearableAPI() async {
    _wearOSObserver = WearOSObserver();
    return channel.invokeMethod("configure");
  }

  /// Get current connected devices
  ///
  /// This method returns a [List] of [WearOsDevice]
  Future<List<WearOsDevice>> getConnectedDevices() async {
    List rawNodes = await channel.invokeMethod("getConnectedDevices");
    return rawNodes.map((nodeJson) {
      return WearOsDevice.fromRawData(channel, (nodeJson as Map? ?? {}));
    }).toList();
  }

  /// Get current local device (your phone) information
  ///
  /// This method returns a single [WearOsDevice]
  Future<WearOsDevice> getLocalDevice() async {
    Map data = (await channel.invokeMethod("getLocalDeviceInfo")) as Map? ?? {};
    return WearOsDevice.fromRawData(channel, data.toMapStringDynamic());
  }

  /// Call this method when you have a bluetooth address and need to find [WearOsDevice] id
  ///
  /// This method return a nullable [String] value
  Future<String?> findDeviceIdFromBluetoothAddress(String address) async {
    return channel.invokeMethod("findDeviceIdFromBluetoothAddress", address);
  }

  /// Get all available capabilities on device network.
  ///
  /// Each device can declare their new capability via [registerNewCapability] method
  ///
  /// This method return a [Map] of [CapabilityInfo]
  Future<Map<String, CapabilityInfo>> getAllCapabilities(
      {CapabilityFilterType filterType = CapabilityFilterType.all}) async {
    Map data =
        (await channel.invokeMethod("getAllCapabilities", filterType.index));
    return data.map((key, value) => MapEntry(key.toString(),
        CapabilityInfo.fromJson((value as Map? ?? {}).toMapStringDynamic())));
  }

  /// Get capability info via capability name
  ///
  /// This method returns a [CapabilityInfo] instance
  Future<CapabilityInfo?> findCapabilityByName(String name,
      {CapabilityFilterType filterType = CapabilityFilterType.all}) async {
    Map? data = (await channel.invokeMethod("findCapabilityByName",
        {"name": name, "filterType": filterType.index}));
    if (data == null) {
      return null;
    }
    return CapabilityInfo.fromJson(data.toMapStringDynamic());
  }

  /// Announces that a capability has become available on the local device
  ///
  /// After you declare new capability, other devices can see your local device's capabilities via [getAllCapabilities]
  Future<void> registerNewCapability(String name) {
    return channel.invokeMethod("registerNewCapability", name);
  }

  /// Remove a capability from local device
  Future<void> removeExistingCapability(String name) {
    return channel.invokeMethod("removeExistingCapability", name);
  }

  /// Listen to a capability changed
  ///
  /// You can listen to a specific capability via name/path or a group of capability via path
  ///
  /// This [Stream] emit a [CapabilityInfo] each time the capability's changed.
  Stream<CapabilityInfo> capabilityChanged(
      {String? capabilityName,
      Uri? capabilityPath,
      UriFilterType filterType = UriFilterType.literal}) async* {
    if (capabilityName == null && capabilityPath == null) {
      throw "Name or uri must be specified";
    }
    await removeCapabilityListener(
        capabilityName: capabilityName, capabilityUri: capabilityPath);
    await channel.invokeMethod(
        "addCapabilityListener",
        capabilityName != null
            ? {
                "name": capabilityName,
              }
            : {
                "path": capabilityPath.toString(),
                "filterType": filterType.index
              });

    String key = capabilityName ?? capabilityPath.toString();
    Map<String, StreamController<CapabilityInfo>>
        _capabilityInfoStreamControllers =
        _wearOSObserver.streamControllers[ObservableType.capability]
            as Map<String, StreamController<CapabilityInfo>>;
    _capabilityInfoStreamControllers[key] = StreamController.broadcast();
    yield* _capabilityInfoStreamControllers[key]!.stream;
  }

  /// Completely remove a capability listener
  Future<bool> removeCapabilityListener(
      {String? capabilityName, Uri? capabilityUri}) async {
    if (capabilityName == null && capabilityUri == null) {
      throw "Name or uri must be specified";
    }
    String key = capabilityName ?? capabilityUri.toString();
    if (_wearOSObserver.streamControllers[ObservableType.capability]!
        .containsKey(key)) {
      _wearOSObserver.streamControllers[ObservableType.capability]![key]
          ?.close();
      _wearOSObserver.streamControllers[ObservableType.capability]?.remove(key);
    }
    final result = await channel.invokeMethod(
        "removeCapabilityListener",
        capabilityName != null
            ? {"name": capabilityName}
            : {"path": capabilityUri.toString()});
    return result ?? false;
  }

  /// Send message to specified [deviceId]
  Future<int> sendMessage(Uint8List data,
      {required String deviceId,
      required String path,
      MessagePriority priority = MessagePriority.low}) {
    return (channel.invokeMethod<int>("sendMessage", {
      "data": data,
      "nodeId": deviceId,
      "path": path,
      "priority": priority.index
    })).then((messageId) => messageId ?? -1);
  }

  /// Listen to message received events
  ///
  /// Message events can either be listen in specific message path or globally.
  Stream<WearOSMessage> messageReceived(
      {Uri? path, UriFilterType filterType = UriFilterType.literal}) async* {
    await removeMessageListener(path: path);
    await channel.invokeMethod(
        "addMessageListener",
        path == null
            ? {"name": "global_message_channel"}
            : {"path": path.toString(), "filterType": filterType.index});

    String key = path == null ? "global_message_channel" : path.toString();
    Map<String, StreamController<WearOSMessage>> _messageStreamControllers =
        _wearOSObserver.streamControllers[ObservableType.message]
            as Map<String, StreamController<WearOSMessage>>;
    _messageStreamControllers[key] = StreamController.broadcast();
    yield* _messageStreamControllers[key]!.stream;
  }

  /// Remove message listener
  Future removeMessageListener({Uri? path}) {
    String key = path == null ? "global_message_channel" : path.toString();
    if (_wearOSObserver.streamControllers[ObservableType.message]!
        .containsKey(key)) {
      _wearOSObserver.streamControllers[ObservableType.message]![key]?.close();
      _wearOSObserver.streamControllers[ObservableType.message]!.remove(key);
    }
    return channel.invokeMethod(
        "removeMessageListener",
        path == null
            ? {"name": "global_message_channel"}
            : {"path": path.toString()});
  }

  Future<DataItem?> syncData(
      {required String path,
      required Map<String, dynamic> data,
      Map<String, File> files = const {},
      bool isUrgent = false}) async {
    final result = await channel.invokeMethod("syncData", {
      "path": path,
      "isUrgent": isUrgent,
      "rawMapData": data.map((key, value) => MapEntry(key.toString(), value)),
      "rawFilePaths":
          files.map((key, value) => MapEntry(key.toString(), (value.path)))
    }) as Map?;
    if (result != null) {
      return DataItem.fromJson(result.toMapStringDynamic());
    }
    return null;
  }

  Future<int> deleteDataItems(
      {required Uri uri, UriFilterType filterType = UriFilterType.literal}) {
    return channel.invokeMethod("deleteDataItems", {
      "path": uri.toString(),
      "filterType": filterType.index
    }).then((deleteCount) => deleteCount ?? 0);
  }

  Future<List<DataItem>> findDataItems(
      {required Uri uri,
      UriFilterType filterType = UriFilterType.literal}) async {
    List? results = await channel.invokeMethod("getDataItems",
        {"path": uri.toString(), "filterType": filterType.index});
    return (results ?? [])
        .map((result) => DataItem.fromJson((result as Map? ?? {})
            .map((key, value) => MapEntry(key.toString(), value))))
        .toList();
  }

  Future<DataItem?> findDataItemFromUri({required Uri uri}) async {
    Map? result = await channel.invokeMethod("findDataItem", uri.toString());
    return DataItem.fromJson((result ?? {}).toMapStringDynamic());
  }

  Future<List<DataItem>> getAllDataItems() async {
    List? results = await channel.invokeMethod("getAllDataItems");
    return (results ?? [])
        .map((result) =>
            DataItem.fromJson((result as Map? ?? {}).toMapStringDynamic()))
        .toList();
  }

  Stream<List<DataEvent>> dataChanged(
      {Uri? path, UriFilterType filterType = UriFilterType.literal}) async* {
    await removeDataListener(path: path);
    await channel.invokeMethod(
        "addDataListener",
        path == null
            ? {"name": "global_data_channel"}
            : {"path": path.toString(), "filterType": filterType.index});
    String key = path == null ? "global_data_channel" : path.toString();

    Map<String, StreamController<List<DataEvent>>> _dataStreamControllers =
        _wearOSObserver.streamControllers[ObservableType.data]
            as Map<String, StreamController<List<DataEvent>>>;
    _dataStreamControllers[key] = StreamController.broadcast();
    yield* _dataStreamControllers[key]!.stream;
  }

  Future removeDataListener({Uri? path}) {
    String key = path == null ? "global_data_channel" : path.toString();

    if (_wearOSObserver.streamControllers[ObservableType.data]!
        .containsKey(key)) {
      _wearOSObserver.streamControllers[ObservableType.data]![key]!.close();
      _wearOSObserver.streamControllers[ObservableType.data]!.remove(key);
    }
    return channel.invokeMethod(
        "removeDataListener",
        path != null
            ? {"name": "global_data_channel"}
            : {"path": path.toString()});
  }

  @override
  void dispose() {
    _wearOSObserver.streamControllers.values.forEach((childControllers) {
      childControllers.forEach((key, value) {
        value.close();
      });
    });
    _wearOSObserver.streamControllers.clear();
  }
}
