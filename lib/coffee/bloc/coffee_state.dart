import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';

enum CoffeeStatus { initial, loading, success, failure }

enum CoffeeRequestStatus { initial, loading, success, failure }

class CoffeeState extends Equatable {
  const CoffeeState({
    this.status = CoffeeStatus.initial,
    this.saveStatus = CoffeeRequestStatus.initial,
    this.coffee,
    this.isFavorite = false,
    this.favorites = const [],
  });

  final CoffeeStatus status;
  final CoffeeRequestStatus saveStatus;
  final Coffee? coffee;
  final bool isFavorite;
  final List<Coffee> favorites;

  CoffeeState copyWith({
    CoffeeStatus? status,
    CoffeeRequestStatus? saveStatus,
    Coffee? coffee,
    bool? isFavorite,
    List<Coffee>? favorites,
  }) {
    return CoffeeState(
      status: status ?? this.status,
      saveStatus: saveStatus ?? this.saveStatus,
      coffee: coffee ?? this.coffee,
      isFavorite: isFavorite ?? this.isFavorite,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [
    status,
    saveStatus,
    coffee,
    isFavorite,
    favorites,
  ];
}
