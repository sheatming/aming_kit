import 'package:flutter/material.dart';
class OuiRouteObserver{
  static final _observerUtil = OuiRouteObserver._internal();
  final RouteObserver<PageRoute> _routeObserver = RouteObserver();
  factory OuiRouteObserver(){
    return _observerUtil;
  }

  OuiRouteObserver._internal();

  RouteObserver<PageRoute> get routeObserver => _routeObserver;

}