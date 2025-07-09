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

class DashboardV2Screen extends StatefulWidget {
  const DashboardV2Screen({super.key});

  @override
  State<DashboardV2Screen> createState() => _DashboarV2dScreenState();
}

class _DashboarV2dScreenState extends State<DashboardV2Screen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? _animationController;
  bool _isLoading = true;
  List<ProductModel> products = [];
  List<BatchModel> batchs = [];
  List<SpkModel> listSpk = [];
  List<LogMessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getProducts();
  }

  @override
  void dispose() {
    _animationController!.dispose();
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController!.forward();
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
            if (_animationController == null) initAnimations();
            _isLoading = false;
          });
        }
      },
    );
  }

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
      body: !_isLoading
          ? AnimatedBuilder(
              animation: _animationController!,
              builder: (ctx, kChild) => SlideTransition(
                position: Tween(
                  begin: const Offset(0, -0.5),
                  end: const Offset(0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: _animationController!,
                    curve: Curves.bounceOut,
                  ),
                ),
                child: kChild,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 32, top: 80, right: 32, bottom: 32),
                      child: Image(
                        image: AssetImage(
                            'assets/images/topmortar_transparent.png'),
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 180,
                                  child: MenuItems(
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
                                SizedBox(
                                  height: 220,
                                  child: MenuItems(
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
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 220,
                                  child: MenuItems(
                                    icon: Icons.lightbulb_circle,
                                    surfaceColor: Colors.green,
                                    title: 'Batchs',
                                    description: '${batchs.length} items',
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => const BatchScreen(),
                                      ),
                                      // ).then(
                                      //   (value) => getProducts(isLoading: false),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 180,
                                  child: MenuItems(
                                    icon: Icons.circle_notifications,
                                    surfaceColor: Colors.yellow.shade700,
                                    title: 'Notifications',
                                    description: '${messages.length} messages',
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) =>
                                            const NotificationsScreen(),
                                      ),
                                    ).then(
                                      (value) => getProducts(isLoading: false),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 180,
                        child: MenuItems(
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
                    Container(
                      padding: const EdgeInsets.all(32),
                      margin: const EdgeInsets.only(
                        left: 16,
                        top: 8,
                        right: 16,
                        bottom: 32,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Text('© 2024 Miraswift Auto Solusi'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: LoadingAnimationWidget.inkDrop(
                color: Colors.blue,
                size: 50,
              ),
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
    this.padding = const EdgeInsets.all(16),
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
      splashColor: surfaceColor!.withValues(alpha: 0.3),
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: margin,
        padding: padding,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
