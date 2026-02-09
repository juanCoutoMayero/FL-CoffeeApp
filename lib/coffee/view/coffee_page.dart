import 'package:coffee_app/coffee/bloc/bloc.dart';
import 'package:coffee_app/coffee/widgets/coffee_button.dart';
import 'package:coffee_app/coffee/widgets/custom_shimmer.dart';
import 'package:coffee_app/coffee/widgets/favorites_list.dart';
import 'package:coffee_app/l10n/l10n.dart';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoffeeBloc(
        coffeeRepository: context.read<CoffeeRepository>(),
      )..add(const CoffeeFetchRequested()),
      child: BlocListener<CoffeeBloc, CoffeeState>(
        listenWhen: (previous, current) =>
            previous.saveStatus != current.saveStatus &&
            current.saveStatus == CoffeeRequestStatus.success,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.coffeeAddedToFavorites),
            ),
          );
          context.read<CoffeeBloc>().add(const CoffeeSaveStatusReset());
        },
        child: const CoffeeView(),
      ),
    );
  }
}

class CoffeeView extends StatelessWidget {
  const CoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coffeeAppBarTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CoffeeDisplay(),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CoffeeButton(
                  onPressed: () {
                    context.read<CoffeeBloc>().add(
                      const CoffeeFetchRequested(),
                    );
                  },
                  child: Text(l10n.coffeeAnotherOneButton),
                ),
                const SizedBox(width: 16),
                CoffeeButton(
                  onPressed: () {
                    final state = context.read<CoffeeBloc>().state;
                    if (state.status == CoffeeStatus.success &&
                        state.coffee != null) {
                      context.read<CoffeeBloc>().add(
                        CoffeeFavoriteToggled(state.coffee!),
                      );
                    }
                  },
                  child: BlocBuilder<CoffeeBloc, CoffeeState>(
                    builder: (context, state) {
                      return Icon(
                        state.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: state.isFavorite ? Colors.red : null,
                      );
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            const FavoritesList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class CoffeeDisplay extends StatelessWidget {
  const CoffeeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeBloc, CoffeeState>(
      builder: (context, state) {
        if (state.status == CoffeeStatus.loading) {
          return CustomShimmer(
            child: Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          );
        } else if (state.status == CoffeeStatus.success &&
            state.coffee != null) {
          return Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: NetworkImage(state.coffee!.file),
                fit: BoxFit.cover,
              ),
            ),
          );
        } else if (state.status == CoffeeStatus.failure) {
          return const Text('Something went wrong!');
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
