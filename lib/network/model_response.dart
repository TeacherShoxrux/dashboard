import 'package:admin/network/response_base.dart';

sealed class Result<T> {
  final T? value;
  final Exception? exception;
  Result(this.value, {this.exception});
}
class Success<T> extends Result<T> {
  Success(T value) : super(value);
}
class Error<T> extends Result<T> {
  final Exception exception;
  Error(this.exception, {T? value}) : super(value);
}
