# Flutter WearOS Connectivity
[![Version](https://img.shields.io/pub/v/flutter_wear_os_connectivity?color=%23212121&label=Version&style=for-the-badge)](https://pub.dev/packages/flutter_wear_os_connectivity)
[![Publisher](https://img.shields.io/pub/publisher/flutter_wear_os_connectivity?color=E94560&style=for-the-badge)](https://pub.dev/publishers/sstonn.xyz)
[![Points](https://img.shields.io/pub/points/flutter_wear_os_connectivity?color=FF9F29&style=for-the-badge)](https://pub.dev/packages/flutter_wear_os_connectivity)
[![LINCENSE](https://img.shields.io/github/license/ssttonn/flutter_wear_os_connectivity?color=0F3460&style=for-the-badge)](https://github.com/ssttonn/flutter_wear_os_connectivity/blob/master/LICENSE)

<img src="https://lh3.googleusercontent.com/sgOTO5d4GOFYcS1AuBTFE437uZ0thonKstWgaY_raYv6ZfjZXeukGwujnHN8qjPs5xfnp-vtKIgXqq442dV13nA2roqJc_cChA=rw-e365-w1200"/>

A plugin that provides a wrapper that enables Flutter apps to communicate with apps running on WearOS.

> Note: I'd also written packages to communicate with WatchOS devices, you can check it out right [here](https://pub.dev/packages/flutter_watch_os_connectivity).

## Table of contents
- [Screenshots](#screenshots)
- [Supported platforms](#supported_platforms)
- [Features](#main_features)
- [Getting started](#getting_started)
- [Configuration](#configuration)
    - [Android](#android_configuration)
- [How to use](#how_to_use)
    - [Get started](#get_started)
        - [Import the library](#get_started_1)
        - [Create new instance of `FlutterWatchOsConnectivity`](#get_started_2)
    - [Configuring Data Layer API dependencies](#configuring_activation)
        - [Configure](#configuring_activation_1)
    - [Obtaning connected devices in Android Wear network](#getting_paired_device_accessibility)
        - [Obtaining all connected devices](#getting_paired_device_accessibility_1)
        - [Obtaining local device](#getting_paired_device_accessibility_2)
        - [Find Device ID from bluetooth address](#getting_paired_device_accessibility_3)
	- [Start Remote Activity](#start_remote_activity)				
    - [Advertise and query remote capabilities](#handling_capabilities)
        - [Advertise new device capability](#handling_capabilities_1)
        - [Remove existing capability](#handling_capabilities_2)
        - [Obtain all available capabilities on Android Wear network](#handling_capabilities_3)
        - [Find a capability by name](#handling_capabilities_4)
        - [Subscribing to capability changed](#handling_capabilities_5)
        - [Unsubscribing to capability changed](#handling_capabilities_6)
    - [Sending and handling `WearOsMessage`](#send_message)
        - [Send a message to a specific path](#send_message_1)
        - [Listen to upcoming `WearOsMessage` receive events](#send_message_2)
        - [Unlisten for upcoming `WearOsMessage` receive events](#send_message_3)
    - [Synchronize and manage `DataItem`](#sync_data)
        - [Synchronize data on specific path](#sync_data_1)
        - [Sync files to specific path](#sync_data_2)
        - [Obtain all available `DataItems`](#sync_data_3)
        - [Find `DataItem` from specific path](#sync_data_4)
        - [Find `DataItems` from specific path](#sync_data_5)
        - [Delete `DataItems` from specific path](#sync_data_6)
        - [Listen to upcoming `DataItem` change or delete events](#sync_data_7)
        - [Unlisten to `DataItem` changed](#sync_data_8)

## Screenshots <a name="screenshots"/>

## Supported platforms <a name="supported_platforms"></a>
- Android

## Features <a name="main_features"></a>
Use this plugin in your Flutter app to:
- Communicate with WearOS application. 
- Send message data.
- Obtaining and handling data items.
- Sync data.
- Transfer files.
- Obtain connected device list.
- Detect other devices capabilities.

## Getting started <a name="getting_started"/>
For WatchOS companion app, this plugin uses [Watch Connectivity](https://developer.apple.com/documentation/watchconnectivity) framework under the hood to communicate with IOS app.

## Configuration <a name="configuration"/>

### Android <a name="android_configuration"/>

1. Create an WearOS companion app, you can follow this [instruction](https://developer.android.com/training/wearables/get-started/creating#creating) to create new WearOS app.

> Note: The WearOS companion app package name must be same as your Android app package name in order to communicate with each other.

That's all, you're ready to communicate with WearOS app now.


## How to use <a name="how_to_use"/>
### Get started <a name="get_started"/>
#### Import the library <a name="get_started_1"/>

```dart
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
```

#### Create new instance of `FlutterWearOsConnectivity` <a name="get_started_2"/>

```dart
FlutterWearOsConnectivity _flutterWearOsConnectivity =
      FlutterWearOsConnectivity();
```
---
### Configuring Data Layer API dependencies <a name="configuring_activation"/>

#### Configure <a name="configuring_activation_1"/>

> NOTE: Your will unable to use other methods if you don't call `configureWearableAPI()` method.

```dart
_flutterWearOsConnectivity.configureWearableAPI();
```

---
### Obtaning connected devices in Android Wear network <a name="getting_paired_device_accessibility"/>
Each Android device can connect to many WearOS devices at the same time, so you should keep track on all available devices.

<img src="https://developer.android.com/static/wear/images/wear_cloud_node.png"/>

For each `WearOsDevice` in Android Wear network, Google Server generates a corresponding path.

For example: `wear://<deviceId>/<customPath>`

`WearOsDevice` has following properties:
- `id`
An opaque string that represents a `WearOsDevice` in the Android Wear network.

- `name`
The name of the `WearOsDevice`.

- `isNearby`
A `bool` value indicating that this `WearOsDevice` can be considered geographically nearby the local `WearOsDevice`.

- `getCompanionPackageName`
A method gets the package name for the Companion application associated with this `WearOsDevice`.

#### Obtaining all connected devices <a name="getting_paired_device_accessibility_1"/>
Get current connected devices in Android Wear network. This method returns a `List` of `WearOsDevice`.

```dart
List<WearOsDevice> _connectedDevices = await _flutterWearOsConnectivity.getConnectedDevices();
```

#### Obtaining local device <a name="getting_paired_device_accessibility_2"/>
Get current local device (your phone) information. This method returns a single `WearOsDevice` object shows local device information.

```dart
WearOsDevice _localDevice = await _flutterWearOsConnectivity.getLocalDevice();
```

#### Find Device ID from bluetooth address <a name="getting_paired_device_accessibility_3"/>
Call this method when you have a bluetooth address and need to find `WearOsDevice`'s id. This method return a nullable `String` value indicating whether a device is exist on Android Wear network.

```dart
String? deviceId = await _flutterWearOsConnectivity.findDeviceIdFromBluetoothAddress("AA-AA-AA-AA-AA-AA");
```

---
### Start Remote Activity <a name="start_remote_activity"/>

Support for opening android intents on other devices. 
Example to open your app in the Google Play Store on the Watch
```dart
const playStoreUrl = 'http://play.google.com/store/apps/details?id=com.example.app'
_flutterWearOsConnectivity.getConnectedDevices().then((value) async{
      for (final watch in value) {
        await _flutterWearOsConnectivity.startRemoteActivity(url: playStoreUrl, deviceId: watch.id);
      }
    });
```

---
### Advertise and query remote capabilities <a name="handling_capabilities"/>
`FlutterWearOsConnectivity` plugin provides information on which `WearOsDevice`s on the Android Wear network support which custom app capabilities. `WearOsDevice`s represent both mobile and wearable devices that are connected to the network. A capability is a feature that an app defines.

For example, a mobile Android app could advertise that it supports remote control of video playback. When the wearable version of that app is installed, it can use the `FlutterWearOsConnectivity` plugin to check if the mobile version of the app is installed and supports that feature. If it does, the wearable app can show the play/pause button to control the video on the other device using a message.

This can also work in the opposite direction, with the wearable app listing capabilities it supports.

The capability information will be retrieved as `CapabilityInfo` object.

`CapabilityInfo` object contains following properties:
- `name`
Name of capability which can be declared from [Advertise new device capability](#handling_capabilities_1).

- `associatedDevices`
A `Set` of `WearOsDevice` indicating which devices associated with corresponding capability.

#### Advertise new device capability <a name="handling_capabilities_1"/>
Announces that a capability has become available on the local device. After you declare new capability, other devices can see your local device's capabilities via `getAllCapabilities` method.

There are two ways to do that:

1/ Declare new capabilities inside `res/values/wear.xml`:
    
- Create an XML configuration file in the res/values/ directory of your project and name it wear.xml.
- Add a resource named android_wear_capabilities to wear.xml.
- Define capabilities that the device provides.

```xml
<resources xmlns:tools="http://schemas.android.com/tools"
           tools:keep="@array/android_wear_capabilities">
    <string-array name="android_wear_capabilities">
        <item>sample_capability_1</item>
        <item>sample_capability_2</item>
        <item>sample_capability_3</item>
        <item>sample_capability_4</item>
    </string-array>
</resources>
```

2/ Declare new capabilities with `registerNewCapability(name)` method of `FlutterWearOsConnectivity`:
```dart
await Future.wait([
_flutterWearOsConnectivity.registerNewCapability("sample_capability_1"),
_flutterWearOsConnectivity.registerNewCapability("sample_capability_2"),
_flutterWearOsConnectivity.registerNewCapability("sample_capability_3"),
_flutterWearOsConnectivity.registerNewCapability("sample_capability_4")
]);
```

#### Remove existing capability <a name="handling_capabilities_2"/>
If you don't want to advertise a capability anymore, you can just simply remove it by calling `removeExistingCapability(name)`. 
```dart
await _flutterWearOsConnectivity.removeExistingCapability("sample_capability_1");
```

#### Obtain all available capabilities on Android Wear network <a name="handling_capabilities_3"/>
You can also get all available capabilies associated with other devices on Android Wear network.

```dart
List<CapabilityInfo> _availableCapabilities = _flutterWearOsConnectivity.getAllCapabilities();
```

#### Find a capability by name <a name="handling_capabilities_4"/>
Find `CapabilityInfo` via capability name. This method returns a nullable `CapabilityInfo` instance indicating whether a capability is existed.

```dart
CapabilityInfo? _capabilityInfo = await _flutterWearOsConnectivity.findCapabilityByName("sample_capability_1");
```

#### Subscribing to capability changed <a name="handling_capabilities_5"/>
You can either listen to `CapabilityInfo` changed via capability name

```dart
_flutterWearOsConnectivity.capabilityChanged(capabilityName: "sample_capability_1").listen((capabilityInfo) {
    inspect(capabilityInfo);
});
```

Or via capability path
```dart
_flutterWearOsConnectivity.capabilityChanged(capabilityPathURI: Uri(scheme: "wear", host: "*", path: "/sample_capability_1")).listen((capabilityInfo) {
    inspect(capabilityInfo);
});
```
>Note: Capability path is provided in following format by Wear network: `wear://*/<capabilityName>`


#### Unsubscribing to capability changed <a name="handling_capabilities_6"/>
You can either unlisten to CapabilityInfo changed via capability name
```dart
_flutterWearOsConnectivity.removeCapabilityListener(capabilityName: "sample_capability_1");
```

Or via capability path

```dart
_flutterWearOsConnectivity.removeCapabilityListener(capabilityPathURI: Uri(scheme: "wear", host: "*", path: "/sample_capability_1"));
```
> Note: Capability path is provided in following format by Wear network: `wear://*/<capabilityName>`

---
### Sending and handling `WearOsMessage` <a name="send_message"/>
Messages are stored in a unique path within the Android Wear network. Messaging is a good one-way communication mechanism for remote procedure calls (RPC), such as sending a message to a wearable to initiate an activity.

> Note: Message paths are auto-generated by Android Wear network in the following format: `wear://<deviceId>/<messagePath>`

Message is presented in `WearOSMessage` object. 

`WearOSMessage` has following properties:

- `data`
An Uin8List payload that represents message data.

- `path`
A unique `String` path represents message route within the Android Wear network.

- `requestId`
The `String` uniquely identifies the `WearOSMessage` once it is sent.

- `senderDeviceId`
The device ID of the sender.

#### Send a message to a specific path <a name="send_message_1"/>
You can send a message to other devices
```
String requestId = await _flutterWearOsConnectivity.sendMessage(bytes, 
    deviceId: _selectedDevice!.id, path: "/sample-message", 
    message, 
    priority: MessagePriority.low
).then(print);
```

The system will opportunely send the message, if you have a message you want to send immediately, set the `priority` to `MessagePriority.high`

#### Listen to upcoming `WearOsMessage` receive events <a name="send_message_2"/>
You can either listen to global message receive events
```dart
_flutterWearOsConnectivity.messageReceived().listen((message) {
    inspect(message);
});
```

Or listen to message events that belong to a specific message `path`

```dart
_flutterWearOsConnectivity.messageReceived(pathURI: Uri(scheme: "wear", host: _selectedDevice?.id, path: "/wearos-message-path")).listen((message) {
    inspect(message);
});
```

In a example above, you're listen to a path on specific device, you can also listen to a path on all devices associated with Android Wear network.

```dart
_flutterWearOsConnectivity.messageReceived(pathURI: Uri(scheme: "wear", host: "*", path: "/wearos-message-path")).listen((message) {
    inspect(message);
});
```

> Note: In the example above, the host is setted to `*`, which means that all devices on current Android Wear network will be matched.

#### Unlisten for upcoming `WearOsMessage` receive events <a name="send_message_3"/>
You can either unlisten to global message received events
```dart
_flutterWearOsConnectivity.removeMessageListener();
```

Or unlisten to message events that belong to a specific message `path`

```dart
_flutterWearOsConnectivity.removeMessageListener(pathURI: Uri(
    scheme: "wear",
    host: _selectedDevice?.id, // specific device id
    path: "/wearos-message-path"
));

_flutterWearOsConnectivity.removeMessageListener(pathURI: Uri(
    scheme: "wear",
    host: "*", // all devices
    path: "/wearos-message-path"
));
```

---
### Synchronize and manage `DataItem` <a name="sync_data"/>
Same as messages, data items are also store in a unique path within the Android Wear network. A `DataItem` is synchronized across all devices in an Android Wear network. It is possible to set data items while not connected to any nodes. Those data items will be synchronized when the nodes eventually come online.

> Note: Data paths are auto-generated by Android Wear network in the following format: `wear://<deviceId>/<dataPath>`

The data will be constructed inside `DataItem` object.

`DataItem` object contains following properties:
- `data`
An Uin8List payload that represents the encoded data.

- `pathURI`
A unique `Uri` path represents data route within the Android Wear network.

- `mapData`
A human-readable `Map<String, dynamic>` data of `data`.

- `files`
List of files contained inside this `DataItem`.

#### Synchronize data on specific path <a name="sync_data_1"/>
To sync `DataItem` on a specific path, call `syncData` method

```dart
DataItem? _dataItem = await _flutterWearOsConnectivity.syncData(path: "/data-path", data: {
    "message": "Data sync by AndroidOS app on /data-path at ${DateTime.now().millisecondsSinceEpoch}"
}, isUrgent: false);
```

This method return an optional `DataItem` indicating whether the `DataItem` is successfully synchronized.

The system will opportunely sync the data, if you want your `DataItem` to be synchronized immediately, set `isUrgent` to `true`.

#### Sync files to specific path <a name="sync_data_2"/>
Not only for data, we can also synchronize files by specify `files` parameter, which acccepts a `Map<String, File>`.  

```dart
XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
if (file != null) {
    _flutterWearOsConnectivity.syncData(path: "/data-image-path", data: {
        "message":  "Data sync by AndroidOS app at ${DateTime.now().millisecondsSinceEpoch}",
        "count": 10,
        "bytearray8": Uint8List(8),
        "bytearray16": Uint16List(16),
        "sampleChildMap": {
            "message": Data sync by AndroidOS app at ${DateTime.now().millisecondsSinceEpoch}",
                "count": 10,
                "bytearray8": Uint8List(8),
                "bytearray16": Uint16List(16),
                "sampleMap": {"key": "sadas"}
            }
        },
        /// Specifiy files that you want to syncronize right here
        files: {
            "sample-image": File(file.path),
            "sample-image1": File(file.path),
            "sample-image2": File(file.path),
        }
    );
}
```

#### Obtain all available `DataItems` <a name="sync_data_3"/>
You can obtain all available `DataItems` on Android Wear network by calling `getAllDataItems` method

```dart
List<DataItem> _allDataItems = await _flutterWearOsConnectivity.getAllDataItems();
```

#### Find `DataItem` from specific path <a name="sync_data_4"/>
You can also find a `DataItem` on specific path by calling `findDataItemOnPath` method

> Note: In order to specificly find a `DataItem`, you must provide a full URI path, which mean all components of that URI must not contain wildcard value (`*`)

```dart
DataItem? _foundDataItem = await _flutterWearOsConnectivity.findDataItemOnPath(pathURI: Uri(scheme: "wear", host: "123456", path: "/data-path"));
```

This method returns an optional `DataItem` indicating whether the `DataItem` can be found.

#### Find `DataItems` from specific path <a name="sync_data_5"/>
You can also find all `DataItems` that associated with specific path by calling `findDataItemsOnPath` method
> Note: If URI path is fully specified, this method will find at most one data item. If path contains a wildcard host, multiple data items may be found, since different devices may create data items with the same path. See [this](https://developers.google.com/android/reference/com/google/android/gms/wearable/DataClient) for details of the URI format.

```dart
List<DataItem> _foundDataItems = await _flutterWearOsConnectivity.findDataItemsOnPath(pathURI: Uri(scheme: "wear", host: "*", path: "/data-path"));
```

#### Delete `DataItems` from specific path <a name="sync_data_6"/>
You can also delete all `DataItems` on a specific path.
>Note: If URI path is fully specified, this method will delete at most one data item. If path contains a wildcard host, multiple data items may be deleted, since different devices may create data items with the same path. See [this](https://developers.google.com/android/reference/com/google/android/gms/wearable/DataClient) for details of the URI format.

#### Listen to upcoming `DataItem` change or delete events <a name="sync_data_7"/>
`DataItem` change or delete events will be constructed inside `DataEvent` objects

`DataEvent` object contains following properties:
- `dataItem`
The `DataItem` associated with this event.

- `type`
The `DataEventType` enum value indicating which type of event is it. Can be `changed` or `deleted`.

- `isDataValid`
A `bool` value indicating if this data is valid

You can either listen to global data changed events

```dart
_flutterWearOsConnectivity.dataChanged().listen((dataEvents) {
    inspect(dataEvents)              
});
```

Or listen to specific path data events

```dart
_flutterWearOsConnectivity.dataChanged(
    pathURI: Uri(
        scheme: "wear",
        host: "*",
        path: "/wearos-message-path")
    .listen((dataEvents) {
        inspect(dataEvents);
    }
);
```

#### Unlisten to `DataItem` changed <a name="sync_data_8"/>
You can either unlisten to global data changed events

```dart
await _flutterWearOsConnectivity.removeDataListener();
```

Or unlisten to specific path data events

```dart
await _flutterWearOsConnectivity.removeDataListener(
    pathURI: Uri(
        scheme: "wear",
        host: "*",
        path: "/wearos-message-path"
    )
);
```

For more details, please check out my [Flutter example project](https://github.com/ssttonn/flutter_watch_os_connectivity/tree/master/example) and [WearOS example project](https://github.com/ssttonn/WearOSTestApp).