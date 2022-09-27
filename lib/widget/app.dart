import 'package:aming_kit/aming_kit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


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
    OuiSize.init(widget.designWidthSize);
    //渲染前
    initApp();
    super.initState();
    //渲染后
  }

  void initApp() async{
    OuiGlobal.initMaterialApp = true;
    OuiRoute.init(widget.routes);
    OuiApp.initAppDir();
    OuiApp.initPackageInfo();
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
    initApp();
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
        builder: EasyLoading.init(
          builder: widget.builder,
        ),
      ),
    );
  }
}