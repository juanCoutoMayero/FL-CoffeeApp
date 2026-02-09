import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';

sealed class CoffeeEvent extends Equatable {
  const CoffeeEvent();

  @override
  List<Object> get props => [];
}

class CoffeeFetchRequested extends CoffeeEvent {
  const CoffeeFetchRequested();
}

class CoffeeFavoriteToggled extends CoffeeEvent {
  const CoffeeFavoriteToggled(this.coffee);

  final Coffee coffee;

  @override
  List<Object> get props => [coffee];
}

class CoffeeFavoritesSubscriptionRequested extends CoffeeEvent {
  const CoffeeFavoritesSubscriptionRequested();
}

class CoffeeSaveStatusReset extends CoffeeEvent {
  const CoffeeSaveStatusReset();
}

class CoffeeSelected extends CoffeeEvent {
  const CoffeeSelected(this.coffee);

  final Coffee coffee;

  @override
  List<Object> get props => [coffee];
}
