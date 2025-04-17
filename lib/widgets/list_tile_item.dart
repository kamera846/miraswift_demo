import 'package:flutter/material.dart';
import 'package:miraswift_demo/utils/badge.dart';

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    super.key,
    required this.title,
    this.isSelected = false,
    this.description,
    this.rightDescription,
    this.badge,
    this.onTap,
    this.badgeModel,
    this.customLeadingIcon,
    this.customTrailingIcon,
    this.border,
  });

  final String title;
  final String? description;
  final String? rightDescription;
  final String? badge;
  final BadgeModel? badgeModel;
  final Widget? customLeadingIcon;
  final Widget? customTrailingIcon;
  final Border? border;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: Theme.of(context).splashColor,
      splashColor: Theme.of(context).splashColor,
      shape: border,
      contentPadding: const EdgeInsets.only(
        top: 4,
        right: 0,
        bottom: 4,
        left: 12,
      ),
      title: titleWidget(context),
      leading: customLeadingIcon,
      trailing: trailingWidget(context),
    );
  }

  Row trailingWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (badge != null || rightDescription != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (rightDescription != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    rightDescription ?? '',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ),
              if (badge != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: CustomBadge(
                    badgeText: badge ?? '',
                    badgeModel: badgeModel,
                  ),
                ),
            ],
          ),
        customTrailingIcon ??
            Container(
              margin: const EdgeInsets.only(right: 12),
            ),
      ],
    );
  }

  Column titleWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        if (description != null)
          Text(
            description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
      ],
    );
  }
}
