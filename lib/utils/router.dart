import 'dart:io';
import 'package:aming_kit/aming_kit.dart';
import '../tools/console.dart';

export 'package:fluro/fluro.dart';

class OuiRoute {

  static FluroRouter? router;

  static Map<String, Map<String, dynamic>> params = {};
  static Map<String, dynamic> rags = {};

  // static List<String> historyRoute = [];
  static get generator => router?.generator;

  static void init(Map<String, Widget>? routes){
    if(!isNotNull(routes)){
      routes = {};
    }
    if(!isNotNull(router)) router = FluroRouter();
    String _log = "";

    routes?.addAll({"debug.console": const OuiConsole()});
    routes?.forEach((String route, Widget page){
      _log += "$route#br#";
      registerRoute(route, page, true);
    });
    log.system("initialization", tag: "Route");
    if(isNotNull(_log)) log.debug(_log, tag: "Register Route");
  }

  static void registerRoute(String routePath, Widget page, [bool isInit = false]){
    if(!isNotNull(router)) router = FluroRouter();
    router!.define(routePath,
        handler: Handler(
            handlerFunc: (BuildContext? context, Map<String, dynamic> res) {
              String route = "_${page.runtimeType.toString()}";
              String routeState = "_${page.runtimeType.toString()}State";

              if(!isNotNull(res)) res = {};

              if(isNotNull(params[route])) params.remove(route);
              if(isNotNull(params[routeState])) params.remove(routeState);

              params.addAll({
                route: res,
                routeState: res,
              });

              if(isNotNull(rags[route])) rags.remove(route);
              if(isNotNull(rags[routeState])) rags.remove(routeState);

              if(isNotNull(context!.settings!.arguments)){
                rags.addAll({
                  route: context.settings!.arguments,
                  routeState: context.settings!.arguments,
                });
              }
              return page;
            }
        )
    );
    if(!isInit) log.debug(routePath, tag: "Register Route");
  }

  static Future goto(String path, {
    BuildContext? context,
    bool clearStack = false,
    Map? data,
    TransitionType? transition,
    ValueChanged? onBack,
    bool replace = false,
    Object? arguments,
  }) async{
    BuildContext? _context = context ?? OuiGlobal.globalContext;
    if(isNotNull(data)) path = "$path?${data!.toUrl}";
    String _log = path;
    if(isNotNull(arguments)) _log += "#br#$arguments";
    if(clearStack) _log += "#br#clearStack: $clearStack";
    log.debug(_log, tag: "跳转路由", type: "Route");
    if(!isNotNull(_context)){
      log.error("context无效, 请在MaterialApp中将[OuiGlobal.navigatorKey]注册到[navigatorKey]", type: "Route");return;
    }
    TransitionType _transition = transition ?? (Platform.isIOS ? TransitionType.cupertino : TransitionType.inFromRight);
    var result = await OuiRoute.router!.navigateTo(_context!, path,
      transition: _transition,
      replace: replace,
      clearStack: clearStack,
      routeSettings: RouteSettings(
          arguments: arguments
      ),
    );
    if(isNotNull(onBack)) onBack!(result);
    return result;
  }
}

getParams(String field, object, {defValue, bool isArgs = false}){
  String route = object.runtimeType.toString();
  if(field == "-") return OuiRoute.params[route];
  if(isNotNull(OuiRoute.params[route])){
    return OuiRoute.params[route]![field]?.first ?? defValue;
  }
  return defValue;
}

getArgs(object, {defValue}){
  String _route = object.runtimeType.toString();
  if(isNotNull(OuiRoute.rags[_route])){
    return OuiRoute.rags[_route]! ?? defValue;
  } else {
    return defValue;
  }
}

void goback({BuildContext? context, Object? data}){
  Navigator.pop(context ?? OuiGlobal.globalContext!, data);
}

