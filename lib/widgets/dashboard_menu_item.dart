import 'package:flutter/material.dart';

class DashboardMenuItem extends StatelessWidget {
  const DashboardMenuItem({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.description,
    this.surfaceColor = Colors.blue,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(16),
  });

  final IconData icon;
  final String title;
  final String description;
  final Color? surfaceColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: surfaceColor!.withValues(alpha: 0.3),
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: margin,
        padding: padding,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: surfaceColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Open',
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.arrow_circle_right_sharp,
                  size: 18,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
