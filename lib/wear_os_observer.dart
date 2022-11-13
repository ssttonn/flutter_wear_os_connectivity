part of flutter_wear_os_connectivity;

typedef CapabilityChangedListener = Function(CapabilityInfo);
typedef MessageReceivedListener = Function(WearOSMessage);
typedef DataChangedListener = Function(List<DataEvent>);

class WearOSObserver {
  Map<ObservableType, Map<String, StreamController>> streamControllers = {
    ObservableType.capability: Map<String, StreamController<CapabilityInfo>>(),
    ObservableType.message: Map<String, StreamController<WearOSMessage>>(),
    ObservableType.data: Map<String, StreamController<List<DataEvent>>>()
  };

  WearOSObserver() {
    callbackChannel.setMethodCallHandler(_methodCallhandler);
  }

  Future _methodCallhandler(MethodCall call) async {
    switch (call.method) {
      case "onCapabilityChanged":
        try {
          CapabilityInfo _capabilityInfo = CapabilityInfo.fromJson(
              (call.arguments["data"] as Map? ?? {}).toMapStringDynamic());
          streamControllers[ObservableType.capability]![
                  call.arguments["key"] ?? ""]
              ?.add(_capabilityInfo);
        } catch (e) {
          streamControllers[ObservableType.capability]![
                  call.arguments["key"] ?? ""]
              ?.addError(e);
        }
        break;
      case "onMessageReceived":
        try {
          WearOSMessage _message = WearOSMessage.fromJson(
              (call.arguments["data"] as Map? ?? {}).toMapStringDynamic());
          streamControllers[ObservableType.message]![
                  call.arguments["key"] ?? ""]
              ?.add(_message);
        } catch (e) {
          streamControllers[ObservableType.message]![
                  call.arguments["key"] ?? ""]
              ?.addError(e);
        }
        break;
      case "onDataChanged":
        try {
          List results = call.arguments["data"];
          streamControllers[ObservableType.data]![call.arguments["key"] ?? ""]
              ?.add(results
                  .map((result) => DataEvent.fromJson(
                      (result as Map? ?? {}).toMapStringDynamic()))
                  .toList());
        } catch (e) {
          streamControllers[ObservableType.data]![call.arguments["key"] ?? ""]
              ?.addError(e);
        }
        break;
      case "onErrorDidHappen":
        int? typeIndex = call.arguments["type"] as int?;
        String? key = call.arguments["key"] as String?;
        String? errorCode = call.arguments["errorCode"] as String?;
        String? errorMessage = call.arguments["erroMessage"] as String?;
        if (typeIndex == null ||
            key == null ||
            errorCode == null ||
            errorMessage == null) {
          return;
        }
        streamControllers[ObservableType.values[typeIndex]]![key]?.addError(
            PlatformException(code: errorCode, message: errorMessage));
        break;
    }
  }
}
