import 'package:flutter/material.dart';
import 'package:miraswift_demo/screens/batch_screen.dart';
import 'package:miraswift_demo/screens/equipment_screen.dart';
import 'package:miraswift_demo/screens/notifications_screen.dart';
import 'package:miraswift_demo/screens/product_screen.dart';
import 'package:miraswift_demo/screens/spk_screen.dart';

class DashboardV2Screen extends StatefulWidget {
  const DashboardV2Screen({super.key});

  @override
  State<DashboardV2Screen> createState() => _DashboarV2dScreenState();
}

class _DashboarV2dScreenState extends State<DashboardV2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   title: const Image(
      //     image: AssetImage('assets/images/miraswift_transparent.png'),
      //     height: 24,
      //   ),
      //   centerTitle: true,
      //   shadowColor: Colors.transparent,
      //   backgroundColor: Colors.transparent,
      //   scrolledUnderElevation: 0,
      // ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 32, top: 96, right: 32, bottom: 32),
            child: Image(
              image: AssetImage('assets/images/miraswift_transparent.png'),
              height: 100,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 2,
                          child: MenuItems(
                            icon: Icons.playlist_add_circle_rounded,
                            surfaceColor: Colors.blue,
                            title: 'Recipes',
                            description: '230 items',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const ProductScreen(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: MenuItems(
                            icon: Icons.playlist_add_check_circle,
                            surfaceColor: Colors.red,
                            title: 'Settings SPK',
                            description: '230 items',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const SpkScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 3,
                          child: MenuItems(
                            icon: Icons.lightbulb_circle,
                            surfaceColor: Colors.green,
                            title: 'Batchs',
                            description: '230 items',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const BatchScreen(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: MenuItems(
                            icon: Icons.circle_notifications,
                            surfaceColor: Colors.yellow,
                            title: 'Notifications',
                            description: '230 items',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const NotificationsScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: MenuItems(
                icon: Icons.build_circle,
                surfaceColor: Colors.purple,
                title: 'Monitoring Equipments',
                description: 'Looking your equipments in realtime',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const EquipmentScreen(),
                  ),
                ),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(
                left: 16,
                top: 8,
                right: 16,
                bottom: 32,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Text('© 2024 Miraswift Auto Solusi'),
              )),
        ],
      ),
    );
  }
}

class MenuItems extends StatelessWidget {
  const MenuItems({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.description,
    this.surfaceColor = Colors.blue,
    this.margin = const EdgeInsets.all(8),
    this.padding = const EdgeInsets.all(12),
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
      splashColor: surfaceColor!.withOpacity(0.3),
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: margin,
        padding: margin,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
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
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
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
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
