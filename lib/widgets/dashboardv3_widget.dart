import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/models/hero_chart_model.dart';
import 'package:miraswift_demo/models/logmsg_model.dart';
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/models/spk_model.dart';
import 'package:miraswift_demo/screens/batch_screen.dart';
import 'package:miraswift_demo/screens/notifications_screen.dart';
import 'package:miraswift_demo/screens/panel_screen.dart';
import 'package:miraswift_demo/screens/product_screen.dart';
import 'package:miraswift_demo/screens/spk_screen.dart';
import 'package:miraswift_demo/services/batch_api.dart';
import 'package:miraswift_demo/services/logmsg_api.dart';
import 'package:miraswift_demo/services/product_api.dart';
import 'package:miraswift_demo/services/spk_api.dart';
import 'package:miraswift_demo/widgets/dashboard_hero_chart.dart';
import 'package:miraswift_demo/widgets/dashboard_menu_item.dart';

class Dashboardv3Widget extends StatefulWidget {
  const Dashboardv3Widget({super.key});

  @override
  State<Dashboardv3Widget> createState() => _Dashboardv3WidgetState();
}

final List<DropdownMenuItem<String>> planDropdownItem = List.of([
  const DropdownMenuItem(
    value: "Plan 1",
    child: Text("Plan 1"),
  ),
  const DropdownMenuItem(
    value: "Plan 2",
    child: Text("Plan 2"),
  ),
  const DropdownMenuItem(
    value: "Plan 3",
    child: Text("Plan 3"),
  ),
]);

