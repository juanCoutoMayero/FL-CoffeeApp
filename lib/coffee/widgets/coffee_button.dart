import 'package:coffee_app/app/theme/app_dimens.dart';
import 'package:flutter/material.dart';

class CoffeeButton extends StatelessWidget {
  const CoffeeButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.buttonBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.buttonPaddingHorizontal,
          vertical: AppDimens.buttonPaddingVertical,
        ),
      ),
      child: child,
    );
  }
}
