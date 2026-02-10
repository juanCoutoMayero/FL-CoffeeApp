import 'package:equatable/equatable.dart';

/// {@template coffee_failure}
/// A failure that occurs when a coffee request fails.
/// {@endtemplate}
abstract class CoffeeFailure extends Equatable implements Exception {
  /// {@macro coffee_failure}
  const CoffeeFailure(this.error, this.stackTrace);

  /// The error that occurred.
  final Object error;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  @override
  List<Object> get props => [error, stackTrace];
}

/// {@template coffee_request_failure}
/// A failure that occurs when a coffee request fails.
/// {@endtemplate}
class CoffeeRequestFailure extends CoffeeFailure {
  /// {@macro coffee_request_failure}
  const CoffeeRequestFailure(super.error, super.stackTrace);
}

/// {@template coffee_not_found_failure}
/// A failure that occurs when a coffee is not found.
/// {@endtemplate}
class CoffeeNotFoundFailure extends CoffeeFailure {
  /// {@macro coffee_not_found_failure}
  const CoffeeNotFoundFailure(super.error, super.stackTrace);
}
