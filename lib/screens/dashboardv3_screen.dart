import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miraswiftdemo/widgets/dashboardv3_widget.dart';

class DashboardV3Screen extends StatefulWidget {
  const DashboardV3Screen({super.key});

  @override
  State<DashboardV3Screen> createState() => _DashboarV3dScreenState();
}

class _DashboarV3dScreenState extends State<DashboardV3Screen> {
  double opacityValue = 0;
  final GlobalKey<Dashboardv3WidgetState> dashboardKey = GlobalKey();

  @override
  void initState() {
    changeOpacityValue();
    super.initState();
  }

  void changeOpacityValue() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        opacityValue = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/base_bg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: opacityValue,
          duration: const Duration(milliseconds: 500),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.white.withValues(alpha: 0.5)),
          ),
        ),
        if (opacityValue == 1) const Dashboardv3Widget(),
      ],
    );
  }
}
