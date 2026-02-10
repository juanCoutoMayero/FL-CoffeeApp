import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';

/// The status of the coffee fetch request.
enum CoffeeStatus {
  /// The initial status.
  initial,

  /// The loading status.
  loading,

  /// The success status.
  success,

  /// The failure status.
  failure,
}

/// The status of the save favorite request.
enum CoffeeRequestStatus {
  /// The initial status.
  initial,

  /// The loading status.
  loading,

  /// The success status.
  success,

  /// The failure status.
  failure,
}

class CoffeeState extends Equatable {
  const CoffeeState({
    this.status = CoffeeStatus.initial,
    this.coffee,
    this.favorites = const [],
    this.saveStatus = CoffeeRequestStatus.initial,
    this.isFavorite = false,
    this.failure,
  });

  /// The status of the coffee fetch request.
  final CoffeeStatus status;

  /// The current coffee being displayed.
  final Coffee? coffee;

  /// The list of favorite coffees.
  final List<Coffee> favorites;

  /// The status of the save favorite request.
  final CoffeeRequestStatus saveStatus;

  /// Whether the current coffee is a favorite.
  final bool isFavorite;

  /// The failure that occurred.
  final CoffeeFailure? failure;

  CoffeeState copyWith({
    CoffeeStatus? status,
    Coffee? coffee,
    List<Coffee>? favorites,
    CoffeeRequestStatus? saveStatus,
    bool? isFavorite,
    CoffeeFailure? failure,
  }) {
    return CoffeeState(
      status: status ?? this.status,
      coffee: coffee ?? this.coffee,
      favorites: favorites ?? this.favorites,
      saveStatus: saveStatus ?? this.saveStatus,
      isFavorite: isFavorite ?? this.isFavorite,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    coffee,
    favorites,
    saveStatus,
    isFavorite,
    failure,
  ];
}
