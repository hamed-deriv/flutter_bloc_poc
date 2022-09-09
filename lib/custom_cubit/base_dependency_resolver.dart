import 'package:rxdart/subjects.dart';

import 'package:flutter_bloc_poc/custom_cubit/base_entity.dart';

abstract class BaseDependencyResolver<E extends BaseEntity> {
  final String _defaultResolverKey = 'DEFAULT_RESOLVER_KEY';

  final Map<String, BehaviorSubject> _stream = <String, BehaviorSubject>{};

  void addStream<T>(BehaviorSubject<T> stream, [String? key]) {
    final String streamKey = getStreamKey<T>(key);

    if (_stream.containsKey(streamKey)) {
      throw Exception('Stream already has $streamKey.');
    }

    _stream[streamKey] = stream;
  }

  BehaviorSubject<T> getStream<T>([String? key]) {
    final String streamKey = getStreamKey<T>(key);

    if (_stream.containsKey(streamKey) ||
        _stream[streamKey] is BehaviorSubject<T>) {
      throw Exception('Can\'t find Stream $streamKey.');
    }

    return _stream[streamKey] as BehaviorSubject<T>;
  }

  void addCallback(Function(dynamic) callback, [String? key]) =>
      getStream(key).listen(callback);

  BehaviorSubject<E> resolve();

  String getStreamKey<T>([String? key]) =>
      '${(key ?? _defaultResolverKey)}::$T';
}
