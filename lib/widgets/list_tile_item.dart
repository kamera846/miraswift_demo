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

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    super.key,
    required this.title,
    this.description,
    this.badge,
    this.onTap,
    this.badgeModel,
    this.customTrailingIcon,
  });

  final String title;
  final String? description;
  final String? badge;
  final BadgeModel? badgeModel;
  final Widget? customTrailingIcon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.only(top: 8, right: 0, bottom: 8, left: 16),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (description != null)
            Text(
              description!,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
            ),
        ],
      ),
      splashColor: Theme.of(context).colorScheme.primaryContainer,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              decoration: BoxDecoration(
                color: badgeModel == null
                    ? badgeStyle[BadgeCategory.grey]!.bgColor
                    : badgeModel!.bgColor,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Text(
                badge!.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: badgeModel == null
                      ? badgeStyle[BadgeCategory.grey]!.txtColor
                      : badgeModel!.txtColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          customTrailingIcon ??
              IconButton(
                onPressed: onTap,
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.withAlpha(75),
                ),
              ),
        ],
      ),
    );
  }
}
