import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets/spacing_column.dart';

class MyAndroidApp extends StatefulWidget {
  const MyAndroidApp({Key? key}) : super(key: key);

  @override
  State<MyAndroidApp> createState() => _MyAndroidAppState();
}

class _MyAndroidAppState extends State<MyAndroidApp> {
  FlutterWearOsConnectivity _flutterWearOsConnectivity =
      FlutterWearOsConnectivity();
  List<DataLayerAPIDevice> _deviceList = [];
  DataLayerAPIDevice? _selectedDevice;
  WearOSMessage? _currentMessage;
  DataItem? _dataItem;
  List<StreamSubscription<WearOSMessage>> _messageSubscriptions = [];
  List<StreamSubscription<List<DataEvent>>> _dataEventsSubscriptions = [];
  StreamSubscription<CapabilityInfo>? _connectedDeviceCapabilitySubscription;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _flutterWearOsConnectivity.configureWearableAPI().then((_) {
      _flutterWearOsConnectivity.getConnectedDevices().then((value) {
        _updateDeviceList(value.toList());
      });
      // _flutterWearOsConnectivity
      //     .findCapabilityByName("flutter_smart_watch_connected_nodes")
      //     .then((info) {
      //   _updateDeviceList(info!.associatedDevices.toList());
      // });
      _flutterWearOsConnectivity.getAllDataItems().then(inspect);
      _connectedDeviceCapabilitySubscription = _flutterWearOsConnectivity
          .capabilityChanged(
              capabilityPath: Uri(
                  scheme: "wear", // Default scheme for WearOS app
                  host: "*", // Accept all path
                  path:
                      "/flutter_smart_watch_connected_nodes" // Capability path
                  ))
          .listen((info) {
        if (info.associatedDevices.isEmpty) {
          setState(() {
            _selectedDevice = null;
          });
        }
        _updateDeviceList(info.associatedDevices.toList());
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _flutterWearOsConnectivity.dispose();
    _clearAllListeners();
  }

  _clearAllListeners() {
    _connectedDeviceCapabilitySubscription?.cancel();
  }

  void _updateDeviceList(List<DataLayerAPIDevice> devices) {
    setState(() {
      _deviceList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: SingleChildScrollView(
            child: SpacingColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _devicesWidget(theme),
                if (_selectedDevice != null) _deviceUtils(theme)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _devicesWidget(ThemeData theme) {
    return Column(
      children: _deviceList.map((info) {
        bool isSelected = info.id == _selectedDevice?.id;
        Color mainColor = !isSelected ? theme.primaryColor : Colors.white;
        Color secondaryColor = isSelected ? theme.primaryColor : Colors.white;
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(info.name,
                    style: theme.textTheme.headline6
                        ?.copyWith(color: theme.primaryColor)),
                Text("Device ID: ${info.id}"),
                Text("Is nearby: ${info.isNearby}")
              ],
            )),
            CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(isSelected ? "Selected" : "Select",
                      style: theme.textTheme.subtitle1
                          ?.copyWith(color: secondaryColor)),
                ),
                onPressed: () {
                  setState(() {
                    if (_selectedDevice != null) {
                      _selectedDevice = null;
                      _messageSubscriptions.forEach((subscription) {
                        subscription.cancel();
                      });
                      _messageSubscriptions.clear();
                      _dataEventsSubscriptions.forEach((subscription) {
                        subscription.cancel();
                      });
                      _dataEventsSubscriptions.clear();
                      return;
                    }
                    _selectedDevice = info;
                    _messageSubscriptions.add(_flutterWearOsConnectivity
                        .messageReceived(
                            path: Uri(
                                scheme: "wear",
                                host: _selectedDevice?.id,
                                path: "/wearos-message-path"))
                        .listen((message) {
                      setState(() {
                        _currentMessage = message;
                      });
                    }));
                    _dataEventsSubscriptions.add(_flutterWearOsConnectivity
                        .dataChanged()
                        .listen((events) {
                      setState(() {
                        if (events[0].dataItem.uri.path == "/data-image-path") {
                          _imageFile = events[0].dataItem.files["sample-image"];
                        }
                        _dataItem = events[0].dataItem;
                      });
                    }));
                  });
                })
          ]),
        );
      }).toList(),
    );
  }

  Widget _deviceUtils(ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(10)),
      child: SpacingColumn(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Received message: ", style: theme.textTheme.headline6),
          ..._currentMessage != null
              ? [
                  Text("Raw Data: ${_currentMessage?.data.toString()}"),
                  Text(
                      "Decrypted Data: ${String.fromCharCodes(_currentMessage!.data).toString()}"),
                  Text("Message path: ${_currentMessage!.path}"),
                  Text("Request ID: ${_currentMessage!.requestId}"),
                  Text("Device id: ${_currentMessage!.sourceNodeId}")
                ]
              : [],
          CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Send example message",
                  style:
                      theme.textTheme.subtitle1?.copyWith(color: Colors.white),
                ),
              ),
              onPressed: () {
                List<int> list =
                    'Sample message from Android app at ${DateTime.now().millisecondsSinceEpoch}'
                        .codeUnits;
                Uint8List bytes = Uint8List.fromList(list);
                _flutterWearOsConnectivity
                    .sendMessage(bytes,
                        deviceId: _selectedDevice!.id, path: "/sample-message")
                    .then(print);
              }),
          Text("Latest sync data: ", style: theme.textTheme.headline6),
          ..._dataItem != null
              ? [
                  Text("Raw Data: ${_dataItem!.data.toString()}"),
                  Text("Decrypted Data: ${_dataItem!.mapData["message"]}"),
                  Text("Data path: ${_dataItem!.uri.path}"),
                ]
              : [],
          CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Sync current data",
                  style:
                      theme.textTheme.subtitle1?.copyWith(color: Colors.white),
                ),
              ),
              onPressed: () {
                _flutterWearOsConnectivity
                    .syncData(path: "/data-image-path", data: {
                  "message":
                      "Data sync by AndroidOS app at ${DateTime.now().millisecondsSinceEpoch}"
                }).then((value) {
                  _flutterWearOsConnectivity
                      .findDataItemFromUri(uri: value!.uri)
                      .then(inspect);
                });
              }),
          if (_imageFile != null) Image.file(_imageFile!),
          CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Pick image and sync image data",
                  style:
                      theme.textTheme.subtitle1?.copyWith(color: Colors.white),
                ),
              ),
              onPressed: () async {
                XFile? file =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (file != null) {
                  _flutterWearOsConnectivity
                      .syncData(path: "/data-image-path", data: {
                    "message":
                        "Data sync by AndroidOS app at ${DateTime.now().millisecondsSinceEpoch}",
                    "count": 10,
                    "bytearray8": Uint8List(8),
                    "bytearray16": Uint16List(16),
                    "sampleMap": {
                      "message":
                          "Data sync by AndroidOS app at ${DateTime.now().millisecondsSinceEpoch}",
                      "count": 10,
                      "bytearray8": Uint8List(8),
                      "bytearray16": Uint16List(16),
                      "sampleMap": {"key": "sadas"}
                    }
                  }, files: {
                    "sample-image": File(file.path),
                    "sample-image1": File(file.path),
                    "sample-image2": File(file.path),
                  });
                }
              }),
        ],
      ),
    );
  }
}
