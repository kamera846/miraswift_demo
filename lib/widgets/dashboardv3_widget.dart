import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/models/logmsg_model.dart';
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/models/spk_model.dart';
import 'package:miraswift_demo/screens/batch_screen.dart';
import 'package:miraswift_demo/screens/notifications_screen.dart';
import 'package:miraswift_demo/screens/product_screen.dart';
import 'package:miraswift_demo/screens/spk_screen.dart';
import 'package:miraswift_demo/screens/webview_screen.dart';
import 'package:miraswift_demo/services/batch_api.dart';
import 'package:miraswift_demo/services/logmsg_api.dart';
import 'package:miraswift_demo/services/product_api.dart';
import 'package:miraswift_demo/services/spk_api.dart';
import 'package:miraswift_demo/widgets/dashboard_menu_item.dart';

class Dashboardv3Widget extends StatefulWidget {
  const Dashboardv3Widget({super.key});

  @override
  State<Dashboardv3Widget> createState() => _Dashboardv3WidgetState();
}

final List<DropdownMenuItem<String>> plantDropdownItem = List.of([
  const DropdownMenuItem(
    value: "Plant 1",
    child: Text("Plant 1"),
  ),
  const DropdownMenuItem(
    value: "Plant 2",
    child: Text("Plant 2"),
  ),
  const DropdownMenuItem(
    value: "Plant 3",
    child: Text("Plant 3"),
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
  List<LogMessageModel> messages = [];
  String _selectedPlant = plantDropdownItem.first.value!;
  double _opacityValue = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                scrolledUnderElevation: 0,
                elevation: 0,
                floating: false,
                pinned: true,
                flexibleSpace: dashboardHeader(context),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverList.list(children: [
                  Text(
                    "Halo, Mochammad Rafli Ramadani",
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
                  Text(
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
                  )
                ]),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: dahsboardBody(context),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) {
                    return dashboardFooter(context);
                  },
                ),
              ),
            ],
          )
        : Center(
            child: LoadingAnimationWidget.inkDrop(
              color: Colors.blue,
              size: 50,
            ),
          );
  }

  FlexibleSpaceBar dashboardHeader(BuildContext context) {
    return FlexibleSpaceBar(
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
                items: plantDropdownItem,
                value: _selectedPlant,
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
    );
  }

  List<Widget> dahsboardBody(BuildContext context) {
    return [
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
    ];
  }

  Column dashboardFooter(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 0,
            left: 16,
            right: 16,
            bottom: 8,
          ),
          child: AnimatedBuilder(
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
                    builder: (ctx) => const WebviewScreen(),
                  ),
                ).then(
                  (value) => getProducts(isLoading: false),
                ),
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
              left: 16,
              top: 8,
              right: 16,
              bottom: 250,
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
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  void initAnimations() {
    _animationControllerHeader = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationControllerHeader!.forward();
    _animationControllerBody = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
            if (_animationControllerHeader == null ||
                _animationControllerBody == null) initAnimations();
            _isLoading = false;
          });
        }
      },
    );
  }

  void dropdownCallback(String? value) {
    if (value is String) {
      setState(() {
        _selectedPlant = value;
      });
    }
  }

  void iniScrollController() {
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset > 16) {
          _opacityValue = 1;
        } else {
          _opacityValue = 0;
        }
      });
    });
  }
}
