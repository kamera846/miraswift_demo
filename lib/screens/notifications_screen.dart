import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/logmsg_model.dart';
import 'package:miraswift_demo/services/logmsg_api.dart';
import 'package:miraswift_demo/utils/snackbar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<LogMessageModel>? _batchs;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  void _getList() async {
    setState(() {
      isLoading = true;
    });
    await LogMessageApi().list(
      onError: (msg) => showSnackBar(context, msg),
      onCompleted: (data) {
        if (mounted) {
          setState(() {
            _batchs = data;
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',
            style: Theme.of(context).textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_on_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'List Message',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
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
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'To number 0895636998639',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                        ),
                                        Text(
                                          '18 November 2024, 16.32',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Mochammad Rafli Ramadani',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                    Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce purus magna, lacinia in nisi id, consectetur faucibus lacus. Sed sed lacinia ligula, tristique maximus nisl. Aenean rhoncus ex dolor, non dapibus dui ullamcorper a. Fusce fermentum est quis velit luctus, nec rhoncus lacus mattis. Sed egestas lacus vel arcu tempor, nec finibus odio porta. Morbi convallis lectus at sem porta, sed finibus justo rhoncus. Maecenas tellus dolor, ultricies ut lectus quis, malesuada rhoncus velit. Phasellus et neque vitae dolor tempor elementum.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Colors.grey.shade600),
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
                        padding: const EdgeInsets.all(12),
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
