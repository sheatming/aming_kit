import 'package:aming_kit/aming_kit.dart';

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
  T get getWidget => widget as T;
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   routeObserver.subscribe(this, ModalRoute.of(context)!);
  // }
  //
  // @override
  // void dispose() {
  //   routeObserver.unsubscribe(this);
  //   super.dispose();
  // }


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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {

    super.dispose();
  }

}