import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_app/app/theme/app_dimens.dart';
import 'package:coffee_app/coffee/widgets/coffee_image_placeholder.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// A widget that displays a coffee image with loading and error states.
///
/// This widget uses [CachedNetworkImage] to efficiently load and cache
/// coffee images from the network. It provides a shimmer placeholder during
/// loading and an error message if the image fails to load.
class CoffeeImage extends StatelessWidget {
  /// Creates a [CoffeeImage].
  ///
  /// The [imageUrl] parameter must not be null.
  const CoffeeImage({
    required this.imageUrl,
    super.key,
  });

  /// The URL of the coffee image to display.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        constraints: const BoxConstraints(
          maxHeight: AppDimens.coffeeImageHeight,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.paddingLarge),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const CoffeeImagePlaceholder(),
      errorWidget: (context, url, error) => Center(
        child: Text(context.l10n.somethingWentWrong),
      ),
    );
  }
}
