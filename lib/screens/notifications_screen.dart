import 'package:flutter/material.dart';
import 'package:miraswift_demo/models/logmsg_model.dart';
import 'package:miraswift_demo/screens/notifications_target_screen.dart';
import 'package:miraswift_demo/services/logmsg_api.dart';
import 'package:miraswift_demo/utils/formatted_date.dart';
import 'package:miraswift_demo/utils/snackbar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<LogMessageModel>? _generalNotifications;
  List<LogMessageModel>? _problemNotifications;
  bool isLoading = true;
  LogMessageModel? _selectedItem;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            _generalNotifications = data;
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.settings_applications,
            ),
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const NotificationsTargetScreen(),
                      ),
                    ).then((value) => _getList());
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 12),
                      Text('Manage Target Users')
                    ],
                  ),
                ),
              ];
            },
          )
        ],
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(
            child: Text('General'),
          ),
          Tab(
            child: Text('Problem'),
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabBarView(_generalNotifications),
          _buildTabBarView(_problemNotifications),
        ],
      ),
    );
  }

  Widget _buildTabBarView(List<LogMessageModel>? messages) {
    return (!isLoading && messages != null && messages.isNotEmpty)
        ? ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final item = messages[index];
              final isLastIndex = (index == (messages.length - 1));
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_selectedItem == item) {
                          _selectedItem = null;
                        } else {
                          _selectedItem = item;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'To number ${item.toNumber}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                              ),
                              Text(
                                formattedDate(
                                  dateStr: item.dateMsg,
                                  inputFormat: 'yyyy-MM-dd HH:mm:ss',
                                  outputFormat: 'dd MMM yyyy, HH:mm',
                                ),
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
                          Text(item.toName,
                              style: Theme.of(context).textTheme.titleSmall),
                          Text(
                            item.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey.shade600),
                            maxLines: _selectedItem != null &&
                                    _selectedItem!.idLogMsg == item.idLogMsg
                                ? null
                                : 3,
                            overflow: _selectedItem != null &&
                                    _selectedItem!.idLogMsg == item.idLogMsg
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLastIndex)
                    Divider(
                      height: 0,
                      color: Colors.grey.shade300,
                    ),
                ],
              );
            },
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(isLoading
                  ? 'Loading..'
                  : !isLoading && (messages == null || messages.isEmpty)
                      ? 'Data is empty.'
                      : ''),
            ),
          );
  }
}
