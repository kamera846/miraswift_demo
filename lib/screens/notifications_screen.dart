import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/batch_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<BatchModel>? _batchs;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getBatchs();
  }

  void _getBatchs() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          _batchs = [
            const BatchModel(
              noBatch: 'noBatch',
              nameEquipment: 'nameEquipment',
              timeOn: 'timeOn',
              timeOff: 'timeOff',
              timeElapsed: 'timeElapsed',
              desc: 'desc',
              idTimbang: 'idTimbang',
              kodeBahan: 'kodeBahan',
              nameBahan: 'nameBahan',
              actualTimbang: 'actualTimbang',
              statusTimbang: 'statusTimbang',
              dateTimbang: 'dateTimbang',
              timeTimbang: 'timeTimbang',
              createdAt: 'createdAt',
              maxDateEquipment: 'maxDateEquipment',
            ),
          ];
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_on_rounded,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'List Message',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(75)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: (!isLoading && _batchs != null && _batchs!.isNotEmpty)
                  ? Column(
                      children: _batchs!.map((item) {
                        final isLastIndex = (index == (_batchs!.length - 1));
                        index++;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'To number 0895636998639',
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                        Text(
                                          '18 November 2024, 16.32',
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Mochammad Rafli Ramadani',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce purus magna, lacinia in nisi id, consectetur faucibus lacus. Sed sed lacinia ligula, tristique maximus nisl. Aenean rhoncus ex dolor, non dapibus dui ullamcorper a. Fusce fermentum est quis velit luctus, nec rhoncus lacus mattis. Sed egestas lacus vel arcu tempor, nec finibus odio porta. Morbi convallis lectus at sem porta, sed finibus justo rhoncus. Maecenas tellus dolor, ultricies ut lectus quis, malesuada rhoncus velit. Phasellus et neque vitae dolor tempor elementum.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (!isLastIndex)
                              Divider(
                                height: 0,
                                color: Colors.grey.withAlpha(75),
                              ),
                          ],
                        );
                      }).toList(),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(isLoading
                            ? 'Loading..'
                            : !isLoading &&
                                    (_batchs == null || _batchs!.isEmpty)
                                ? 'Data is empty.'
                                : ''),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
