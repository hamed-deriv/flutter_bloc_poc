import 'package:equatable/equatable.dart';

enum StateStatus {
  initial,
  loading,
  success,
  failure,
}

class CustomState<T extends Equatable> with EquatableMixin {
  CustomState({required this.status, this.data, this.error});

  final StateStatus status;
  final T? data;
  final String? error;

  @override
  String toString() => '''
      status: $status,
      state: $data,
      error: $error
    ''';

  @override
  List<Object?> get props => <Object?>[status, data, error];
}
