import 'dart:io';
import 'package:aming_kit/aming_kit.dart';
import '../tools/console.dart';

export 'package:fluro/fluro.dart';

class OuiRoute {
  static FluroRouter? router;

  static Map<String, dynamic> params = {};
  static Map<String, dynamic> rags = {};

  // static List<String> historyRoute = [];
  static get generator => router?.generator;

  static void init(Map<String, Widget>? routes) {
    if (!isNotNull(routes)) {
      routes = {};
    }
    if (!isNotNull(router)) router = FluroRouter();
    String tmpLog = "";

    routes?.addAll({"debug.console": const OuiConsole()});
    routes?.forEach((String route, Widget page) {
      tmpLog += "$route#br#";
      registerRoute(route, page, true);
    });
    log.system("initialization", tag: "Route");
    if (isNotNull(tmpLog)) log.debug(tmpLog, tag: "Register Route");
  }

  static void registerRoute(String routePath, Widget page, [bool isInit = false]) {
    if (!isNotNull(router)) router = FluroRouter();
    router!.define(routePath, handler: Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> res) {
      String route = "_${page.runtimeType.toString()}";
      String routeState = "_${page.runtimeType.toString()}State";
      if (!isNotNull(res)) res = {};

      if (isNotNull(params[route])) params.remove(route);
      if (isNotNull(params[routeState])) params.remove(routeState);
      if (isNotNull(rags[route])) rags.remove(route);
      if (isNotNull(rags[routeState])) rags.remove(routeState);

      if (isNotNull(context!.settings!.arguments) && context.settings!.arguments is _OuiRouterModel) {
        _OuiRouterModel ouiRouterModel = context.settings!.arguments as _OuiRouterModel;
        params.addAll({
          route: ouiRouterModel.data,
          routeState: ouiRouterModel.data,
        });
        if (isNotNull(ouiRouterModel.arguments)) {
          rags.addAll({
            route: ouiRouterModel.arguments,
            routeState: ouiRouterModel.arguments,
          });
        }
      } else {
        params.addAll({
          route: res,
          routeState: res,
        });
        if (isNotNull(context!.settings!.arguments)) {
          rags.addAll({
            route: context.settings!.arguments,
            routeState: context.settings!.arguments,
          });
        }
      }

      return page;
    }));
    if (!isInit) log.debug(routePath, tag: "Register Route");
  }

  static Future goto(
    String path, {
    BuildContext? context,
    bool clearStack = false,
    Map? data,
    TransitionType? transition,
    ValueChanged? onBack,
    bool replace = false,
    Object? arguments,
  }) async {
    BuildContext? tmpContext = context ?? OuiGlobal.globalContext;
    // if (isNotNull(data)) path = "$path";
    String tmpLog = path;
    if (isNotNull(data)) tmpLog += "#br#$data";
    if (isNotNull(arguments)) tmpLog += "#br#$arguments";
    if (clearStack) tmpLog += "#br#clearStack: $clearStack";
    log.debug(tmpLog, tag: "跳转路由", type: "Route");
    if (!isNotNull(tmpContext)) throw contextError;
    TransitionType tmpTransition = transition ?? (Platform.isIOS ? TransitionType.cupertino : TransitionType.inFromRight);
    var result = await OuiRoute.router!.navigateTo(
      tmpContext!,
      path,
      transition: tmpTransition,
      replace: replace,
      clearStack: clearStack,
      routeSettings: RouteSettings(
        arguments: _OuiRouterModel(
          data: data,
          arguments: arguments,
        ),
      ),
    );
    if (isNotNull(onBack)) onBack!(result);
    return result;
  }
}

class _OuiRouterModel {
  _OuiRouterModel({this.data, this.arguments});
  final Map? data;
  final Object? arguments;
}

getParams(String field, object, {defValue, bool isArgs = false}) {
  String route = object.runtimeType.toString();
  if (field == "-") {
    Map<String, dynamic> tmpParams = {};
    OuiRoute.params[route]?.forEach((key, value) {
      tmpParams.addAll({key: value.first});
    });
    return tmpParams;
  }
  if (OuiRoute.params?.containsKey(route) == true && OuiRoute.params[route]?.containsKey(field) == true) {
    var tmpParam = OuiRoute.params[route]![field]?.first;
    return tmpParam;
  }
  return defValue;
}

getArgs(object, {defValue}) {
  String tmpRoute = object.runtimeType.toString();
  if (isNotNull(OuiRoute.rags[tmpRoute])) {
    return OuiRoute.rags[tmpRoute]! ?? defValue;
  } else {
    return defValue;
  }
}

void goback({BuildContext? context, Object? data, int delta = 1}) {
  NavigatorState navigatorState = Navigator.of(context ?? OuiGlobal.globalContext!);
  for (var item in (delta - 1).toList) {
    navigatorState..pop(data);
  }
}
