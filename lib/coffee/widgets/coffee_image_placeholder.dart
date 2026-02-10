import 'package:coffee_app/app/theme/app_dimens.dart';
import 'package:coffee_app/coffee/widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';

/// A shimmer loading placeholder for coffee images.
///
/// This widget displays an animated shimmer effect while coffee images
/// are being loaded, providing visual feedback to the user.
class CoffeeImagePlaceholder extends StatelessWidget {
  /// Creates a [CoffeeImagePlaceholder].
  const CoffeeImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        height: AppDimens.coffeeImageHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.paddingLarge),
        ),
      ),
    );
  }
}
