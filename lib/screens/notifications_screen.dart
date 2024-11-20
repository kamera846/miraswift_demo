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
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'List Message',
                    style: Theme.of(context).textTheme.titleMedium,
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
                                          'To number ${item.toNumber}',
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                        Text(
                                          item.dateMsg,
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.toName,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.message,
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
