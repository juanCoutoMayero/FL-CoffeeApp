import 'package:coffee_app/app/theme/app_dimens.dart';
import 'package:coffee_app/app/widgets/theme_toggle_button.dart';
import 'package:coffee_app/coffee/bloc/bloc.dart';
import 'package:coffee_app/coffee/widgets/coffee_controls.dart';
import 'package:coffee_app/coffee/widgets/coffee_error_view.dart';
import 'package:coffee_app/coffee/widgets/coffee_image.dart';
import 'package:coffee_app/coffee/widgets/coffee_image_placeholder.dart';
import 'package:coffee_app/coffee/widgets/favorites_list.dart';
import 'package:coffee_app/l10n/l10n.dart';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monitoring_repository/monitoring_repository.dart';

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoffeeBloc(
        coffeeRepository: context.read<CoffeeRepository>(),
        analyticsService: context.read<AnalyticsService>(),
        crashlyticsService: context.read<CrashlyticsService>(),
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
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: const Center(
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
              child: CoffeeDisplay(),
            ),
            SizedBox(height: AppDimens.spacingMedium),
            CoffeeControls(),
            Spacer(),
            FavoritesList(),
            SizedBox(height: AppDimens.spacingMedium),
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
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.coffee != current.coffee,
      builder: (context, state) {
        if (state.status == CoffeeStatus.loading) {
          return const CoffeeImagePlaceholder();
        } else if (state.status == CoffeeStatus.success &&
            state.coffee != null) {
          return CoffeeImage(imageUrl: state.coffee!.file);
        } else if (state.status == CoffeeStatus.failure) {
          return const CoffeeErrorView();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
