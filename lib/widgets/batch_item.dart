import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/batch_model.dart';

class BatchItem extends StatelessWidget {
  const BatchItem.equipment({
    super.key,
    required this.equipment,
    this.isLastIndex = false,
  }) : scales = null;
  const BatchItem.scales({
    super.key,
    required this.scales,
    this.isLastIndex = false,
  }) : equipment = null;

  final BatchModel? equipment;
  final BatchModel? scales;
  final bool isLastIndex;

  @override
  Widget build(BuildContext context) {
    Color statusColorOn = Colors.green.shade900.withAlpha(75);
    Color statusColorOff = Colors.red.shade900.withAlpha(75);
    Color statusColorBorderOn = Colors.green.shade900.withAlpha(150);
    Color statusColorBorderOff = Colors.red.shade900.withAlpha(150);

    if (equipment != null && equipment!.timeOff == '0') {
      statusColorOff = Colors.yellow.shade900.withAlpha(75);
      statusColorBorderOff = Colors.yellow.shade900.withAlpha(150);
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment != null
                        ? equipment!.nameEquipment
                        : scales!.nameBahan,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: equipment != null
                              ? statusColorOn
                              : statusColorOff,
                          border: Border.all(
                              width: 2,
                              color: equipment != null
                                  ? statusColorBorderOn
                                  : statusColorBorderOff),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        equipment != null
                            ? equipment!.timeOn
                            : '${scales!.dateTimbang} ${scales!.timeTimbang}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  if (equipment != null) ...[
                    Container(
                      width: 2,
                      height: 12,
                      margin: const EdgeInsets.only(left: 9),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [statusColorBorderOn, statusColorBorderOff],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: statusColorOff,
                            border: Border.all(
                                width: 2, color: statusColorBorderOff),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (equipment!.timeOff != '0')
                          Text(
                            equipment!.timeOff,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                          )
                        else
                          Icon(
                            size: 20,
                            Icons.linear_scale,
                            color: statusColorBorderOff,
                          )
                      ],
                    ),
                  ]
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (equipment != null && equipment!.timeElapsed != '0')
                  Text(
                    equipment!.timeElapsed,
                    style: const TextStyle(fontSize: 12),
                  )
                else if (equipment != null && equipment!.timeElapsed == '0')
                  Icon(
                    Icons.linear_scale,
                    color: statusColorBorderOff,
                  )
                else if (equipment == null)
                  Text(
                    '${scales!.actualTimbang} KG',
                    style: const TextStyle(fontSize: 12),
                  ),
                Text(
                  equipment != null
                      ? equipment!.desc.toUpperCase()
                      : scales!.statusTimbang.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            )
          ],
        ),
        if (!isLastIndex) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Divider(
              height: 0,
              color: Colors.grey.withAlpha(75),
            ),
          ),
        ]
      ],
    );
  }
}
