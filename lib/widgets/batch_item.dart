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

    double different = 0;
    Widget actualIcon = const SizedBox.shrink();
    Widget actualDifferent = const SizedBox.shrink();

    if (scales != null) {
      if (scales!.formula != null) {
        var targetFormula = double.parse(scales!.formula!.targetFormula);
        var fineFormula = double.parse(scales!.formula!.fineFormula);
        var totalFormula = targetFormula + fineFormula;
        var actualTimbang = double.parse(scales!.actualTimbang);
        // isOverLimit = totalFormula < actualTimbang;
        // if (isOverLimit) {
        //   different = actualTimbang - totalFormula;
        // } else {
        //   different = totalFormula - actualTimbang;
        // }
        if (actualTimbang < targetFormula) {
          // kurang dari target
          different = targetFormula - actualTimbang;
          actualIcon = const Icon(
            Icons.keyboard_double_arrow_down,
            color: Colors.lightBlue,
            size: 12,
          );
          actualDifferent = Text(
            different.toStringAsFixed(1),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.lightBlue),
          );
        } else if (actualTimbang == targetFormula) {
          // pas
          different = 0;
        } else if (actualTimbang > targetFormula &&
            actualTimbang <= totalFormula) {
          // masuk range
          different = actualTimbang - targetFormula;
          actualIcon = const Icon(
            Icons.keyboard_double_arrow_up,
            color: Colors.green,
            size: 12,
          );
          actualDifferent = Text(
            different.toStringAsFixed(1),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.green),
          );
        } else {
          // melebihi range
          different = actualTimbang - targetFormula;
          actualIcon = const Icon(
            Icons.keyboard_double_arrow_up,
            color: Colors.red,
            size: 12,
          );
          actualDifferent = Text(
            different.toStringAsFixed(1),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.red),
          );
        }
      }
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
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
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
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  if (equipment != null) ...[
                    Container(
                      width: 2,
                      height: 12,
                      margin: const EdgeInsets.only(left: 7),
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
                          width: 16,
                          height: 16,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey.shade600),
                          )
                        else
                          Icon(
                            size: 16,
                            Icons.linear_scale,
                            color: statusColorBorderOff,
                          )
                      ],
                    ),
                  ] else if (equipment == null && scales != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          scales!.formula != null
                              ? 'Target formula ${scales!.formula!.targetFormula} kg (Fine ${scales!.formula!.fineFormula} kg)'
                              : '-',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    )
                  ]
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (equipment != null && equipment!.timeElapsed != '0')
                  Text(equipment!.timeElapsed,
                      style: Theme.of(context).textTheme.bodySmall)
                else if (equipment != null && equipment!.timeElapsed == '0')
                  Icon(
                    size: 16,
                    Icons.linear_scale,
                    color: statusColorBorderOff,
                  )
                else if (equipment == null)
                  Row(
                    children: [
                      Text('${scales!.actualTimbang} KG',
                          style: Theme.of(context).textTheme.bodySmall),
                      actualIcon,
                      actualDifferent,
                    ],
                  ),
                Text(
                  equipment != null
                      ? equipment!.desc.toUpperCase()
                      : scales!.statusTimbang.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey.shade600),
                ),
              ],
            )
          ],
        ),
        if (!isLastIndex) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Divider(
              height: 0,
              color: Colors.grey.shade300,
            ),
          ),
        ]
      ],
    );
  }
}
