import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/images/miraswift_transparent.png'),
          height: 24,
        ),
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
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
                            child: Container(
                                margin: const EdgeInsets.all(8),
                                width: double.infinity,
                                color: Colors.red.withOpacity(0.3),
                                child: const Center(
                                  child: Text('Batchs'),
                                ))),
                        Expanded(
                            flex: 3,
                            child: Container(
                                margin: const EdgeInsets.all(8),
                                width: double.infinity,
                                color: Colors.green.withOpacity(0.3),
                                child: const Center(
                                  child: Text('SPK'),
                                ))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                                margin: const EdgeInsets.all(8),
                                width: double.infinity,
                                color: Colors.blue.withOpacity(0.3),
                                child: const Center(
                                  child: Text('Recipes'),
                                ))),
                        Expanded(
                            flex: 2,
                            child: Container(
                                margin: const EdgeInsets.all(8),
                                width: double.infinity,
                                color: Colors.yellow.withOpacity(0.3),
                                child: const Center(
                                  child: Text('Notifications'),
                                ))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                margin: const EdgeInsets.all(8),
                width: double.infinity,
                color: Colors.yellow.withOpacity(0.3),
                child: const Center(
                  child: Text('Monitor Equipments'),
                )),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 16),
            child: Text('© 2024 Miraswift Auto Solusi'),
          ),
        ],
      ),
    );
  }
}
