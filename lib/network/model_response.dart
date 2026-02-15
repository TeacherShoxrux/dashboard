sealed class Result<T> {

}
class Success<T>{
  final T value;

  Success( this.value);
}
class Error<T>{
  final Exception exception;

  Error(this.exception);
}
