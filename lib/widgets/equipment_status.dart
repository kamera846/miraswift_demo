import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/equipment_model.dart';

class EquipmentStatus extends StatelessWidget {
  const EquipmentStatus({
    super.key,
    required this.equipment,
    this.isLastIndex = false,
  });

  final EquipmentModel equipment;
  final bool isLastIndex;

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey.withAlpha(75);
    Color statusColorBorder = Colors.grey.withAlpha(150);
    if (equipment.statusEquipment == 'ON') {
      statusColor = Colors.green.withAlpha(75);
      statusColorBorder = Colors.green.withAlpha(150);
    } else if (equipment.statusEquipment == 'OFF') {
      statusColor = Colors.red.withAlpha(75);
      statusColorBorder = Colors.red.withAlpha(150);
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor,
                border: Border.all(width: 2, color: statusColorBorder),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Center(
                child: Text(
                  equipment.statusEquipment,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment.nameEquipment,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    '${equipment.dateEquipment} ${equipment.timeEquipment}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'BATCH',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  equipment.noBatch,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            )
          ],
        ),
        if (!isLastIndex) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Divider(
              height: 1,
              color: Colors.grey.withAlpha(75),
            ),
          ),
        ]
      ],
    );
  }
}
