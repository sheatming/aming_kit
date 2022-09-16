import 'package:flutter/material.dart';

import '../utils/global.dart';
import '../utils/router.dart';
import '../utils/size.dart';

class OuiMaterialApp extends StatefulWidget {
  const OuiMaterialApp({Key? key,
    this.routes,
    this.designWidthSize = 750,
    this.home,
    this.debugShowCheckedModeBanner,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.theme,
    this.builder,
    this.title = '',
  }) : super(key: key);

  final Map<String, Widget>? routes;
  final double? designWidthSize;
  final Widget? home;
  final bool? debugShowCheckedModeBanner;
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final ThemeData? theme;
  final TransitionBuilder? builder;
  final String title;


  static void restartApp({BuildContext? context}) {
    BuildContext _context = context ?? OuiGlobal.globalContext!;
    _context.findAncestorStateOfType<_OuiMaterialApp>()?.restartApp();
  }

  @override
  State<OuiMaterialApp> createState() => _OuiMaterialApp();
}

class _OuiMaterialApp extends State<OuiMaterialApp> {

  Key appKey = UniqueKey();

  @override
  void initState() {
    //渲染前
    OuiGlobal.initMaterialApp = true;
    OuiRoute.init(widget.routes);
    OuiSize.init(widget.designWidthSize);
    super.initState();
    //渲染后
  }

  @override
  void dispose() {
    //销毁前
    super.dispose();
    //销毁后
  }

  void restartApp() {
    setState(() {
      appKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: appKey,
      child: MaterialApp(
        title: widget.title,
        navigatorKey: OuiGlobal.navigatorKey,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner ?? false,
        onGenerateRoute: OuiRoute.generator,
        home: widget.home,
        supportedLocales: widget.supportedLocales,
        localizationsDelegates: widget.localizationsDelegates,
        theme: widget.theme,
        builder: widget.builder,
      ),
    );
  }
}
