import 'package:flutter/material.dart';

enum BadgeCategory { grey, green, yellow, red }

class BadgeModel {
  BadgeModel(this.txtColor, this.bgColor);
  final Color txtColor;
  final Color bgColor;
}

final Map<BadgeCategory, BadgeModel> badgeStyle = {
  BadgeCategory.grey: BadgeModel(
    Colors.grey.shade900.withAlpha(150),
    Colors.grey.shade900.withAlpha(75),
  ),
  BadgeCategory.green: BadgeModel(
    Colors.green.shade900.withAlpha(150),
    Colors.green.shade900.withAlpha(75),
  ),
  BadgeCategory.yellow: BadgeModel(
    Colors.yellow.shade900.withAlpha(150),
    Colors.yellow.shade900.withAlpha(75),
  ),
  BadgeCategory.red: BadgeModel(
    Colors.red.shade900.withAlpha(150),
    Colors.red.shade900.withAlpha(75),
  ),
};

class CustomBadge extends StatelessWidget {
  const CustomBadge({super.key, required this.badgeText, this.badgeModel});

  final String badgeText;
  final BadgeModel? badgeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: badgeModel == null
            ? badgeStyle[BadgeCategory.grey]!.bgColor
            : badgeModel!.bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      child: Text(
        badgeText.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          color: badgeModel == null
              ? badgeStyle[BadgeCategory.grey]!.txtColor
              : badgeModel!.txtColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
