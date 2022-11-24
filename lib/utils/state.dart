import 'package:aming_kit/aming_kit.dart';
import 'package:aming_kit/utils/route_observer.dart';
import 'package:aming_kit/utils/router.dart';
import 'package:flutter/material.dart';

@optionalTypeArgs
abstract class OuiState<T extends StatefulWidget> extends State with RouteAware {

  /// 获取当前State的路由参数
  @protected
  @mustCallSuper
  getRouteParams(String field, {defValue}) => getParams(field, this, defValue: defValue);

  /// 获取当前State的路由参数
  @protected
  @mustCallSuper
  getRouteArgs({defValue}) => getArgs(this, defValue: defValue);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }



  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }


  @override
  void didPushNext() {
    super.didPushNext();
  }

  @override
  void didPop() {
    super.didPop();
  }

  @override
  void didPush() {
    super.didPush();
  }

  @override
  void didPopNext() {
    super.didPopNext();
  }

  // // 从一个PageRoute路由回到当前widget 所在的路由时候的回调  首次加载不触发
  // void onShow() {}
  // // 当前widget 所在的路由push一个PageRoute路由时的回调，dispose时不触发
  // void onHide() {
  //   print("lllalalalsdlfasdf");
  // }
  // // 触发app 后台 回调
  // void onAppBackground() {}
  // // 触发app 前台 回调
  // void onAppForeground() {}

}