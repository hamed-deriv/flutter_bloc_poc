import 'package:rxdart/subjects.dart';

import 'package:flutter_bloc_poc/custom_cubit/base_entity.dart';

abstract class BaseDependencyResolver<E extends BaseEntity> {
  final String _defaultResolverKey = 'DEFAULT_RESOLVER_KEY';

  final Map<String, BehaviorSubject> _streamControllers =
      <String, BehaviorSubject>{};

  void addStreamController<T>(
    BehaviorSubject<T> streamController, [
    String? key,
  ]) {
    final String controllerKey = getStreamControllerKey(T, key);

    if (_streamControllers.containsKey(controllerKey)) {
      throw Exception('Stream controller already has $controllerKey.');
    }

    _streamControllers[controllerKey] = streamController;
  }

  BehaviorSubject<T> getStreamController<T>([String? key]) {
    final String controllerKey = getStreamControllerKey(T, key);

    if (_streamControllers.containsKey(controllerKey) ||
        _streamControllers[controllerKey] is BehaviorSubject<T>) {
      throw Exception('Can\'t find Stream controller $controllerKey.');
    }

    return _streamControllers[controllerKey] as BehaviorSubject<T>;
  }

  void addCallback(Function(dynamic) callback, [String? key]) =>
      getStreamController(key).listen(callback);

  BehaviorSubject<E> resolve();

  String getStreamControllerKey(Type type, [String? key]) =>
      '${(key ?? _defaultResolverKey)}::$type';
}
