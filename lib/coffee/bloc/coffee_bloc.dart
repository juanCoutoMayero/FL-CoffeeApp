import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:coffee_app/coffee/bloc/coffee_event.dart';
import 'package:coffee_app/coffee/bloc/coffee_state.dart';
import 'package:coffee_repository/coffee_repository.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc({required CoffeeRepository coffeeRepository})
    : _coffeeRepository = coffeeRepository,
      super(
        CoffeeState(
          favorites: coffeeRepository.getFavorites(),
        ),
      ) {
    on<CoffeeFetchRequested>(_onFetchRequested, transformer: droppable());
    on<CoffeeFavoriteToggled>(_onFavoriteToggled);
    on<CoffeeFavoritesSubscriptionRequested>(_onFavoritesSubscriptionRequested);
    on<CoffeeSaveStatusReset>(_onSaveStatusReset);
    on<CoffeeSelected>(_onCoffeeSelected);

    add(const CoffeeFavoritesSubscriptionRequested());
  }

  final CoffeeRepository _coffeeRepository;

  void _onCoffeeSelected(
    CoffeeSelected event,
    Emitter<CoffeeState> emit,
  ) {
    emit(
      state.copyWith(
        status: CoffeeStatus.success,
        coffee: event.coffee,
        isFavorite: true,
      ),
    );
  }

  void _onSaveStatusReset(
    CoffeeSaveStatusReset event,
    Emitter<CoffeeState> emit,
  ) {
    emit(state.copyWith(saveStatus: CoffeeRequestStatus.initial));
  }

  Future<void> _onFavoritesSubscriptionRequested(
    CoffeeFavoritesSubscriptionRequested event,
    Emitter<CoffeeState> emit,
  ) async {
    await emit.forEach<List<Coffee>>(
      _coffeeRepository.getFavoritesStream(),
      onData: (favorites) => state.copyWith(favorites: favorites),
    );
  }

  Future<void> _onFetchRequested(
    CoffeeFetchRequested event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(state.copyWith(status: CoffeeStatus.loading));
    try {
      final coffee = await _coffeeRepository.getRandomCoffee();
      final isFavorite = _coffeeRepository.isFavorite(coffee.file);
      emit(
        state.copyWith(
          status: CoffeeStatus.success,
          coffee: coffee,
          isFavorite: isFavorite,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CoffeeStatus.failure));
    }
  }

  Future<void> _onFavoriteToggled(
    CoffeeFavoriteToggled event,
    Emitter<CoffeeState> emit,
  ) async {
    try {
      final isFav = _coffeeRepository.isFavorite(event.coffee.file);
      if (isFav) {
        await _coffeeRepository.removeFavorite(event.coffee);
        emit(state.copyWith(isFavorite: false));
      } else {
        await _coffeeRepository.saveFavorite(event.coffee);
        emit(
          state.copyWith(
            isFavorite: true,
            saveStatus: CoffeeRequestStatus.success,
          ),
        );
      }
    } catch (_) {
      // Handle error saving favorite
    }
  }
}
