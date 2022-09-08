import 'dart:async';

mixin CustomBloc {
  final Map<String, StreamController> _streamControllers =
      <String, StreamController>{};
  final Map<String, Function(dynamic)> _streamControllerCallbacks =
      <String, Function(dynamic)>{};

  void initialListeners({
    Map<String, StreamController>? streamControllers,
    Map<String, Function(dynamic)>? streamControllerCallbacks,
  }) {
    for (final MapEntry<String, StreamController<dynamic>> streamController
        in _streamControllers.entries) {
      _addStreamController(
        streamController: streamController.value,
        key: streamController.key,
      );
    }

    // for (final MapEntry<String, dynamic Function(dynamic)> callback
    //     in _streamControllerCallbacks.entries) {
    //   _addCallBack(
    //     streamControllerCallback: callback.value,
    //     callbackName: callback.key,
    //     key: key,
    //   );
    // }

    final List<String> streamControllerKeys = _streamControllers.keys.toList();

    for (final String key in streamControllerKeys) {
      final List<String> callbackKeys = _streamControllerCallbacks.keys
          .where((String callbackKey) => callbackKey.contains(callbackKey))
          .toList();

      for (final String callbackKey in callbackKeys) {
        _streamControllers[key]!
            .stream
            .listen(_streamControllerCallbacks[callbackKey]);
      }
    }
  }

  void addToSink<T>({required T data, required String key}) {
    final String streamControllerKey = _getKey(type: T, key: key);
    final StreamController<T>? streamController =
        _streamControllers[streamControllerKey] as StreamController<T>;

    if (streamController == null) {
      throw Exception('Stream controller $streamControllerKey not found.');
    }

    streamController.sink.add(data);
  }

  void _addStreamController<T>({
    required StreamController<T> streamController,
    required String key,
  }) {
    final String streamControllerKey = _getKey(type: T, key: key);

    if (_streamControllers.containsKey(streamControllerKey)) {
      throw Exception('Stream controller already has $streamControllerKey.');
    }

    _streamControllers[streamControllerKey] = streamController;
  }

  void _addCallBack<T>({
    required Function(dynamic) streamControllerCallback,
    required String callbackName,
    required String key,
  }) {
    final String streamControllerKey = _getKey(type: T, key: key);
    final String functionNameKey =
        _getCallbackName(type: T, key: key, callbackName: callbackName);

    if (_streamControllerCallbacks.containsKey(functionNameKey)) {
      throw Exception(
        '$functionNameKey is already added to $streamControllerKey.',
      );
    }

    final StreamController? streamController =
        _streamControllers[streamControllerKey];

    if (streamController == null) {
      throw Exception('Stream controller $streamControllerKey not found.');
    }

    _streamControllerCallbacks[functionNameKey] = streamControllerCallback;
  }

  String _getKey({required Type type, required String key}) => '$type::$key';

  String _getCallbackName({
    required Type type,
    required String key,
    required String callbackName,
  }) =>
      '${_getKey(type: type, key: key)}::$callbackName';
}
