import 'dart:io';

import 'package:coffee_app/coffee/bloc/bloc.dart';
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
            padding: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final coffee = displayList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        context.read<CoffeeBloc>().add(CoffeeSelected(coffee));
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: coffee.isLocal
                                ? FileImage(File(coffee.localPath!))
                                      as ImageProvider
                                : NetworkImage(coffee.file),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
