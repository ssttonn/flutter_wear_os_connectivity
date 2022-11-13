# Flutter WearOS Connectivity
[![Version](https://img.shields.io/pub/v/flutter_wear_os_connectivity?color=%23212121&label=Version&style=for-the-badge)](https://pub.dev/packages/flutter_wear_os_connectivity)
[![Publisher](https://img.shields.io/pub/publisher/flutter_wear_os_connectivity?color=E94560&style=for-the-badge)](https://pub.dev/publishers/sstonn.xyz)
[![Points](https://img.shields.io/pub/points/flutter_watch_os_connectivity?color=FF9F29&style=for-the-badge)](https://pub.dev/packages/flutter_wear_os_connectivity)
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
        - [Getting current paired device information](#getting_paired_device_accessibility_1)
        - [Listen to paired device information changed](#getting_paired_device_accessibility_2)
        - [Getting reachability of `WatchOsPairedDeviceInfo`](#getting_paired_device_accessibility_3)
        - [Listen `WatchOsPairedDeviceInfo` reachability state changed
        ](#getting_paired_device_accessibility_4)
    - [Sending and handling messages](#send_message)
        - [Send message](#send_message_1)
        - [Send message and wait for reply](#send_message_2)
        - [Receive messages](#send_message_3)
        - [Reply the message](#send_message_4)
    - [Obtaining and syncing `ApplicationContext`](#application_context)
        - [Obtaining an `ApplicationContext`](#application_context_1)
        - [Syncing an `ApplicationContext`](#application_context_2)
        - [Listen to `ApplicationContext` changed](#application_context_3)
    - [Transfering and handling user info with `UserInfoTransfer`](#transfer_user_info)
        - [Transfering user info](#transfer_user_info_1)
        - [Canceling an `UserInfoTransfer`](#transfer_user_info_2)
        - [Obtaining the number of complication transfers remaining](#transfer_user_info_3)
        - [Waiting for upcoming `UserInfoTransfer`s](#transfer_user_info_4)
        - [Obtaning a list of pending `UserInfoTransfer`](#transfer_user_info_5)
        - [Listen to pending `UserInfoTransfer` list changed](#transfer_user_info_6)
        - [Listen to the completion event of `UserInfoTransfer`](#transfer_user_info_7)
    - [Transfering and handling `File` with `FileTransfer`](#transfer_file)
        - [Transfering file](#transfer_file_1)
        - [Obtaning current on progress `UserInfoTransfer` list](#transfer_file_2)
        - [Canceling a `FileTransfer`](#transfer_file_3)
        - [Obtaning a list of pending `FileTransfer`](#transfer_file_4)
        - [Listen to pending `FileTransfer` list changed](#transfer_file_5)
        - [Waiting for upcoming `FileTransfer`s](#transfer_file_6)
        - [Listen to the completion event of `FileTransfer`](#transfer_file_7)

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

An opaque string that represents a device in the Android Wear network.

- `name`

The name of the device.

- `isNearby`

A `bool` value indicating that this device can be considered geographically nearby the local device.

- `getCompanionPackageName`

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
You can listen to `CapabilityInfo` changed via capability name

```dart
_flutterWearOsConnectivity.capabilityChanged(capabilityName: "sample_capability_1").listen((capabilityInfo) {
    inspect(capabilityInfo);
});
```

Or via capability path
```dart
_flutterWearOsConnectivity.capabilityChanged(capabilityPath: Uri(scheme: "wear", host: "*", path: "/sample_capability_1")).listen((capabilityInfo) {
    inspect(capabilityInfo);
});
```
>Note: Capability path is provided in following format by Wear network: `wear://*/<capabilityName>`


#### Unsubscribing to capability changed <a name="handling_capabilities_6"/>
You can also unlisten to CapabilityInfo changed via capability name
```dart
_flutterWearOsConnectivity.removeCapabilityListener(capabilityName: "sample_capability_1");
```

Or via capability path

```dart
_flutterWearOsConnectivity.removeCapabilityListener(capabilityPath: Uri(scheme: "wear", host: "*", path: "/sample_capability_1"));
```
> Note: Capability path is provided in following format by Wear network: `wear://*/<capabilityName>`

---
### Sending and handling `WearOsMessage` <a name="send_message"/>
#### Listen to upcoming `WearOsMessage` receive events <a name="send_message_1"/>
#### Unlisten for upcoming `WearOsMessage` receive events <a name="send_message_2"/>
---
### Synchronize and manage `DataItem` <a name="sync_data"/>
#### Synchronize data on specific path <a name="sync_data_1"/>
#### Find `DataItem` from specific path <a name="sync_data_2"/>
#### Find `DataItem` list from specific path <a name="sync_data_3"/>
#### Delete `DataItem` list from specific path <a name="sync_data_4"/>
#### Obtain all available `DataItem`s <a name="sync_data_5"/>
#### Listen to upcoming `DataItem` changed <a name="sync_data_6"/>
#### Unlisten to `DataItem` changed <a name="sync_data_7"/>