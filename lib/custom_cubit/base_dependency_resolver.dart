import 'package:rxdart/subjects.dart';

import 'package:flutter_bloc_poc/custom_cubit/base_entity.dart';

abstract class BaseDependencyResolver<E extends BaseEntity> {
  final String _defaultResolverKey = 'DEFAULT_RESOLVER_KEY';

  final Map<String, Stream> _stream = <String, Stream>{};

  void addStream<T>(Stream<T> stream, [String? key]) {
    final String streamKey = getStreamKey<T>(key);

    if (_stream.containsKey(streamKey)) {
      throw Exception('Stream already has $streamKey.');
    }

    _stream[streamKey] = stream;
  }

  Stream<T> getStream<T>([String? key]) {
    final String streamKey = getStreamKey<T>(key);

    if (_stream.containsKey(streamKey) || _stream[streamKey] is Stream<T>) {
      throw Exception('Can\'t find Stream $streamKey.');
    }

    return _stream[streamKey] as Stream<T>;
  }

  void addCallback(Function(dynamic) callback, [String? key]) =>
      getStream(key).listen(callback);

  Stream<E> resolve();

  String getStreamKey<T>([String? key]) =>
      '${(key ?? _defaultResolverKey)}::$T';
}
