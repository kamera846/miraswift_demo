import 'package:flutter/material.dart';
import 'package:miraswift_demo/utils/badge.dart';

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    super.key,
    required this.title,
    this.isSelected = false,
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
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: Theme.of(context).splashColor,
      splashColor: Theme.of(context).splashColor,
      contentPadding:
          const EdgeInsets.only(top: 4, right: 0, bottom: 4, left: 12),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (description != null)
            Text(
              description!,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            CustomBadge(
              badgeText: badge!,
              badgeModel: badgeModel,
            ),
          customTrailingIcon ??
              Container(
                margin: const EdgeInsets.only(right: 12),
              ),
        ],
      ),
    );
  }
}
