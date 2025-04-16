import 'package:flutter/material.dart';
import 'package:miraswift_demo/widgets/list_tile_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            settingsHeader(context),
            settingsMenu(),
          ],
        ),
      ),
    );
  }

  Column settingsMenu() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTileItem(
            title: 'Manage User',
            onTap: () {},
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
            customTrailingIcon: Icon(
              Icons.arrow_right_rounded,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTileItem(
            title: 'Master Data Products',
            onTap: () {},
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
            customTrailingIcon: Icon(
              Icons.arrow_right_rounded,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTileItem(
            title: 'Master Data Materials',
            onTap: () {},
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
            customTrailingIcon: Icon(
              Icons.arrow_right_rounded,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTileItem(
            title: 'Edit Plan',
            onTap: () {},
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
            customTrailingIcon: Icon(
              Icons.arrow_right_rounded,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTileItem(
            title: 'Accurate',
            onTap: () {},
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
            customTrailingIcon: Icon(
              Icons.arrow_right_rounded,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTileItem(
            title: 'Logout',
            onTap: () {},
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
            customTrailingIcon: Icon(
              Icons.arrow_right_rounded,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  Padding settingsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              Icons.person,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Hero(
                    tag: 'username',
                    child: Text("Mochammad Rafli Ramadani",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Hero(
                    tag: 'usercompany',
                    child: Text(
                      "PT. Top Mortar Indonesia",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.arrow_drop_down_circle_rounded),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                child: Text('Profile'),
              ),
              const PopupMenuItem(
                child: Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
