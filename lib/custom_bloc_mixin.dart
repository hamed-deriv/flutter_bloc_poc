import 'dart:async';

mixin CustomBloc {
  static const String defaultKey = 'default_stream_controller_key';

  Map<String, StreamController> get streamControllers;
  Map<String, Function(dynamic)> get streamControllerCallbacks;

  String _getKey({required Type type, required String key}) => '$type::$key';

  String _getCallbackName({
    required Type type,
    required String key,
    required String callbackName,
  }) =>
      '${_getKey(type: type, key: key)}::$callbackName';

  void addToSink<T>(T data, [String key = defaultKey]) {
    final String streamControllerKey = _getKey(type: T, key: key);
    final StreamController? streamController =
        streamControllers[streamControllerKey];

    if (streamController == null) {
      throw Exception('Stream controller $streamControllerKey not found.');
    }

    streamController.sink.add(data);
  }

  void addStreamController<T>(
    StreamController<T> streamController, [
    String key = defaultKey,
  ]) {
    final String streamControllerKey = _getKey(type: T, key: key);

    if (streamControllers.containsKey(streamControllerKey)) {
      throw Exception('Stream controller already has $streamControllerKey.');
    }

    streamControllers[streamControllerKey] = streamController;
  }

  void addCallBack<T>({
    required Function(dynamic) streamControllerCallback,
    required String callbackName,
    String key = defaultKey,
  }) {
    final String streamControllerKey = _getKey(type: T, key: key);
    final String functionNameKey =
        _getCallbackName(type: T, key: key, callbackName: callbackName);

    if (streamControllerCallbacks.containsKey(callbackName)) {}

    final StreamController? streamController =
        streamControllers[streamControllerKey];

    if (streamController == null) {
      throw Exception('Stream controller $streamControllerKey not found.');
    }

    streamControllerCallbacks[functionNameKey] = streamControllerCallback;
  }

  void initialListeners() {
    final List<String> streamControllerKeys = streamControllers.keys.toList();

    for (final String key in streamControllerKeys) {
      final List<String> callbackKeys = streamControllerCallbacks.keys
          .where((String callbackKey) => callbackKey.contains(callbackKey))
          .toList();

      for (final String callbackKey in callbackKeys) {
        streamControllers[key]!
            .stream
            .listen(streamControllerCallbacks[callbackKey]);
      }
    }
  }
}
