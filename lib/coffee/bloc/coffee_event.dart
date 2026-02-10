import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';

/// {@template coffee_event}
/// The base class for all coffee events.
/// {@endtemplate}
sealed class CoffeeEvent extends Equatable {
  /// {@macro coffee_event}
  const CoffeeEvent();

  @override
  List<Object> get props => [];
}

/// {@template coffee_fetch_requested}
/// Event added when a new coffee is requested.
/// {@endtemplate}
class CoffeeFetchRequested extends CoffeeEvent {
  /// {@macro coffee_fetch_requested}
  const CoffeeFetchRequested();
}

/// {@template coffee_favorite_toggled}
/// Event added when the favorite status of a coffee is toggled.
/// {@endtemplate}
class CoffeeFavoriteToggled extends CoffeeEvent {
  /// {@macro coffee_favorite_toggled}
  const CoffeeFavoriteToggled(this.coffee);

  /// The coffee to toggle favorite status.
  final Coffee coffee;

  @override
  List<Object> get props => [coffee];
}

/// {@template coffee_favorites_subscription_requested}
/// Event added when the favorites subscription is requested.
/// {@endtemplate}
class CoffeeFavoritesSubscriptionRequested extends CoffeeEvent {
  /// {@macro coffee_favorites_subscription_requested}
  const CoffeeFavoritesSubscriptionRequested();
}

/// {@template coffee_save_status_reset}
/// Event added when the save status is reset.
/// {@endtemplate}
class CoffeeSaveStatusReset extends CoffeeEvent {
  /// {@macro coffee_save_status_reset}
  const CoffeeSaveStatusReset();
}

/// {@template coffee_selected}
/// Event added when a coffee is selected.
/// {@endtemplate}
class CoffeeSelected extends CoffeeEvent {
  /// {@macro coffee_selected}
  const CoffeeSelected(this.coffee);

  /// The selected coffee.
  final Coffee coffee;

  @override
  List<Object> get props => [coffee];
}
