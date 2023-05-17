import 'package:aming_kit/aming_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class OuiMaterialApp extends StatefulWidget {
  const OuiMaterialApp({Key? key,
    this.routes,
    this.home,
    this.debugShowCheckedModeBanner,
    this.showModeBanner = false,
    this.bannerMessage,
    this.bannerColor,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.theme,
    this.builder,
    this.title = '',
    this.navigatorObservers,
    this.onInit,
    this.designScreenWidth = 750.0,
  }) : super(key: key);

  final Map<String, Widget>? routes;
  final Widget? home;
  final bool? debugShowCheckedModeBanner;
  final bool showModeBanner;
  final String? bannerMessage;
  final Color? bannerColor;
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final ThemeData? theme;
  final TransitionBuilder? builder;
  final String title;
  final List<NavigatorObserver>? navigatorObservers;
  final Future<void>? onInit;
  final double designScreenWidth;

  static void restartApp({BuildContext? context}) {
    BuildContext tmpContext = context ?? OuiGlobal.globalContext!;
    if(!isNotNull(tmpContext)) throw contextError;
    tmpContext.findAncestorStateOfType<_OuiMaterialApp>()?.restartApp();
  }

  @override
  State<OuiMaterialApp> createState() => _OuiMaterialApp();
}

class _OuiMaterialApp extends State<OuiMaterialApp> with WidgetsBindingObserver {

  Key appKey = UniqueKey();
  Key bannerKey = UniqueKey();
  final botToastBuilder = BotToastInit();
  @override
  void initState() {
    // OuiSize.init(widget.designWidthSize);
    //渲染前
    OuiSize.init(number: widget.designScreenWidth);
    initApp();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //渲染后
  }



  @override
  void didChangeMetrics(){
    OuiSize.init(number: widget.designScreenWidth, isForce: true);
    super.didChangeMetrics();
  }

  void initApp() async{
    OuiGlobal.initMaterialApp = true;
    await OuiCache.init();
    OuiRoute.init(widget.routes);
    OuiApp.initAppDir();
    OuiApp.initPackageInfo();
    if(isNotNull(widget.onInit)) await widget.onInit!;

    Future.delayed(Duration(seconds: 1), (){
      print(widget.bannerMessage);
      if(mounted) setState(() {});
    });
  }


  @override
  void dispose() {
    //销毁前
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    //销毁后
  }

  void restartApp() {
    setState(() {
      appKey = UniqueKey();
      bannerKey = UniqueKey();
    });
    initApp();
  }

  @override
  void activate() {
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    // if(isNotNull(widget.easyLoading)) widget.easyLoading!;

    return KeyedSubtree(
      key: appKey,
      child: MaterialApp(
        title: widget.title,
        navigatorKey: OuiGlobal.navigatorKey,
        navigatorObservers: [
          routeObserver,
          BotToastNavigatorObserver(),
          if(isNotNull(widget.navigatorObservers))
            ...widget.navigatorObservers!.map((e) => e).toList(),
        ],
        debugShowCheckedModeBanner: (widget.debugShowCheckedModeBanner == true && widget.showModeBanner == false) ?? false,
        onGenerateRoute: OuiRoute.generator,
        home: widget.home,
        supportedLocales: widget.supportedLocales,
        localizationsDelegates: widget.localizationsDelegates,
        theme: widget.theme,
        // builder: EasyLoading.init(
        //   builder: widget.builder,
        // ),
        // builder: (context, child) {
        //   return EasyLoading.init(builder: widget.builder);
        // },
        builder: EasyLoading.init(
          builder: (context, child) {
            Widget _child = botToastBuilder(context, child);
            if(widget.showModeBanner == true){
              return Banner(
                key: bannerKey,
                message: widget.bannerMessage??"debug",
                location: BannerLocation.topEnd,
                child: _child,
                color: widget.bannerColor ?? Color(0xA0B71C1C),
              );
            } else {
              return _child;
            }

          },
        ),
        ),
      // child:
    );
  }
}
