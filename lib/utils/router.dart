import 'dart:io';
import 'package:aming_kit/aming_kit.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../tools/console.dart';

class OuiRoute {

  static FluroRouter? router;

  static Map<String, Map<String, dynamic>> params = {};

  // static List<String> historyRoute = [];

  static void init(Map<String, Widget> routes){
    if(!isNotNull(routes)){
      routes = {};
    }
    if(!isNotNull(router)) router = FluroRouter();
    String _log = "";

    routes.addAll({"debug.console": const OuiConsole()});
    routes.forEach((String route, Widget page){
      _log += "$route#br#";
      router!.define(route,
          handler: Handler(
              handlerFunc: (BuildContext? context, Map<String, dynamic> res) {
                String _route = "_${page.runtimeType.toString()}";
                if(!isNotNull(res)) res = {};
                if(isNotNull(context!.settings!.arguments)){
                  res['args'] = context.settings!.arguments;
                }
                if(isNotNull(params[_route])){
                  params[_route] = res;
                } else {
                  params.addAll({_route: res});
                }
                return page;
              }
          )
      );
    });
    log.system("initialization", tag: "Route");
    log.debug(_log, tag: "Register Route");

  }
}

getParams(String field, object, {defValue, bool isArgs = false}){
  String _route = object.runtimeType.toString();
  // print("读取参数：$_route");

  if(field == "-") return OuiRoute.params[_route];

  if(isArgs && isNotNull(OuiRoute.params[_route]!["args"])){
    return OuiRoute.params[_route]![field] ?? defValue ?? "";
  } else if(isNotNull(OuiRoute.params[_route])){
    return OuiRoute.params[_route]![field]?.first ?? defValue ?? "";
  }

  return defValue ?? "";
}

getArgs(object, {defValue}){
  String _route = object.runtimeType.toString();
  if(isNotNull(OuiRoute.params[_route]) && isNotNull(OuiRoute.params[_route]!["args"])){
    return OuiRoute.params[_route]!["args"] ?? defValue;
  } else {
    return defValue ?? "";
  }
}

void goback({BuildContext? context, Object? data}){
  Navigator.pop(context ?? OuiGlobal.globalContext!, data);
}

Future goto(String? path, {
  BuildContext? context,
  bool clearStack = false,
  TransitionType? transition,
  ValueChanged? onBack,
  bool replace = false,
  Object? arguments,
}) async {
  BuildContext? _context = context ?? OuiGlobal.globalContext;
  log.info(path, tag: "跳转路由", type: "Route");
  if(!isNotNull(_context)){
    log.error("context无效, 请在MaterialApp中将[OuiGlobal.navigatorKey]注册到[navigatorKey]", type: "Route");return;
  }
  TransitionType _transition = transition ?? (Platform.isIOS ? TransitionType.cupertino : TransitionType.inFromRight);
  var result = await OuiRoute.router!.navigateTo(_context!, path!,
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