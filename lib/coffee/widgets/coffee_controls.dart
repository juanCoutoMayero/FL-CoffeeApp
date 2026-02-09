import 'package:coffee_app/app/theme/app_dimens.dart';
import 'package:coffee_app/coffee/bloc/bloc.dart';
import 'package:coffee_app/coffee/widgets/coffee_button.dart';
import 'package:coffee_app/l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeControls extends StatelessWidget {
  const CoffeeControls({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
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
        const SizedBox(width: AppDimens.spacingSmall),
        CoffeeButton(
          onPressed: () {
            final state = context.read<CoffeeBloc>().state;
            if (state.status == CoffeeStatus.success && state.coffee != null) {
              context.read<CoffeeBloc>().add(
                CoffeeFavoriteToggled(state.coffee!),
              );
            }
          },
          child: BlocBuilder<CoffeeBloc, CoffeeState>(
            builder: (context, state) {
              return Icon(
                state.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: state.isFavorite ? Colors.red : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
