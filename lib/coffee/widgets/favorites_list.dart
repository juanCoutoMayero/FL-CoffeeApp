import 'package:coffee_app/app/theme/app_dimens.dart';
import 'package:coffee_app/coffee/bloc/bloc.dart';
import 'package:coffee_app/coffee/widgets/favorite_item.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key});

  @override
  Widget build(BuildContext context) {
    // We assume CoffeeBloc is provided above
    return BlocBuilder<CoffeeBloc, CoffeeState>(
      builder: (context, state) {
        if (state.favorites.isEmpty) {
          // Empty State
          return Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMedium),
            child: Text(
              context.l10n.favoritesEmptyState,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        // Show last 5 favorites
        final displayList = state.favorites.toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMedium,
                vertical: AppDimens.paddingSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.favoritesTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AppDimens.favoritesListHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingMedium,
                ),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final coffee = displayList[index];
                  return FavoriteItem(coffee: coffee);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
