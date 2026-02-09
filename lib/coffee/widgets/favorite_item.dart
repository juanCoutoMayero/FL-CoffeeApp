import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_app/app/theme/app_dimens.dart';
import 'package:coffee_app/coffee/bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({required this.coffee, super.key});

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.paddingSmall),
      child: GestureDetector(
        onTap: () {
          context.read<CoffeeBloc>().add(CoffeeSelected(coffee));
        },
        child: Container(
          width: AppDimens.favoriteThumbnailSize,
          height: AppDimens.favoriteThumbnailSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.spacingSmall),
            image: DecorationImage(
              image: coffee.isLocal
                  ? FileImage(File(coffee.localPath!)) as ImageProvider
                  : CachedNetworkImageProvider(coffee.file),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
