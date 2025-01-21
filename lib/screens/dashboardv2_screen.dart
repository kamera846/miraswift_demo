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
                            child: Container(
                                margin: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(24),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Center(
                                  child: Text('Batchs'),
                                ))),
                        Expanded(
                            flex: 3,
                            child: Container(
                                margin: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(24),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
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
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(24),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Center(
                                  child: Text('Recipes'),
                                ))),
                        Expanded(
                            flex: 2,
                            child: Container(
                                margin: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(24),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Center(
                  child: Text('Monitoring Equipments'),
                )),
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