class _Dashboardv3WidgetState extends State<Dashboardv3Widget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? _animationControllerHeader;
  AnimationController? _animationControllerBody;
  bool _isLoading = true;
  List<ProductModel> products = [];
  List<BatchModel> batchs = [];
  List<SpkModel> listSpk = [];
  List<double> chartScaleValues = [];
  List<HeroChartModel> chartScalesData = [];
  List<double> chartTimeValues = [];
  List<HeroChartModel> chartScalesYearData = [];
  List<double> chartScaleYearValues = [];
  List<String> chartScalesYearBottomTitle = [];
  List<HeroChartModel> chartTimeData = [];
  List<LogMessageModel> messages = [];
  String _selectedPlan = planDropdownItem.first.value!;
  double _opacityValue = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? CustomScrollView(
            controller: _scrollController,
            slivers: [
              dashboardHeader(context),
              dashboardHero(context),
              dahsboardBody(context),
              dashboardFooter(context),
            ],
          )
        : Center(
            child: LoadingAnimationWidget.inkDrop(
              color: Colors.blue,
              size: 50,
            ),
          );
  }

  SliverAppBar dashboardHeader(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        background: AnimatedOpacity(
          opacity: _opacityValue,
          duration: const Duration(milliseconds: 500),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
        ),
        title: AnimatedBuilder(
          animation: _animationControllerHeader!,
          builder: (ctx, kChild) => SlideTransition(
            position: Tween(
              begin: const Offset(0, -1),
              end: const Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: _animationControllerHeader!,
                curve: Curves.ease,
              ),
            ),
            child: kChild,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage('assets/images/miraswift_transparent.png'),
                height: 35,
              ),
              const Expanded(child: SizedBox.shrink()),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: DropdownButton<String>(
                  items: planDropdownItem,
                  value: _selectedPlan,
                  onChanged: dropdownCallback,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        titlePadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 20,
        ),
      ),
    );
  }

  SliverPadding dashboardHero(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 16),
      sliver: SliverList.list(children: [
        AnimatedBuilder(
          animation: _animationControllerHeader!,
          builder: (ctx, kChild) => SlideTransition(
            position: Tween(
              begin: const Offset(0, -1),
              end: const Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: _animationControllerHeader!,
                curve: Curves.ease,
              ),
            ),
            child: kChild,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "v1.0.0",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Hello, Mochammad Rafli Ramadani",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CarouselSlider(
                options: CarouselOptions(),
                items: [
                  DashboardHeroChart(
                    barWidth: 16,
                    title: 'Total Scales 2025',
                    unit: 'kg',
                    icon: const Icon(
                      Icons.scale_rounded,
                      color: Colors.blue,
                    ),
                    listColorGradient: const [
                      Colors.blue,
                      Colors.lightBlueAccent,
                    ],
                    chartInterval: 20000,
                    maxChartValue: 80000,
                    listChartValue: chartScaleYearValues,
                    leftTitleKey: const ['0', '20k', '40k', '60k', '80k'],
                    leftTitleValue: const [0, 20000, 40000, 60000, 80000],
                    heroChartData: chartScalesYearData,
                    bottomTitleKey: chartScalesYearBottomTitle,
                  ),
                  DashboardHeroChart(
                    title: 'Best Scales',
                    unit: 'kg',
                    icon: const Icon(
                      Icons.scale_outlined,
                      color: Colors.green,
                    ),
                    listColorGradient: const [
                      Colors.green,
                      Colors.lightGreen,
                    ],
                    chartInterval: 250,
                    maxChartValue: 1000,
                    listChartValue: chartScaleValues,
                    leftTitleKey: const ['0', '250', '500', '750', '1K'],
                    leftTitleValue: const [0, 250, 500, 750, 1000],
                    heroChartData: chartScalesData,
                    bottomTitleKey: const ['7', '6', '5', '4', '3', '2', '1'],
                  ),
                  DashboardHeroChart(
                    title: 'Best Time',
                    unit: 'minutes',
                    icon: const Icon(
                      Icons.timelapse_rounded,
                      color: Colors.red,
                    ),
                    listColorGradient: const [
                      Colors.red,
                      Colors.orange,
                    ],
                    maxChartValue: 20,
                    chartInterval: 5,
                    listChartValue: chartTimeValues,
                    leftTitleKey: const ['0', '5', '10', '15', '20'],
                    leftTitleValue: const [0, 5, 10, 15, 20],
                    heroChartData: chartTimeData,
                    bottomTitleKey: const ['7', '6', '5', '4', '3', '2', '1'],
                  ),
                ].map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.only(
                          left: 12,
                          top: 12,
                          right: 12,
                          bottom: item.bottomTitleKey != null ? 0 : 12,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: item,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  SliverPadding dahsboardBody(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            AnimatedBuilder(
              animation: _animationControllerBody!,
              builder: (ctx, kChild) => SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: _animationControllerBody!,
                    curve: Curves.ease,
                  ),
                ),
                child: kChild,
              ),
              child: DashboardMenuItem(
                icon: Icons.playlist_add_circle_rounded,
                surfaceColor: Colors.blue,
                title: 'Recipes',
                description: '${products.length} products',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const ProductScreen(),
                  ),
                ).then(
                  (value) => getProducts(isLoading: false),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animationControllerBody!,
              builder: (ctx, kChild) => SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: _animationControllerBody!,
                    curve: Curves.ease,
                  ),
                ),
                child: kChild,
              ),
              child: DashboardMenuItem(
                icon: Icons.lightbulb_circle,
                surfaceColor: Colors.green,
                title: 'Batchs',
                description: '${batchs.length} items',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const BatchScreen(),
                  ),
                ).then(
                  (value) => getProducts(isLoading: false),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animationControllerBody!,
              builder: (ctx, kChild) => SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: _animationControllerBody!,
                    curve: Curves.ease,
                  ),
                ),
                child: kChild,
              ),
              child: DashboardMenuItem(
                icon: Icons.playlist_add_check_circle,
                surfaceColor: Colors.red,
                title: 'Settings SPK',
                description: '${listSpk.length} items',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const SpkScreen(),
                  ),
                ).then(
                  (value) => getProducts(isLoading: false),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animationControllerBody!,
              builder: (ctx, kChild) => SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: _animationControllerBody!,
                    curve: Curves.ease,
                  ),
                ),
                child: kChild,
              ),
              child: DashboardMenuItem(
                icon: Icons.circle_notifications,
                surfaceColor: Colors.yellow.shade700,
                title: 'Notifications',
                description: '${messages.length} messages',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const NotificationsScreen(),
                  ),
                ).then(
                  (value) => getProducts(isLoading: false),
                ),
              ),
            ),
          ]),
    );
  }

  SliverPadding dashboardFooter(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.list(children: [
        AnimatedBuilder(
          animation: _animationControllerBody!,
          builder: (ctx, kChild) => SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: _animationControllerBody!,
                curve: Curves.ease,
              ),
            ),
            child: kChild,
          ),
          child: SizedBox(
            height: 150,
            child: DashboardMenuItem(
              icon: Icons.build_circle,
              surfaceColor: Colors.purple,
              title: 'Monitoring Equipments',
              description: 'Looking your equipments in realtime',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const PanelScreen(),
                ),
              ).then(
                (value) => getProducts(isLoading: false),
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _animationControllerBody!,
          builder: (ctx, kChild) => SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: _animationControllerBody!,
                curve: Curves.ease,
              ),
            ),
            child: kChild,
          ),
          child: Container(
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.only(
              top: 16,
              bottom: 32,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Column(
              children: [
                Text('© 2024 Miraswift Auto Solusi'),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    generateChartData();
    iniScrollController();
    getProducts();
  }

  @override
  void dispose() {
    _animationControllerHeader!.dispose();
    _animationControllerBody!.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      getProducts(isLoading: false);
    }
  }

  Future<void> initAnimations() async {
    _animationControllerHeader = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationControllerHeader!.forward();
    _animationControllerBody = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationControllerBody!.forward();
  }

  void getProducts({bool isLoading = true}) async {
    setState(() {
      _isLoading = isLoading;
    });
    await ProductApi().list(
      onError: (msg) {
        if (mounted) {
          // showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          if (data != null) products = data;
        });
        getBatchs();
      },
    );
  }

  void getBatchs() async {
    await BatchApiService().batchs(
      onError: (msg) {
        if (mounted) {
          // showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          if (data != null) batchs = data;
        });
        getListSpk();
      },
    );
  }

  void getListSpk() async {
    await SpkApi().list(
      onError: (msg) {
        if (mounted) {
          // showSnackBar(context, msg);
        }
      },
      onCompleted: (data) {
        setState(() {
          if (data != null) listSpk = data;
        });
        getMessages();
      },
    );
  }

  void getMessages() async {
    await LogMessageApi().list(
      // onError: (msg) => showSnackBar(context, msg),
      onCompleted: (data) {
        if (mounted) {
          setState(() {
            if (data != null) messages = data;
          });
        }
      },
    ).then(
      (value) async {
        if (_animationControllerHeader == null ||
            _animationControllerBody == null) {
          await initAnimations();
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }

  void dropdownCallback(String? value) {
    if (value is String) {
      setState(() {
        _selectedPlan = value;
        getProducts();
      });
    }
  }

  void iniScrollController() {
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset > 26) {
          _opacityValue = 1;
        } else {
          _opacityValue = 0;
        }
      });
    });
  }

  void generateChartData() {
    // ChartScalesYear
    chartScalesYearData.add(
      const HeroChartModel(
        date: '01 Jan 2025',
        batch: '111111',
        value: 50000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '02 Feb 2025',
        batch: '222222',
        value: 70000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '07 Mar 2025',
        batch: '333333',
        value: 40000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '08 Apr 2025',
        batch: '444444',
        value: 60000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '09 May 2025',
        batch: '555555',
        value: 35000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '10 Jun 2025',
        batch: '666666',
        value: 30000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '11 Jul 2025',
        batch: '777777',
        value: 38000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '12 Aug 2025',
        batch: '888888',
        value: 75000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '13 Sep 2025',
        batch: '999999',
        value: 65000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '14 Okt 2025',
        batch: '101010',
        value: 78000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '15 Nov 2025',
        batch: '121212',
        value: 55000,
      ),
    );
    chartScalesYearData.add(
      const HeroChartModel(
        date: '16 Dec 2025',
        batch: '131313',
        value: 60000,
      ),
    );

    for (var item in chartScalesYearData) {
      chartScaleYearValues.add(item.value);
    }

    chartScalesYearBottomTitle = [
      'J',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D'
      // '1',
      // '2',
      // '3',
      // '4',
      // '5',
      // '6',
      // '7',
      // '8',
      // '9',
      // '10',
      // '11',
      // '12'
    ];

    // ChartScales
    chartScalesData.add(
      const HeroChartModel(
        date: '05 Jan 2019',
        batch: '123123',
        value: 300,
      ),
    );
    chartScalesData.add(
      const HeroChartModel(
        date: '06 Mar 2020',
        batch: '321321',
        value: 400,
      ),
    );
    chartScalesData.add(
      const HeroChartModel(
        date: '07 May 2021',
        batch: '111222',
        value: 500,
      ),
    );
    chartScalesData.add(
      const HeroChartModel(
        date: '08 Jul 2022',
        batch: '444333',
        value: 600,
      ),
    );
    chartScalesData.add(
      const HeroChartModel(
        date: '09 Sep 2023',
        batch: '111444',
        value: 700,
      ),
    );
    chartScalesData.add(
      const HeroChartModel(
        date: '10 Nov 2024',
        batch: '444111',
        value: 800,
      ),
    );
    chartScalesData.add(
      const HeroChartModel(
        date: '11 Jan 2025',
        batch: '123321',
        value: 900,
      ),
    );

    for (var item in chartScalesData) {
      chartScaleValues.add(item.value);
    }

    // Chart Time
    chartTimeData.add(
      const HeroChartModel(
        date: '01 Feb 2019',
        batch: '123123',
        value: 3,
      ),
    );
    chartTimeData.add(
      const HeroChartModel(
        date: '02 Apr 2020',
        batch: '321321',
        value: 6,
      ),
    );
    chartTimeData.add(
      const HeroChartModel(
        date: '03 Jun 2021',
        batch: '111222',
        value: 9,
      ),
    );
    chartTimeData.add(
      const HeroChartModel(
        date: '04 Aug 2022',
        batch: '444333',
        value: 12,
      ),
    );
    chartTimeData.add(
      const HeroChartModel(
        date: '05 Okt 2023',
        batch: '111444',
        value: 15,
      ),
    );
    chartTimeData.add(
      const HeroChartModel(
        date: '06 Dec 2024',
        batch: '444111',
        value: 18,
      ),
    );
    chartTimeData.add(
      const HeroChartModel(
        date: '07 Feb 2025',
        batch: '123321',
        value: 20,
      ),
    );

    for (var item in chartTimeData) {
      chartTimeValues.add(item.value);
    }
  }
}
