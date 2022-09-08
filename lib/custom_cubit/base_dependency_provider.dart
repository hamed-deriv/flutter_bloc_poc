import 'package:rxdart/subjects.dart';

import 'package:flutter_bloc_poc/custom_cubit/base_entity.dart';

abstract class BaseDependencyProvider<E extends BaseEntity> {
  final String _defaultProviderKey = 'DEFAULT_KEY';

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

  BehaviorSubject<E> getStreamResult();

  String getStreamControllerKey(Type type, [String? key]) =>
      '${(key ?? _defaultProviderKey)}::$type';
}
