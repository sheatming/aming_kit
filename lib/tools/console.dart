import 'package:aming_kit/aming_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class OuiConsole extends StatefulWidget {
  const OuiConsole({Key? key}) : super(key: key);

  @override
  State<OuiConsole> createState() => _OuiConsole();
}

class _OuiConsole extends State<OuiConsole> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.black
          ),
          title: const Text("控制台"),
          bottom: TabBar(
            indicatorWeight: 8.px,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black,
            controller: _tabController,
            padding: const EdgeInsets.only(
              top: 1,
              bottom: 1,
            ),
            tabs: const [
              Tab(child: Text("Device")),
              Tab(child: Text("Console")),
              Tab(child: Text("Network")),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            _DeviceInfo(),
            _ConsoleLog(),
            _NetworkLog(),
          ],
        )

    );
  }
}

class _DeviceInfo extends StatefulWidget {
  const _DeviceInfo({Key? key}) : super(key: key);

  @override
  State<_DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<_DeviceInfo> {

  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;

  @override
  void initState() {
    _initDeviceInfo();
    super.initState();
  }

  void _initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(isIOS){
      iosInfo = await deviceInfo.iosInfo;
    } else if(isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
    }
    if(mounted)setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfffafafa),
      ),
      child: ListView(
        padding: const EdgeInsets.only(
          top: 10
        ),
        children: [
          if(isIOS)
            Column(
              children: const [

              ],
            ),
          if(isAndroid && isNotNull(androidInfo))
            Column(
              children: [
                _infoItem("品牌", androidInfo?.brand),
                _infoItem("型号", androidInfo?.model),
                _infoItem("制造商", androidInfo?.manufacturer),
                _infoItem("设备ID", androidInfo?.id),
                _infoItem("AndroidSDK版本", androidInfo?.version.sdkInt),
                _infoItem("物理设备", androidInfo?.isPhysicalDevice),
                _infoItem("屏幕尺寸", "${OuiSize.mediaQuery.size.height}/${OuiSize.mediaQuery.size.width}"),
                _infoItem("设备像素比", "${OuiSize.mediaQuery.devicePixelRatio}/${OuiSize.ratio}"),
              ],
            ),
        ],
      ),
    );
  }

  Widget _infoItem(title, content, {bool isBorder = true}){
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(
        bottom: 5
      ),
      child: ListTile(
        dense: true,
        title: Text(title),
        subtitle: Text("${content ?? '-'}"),
      ),
    );
  }
}



class _ConsoleLog extends StatefulWidget {
  const _ConsoleLog({Key? key}) : super(key: key);

  @override
  State<_ConsoleLog> createState() => _ConsoleLogState();
}

class _ConsoleLogState extends State<_ConsoleLog> {
  List<ConsoleLogItem> _list = [];

  @override
  void initState() {
    _list = consoleLog;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfffafafa),
      ),
      child: RefreshIndicator(
        onRefresh: _onRefresh,//下拉刷新回调
        notificationPredicate: defaultScrollNotificationPredicate, //是否应处理滚动通知的检查（是否通知下拉刷新动作）
        child: ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          itemCount: _list.length,
          itemBuilder: (BuildContext context,int index) => _item(_list[index]),
        ),
      ),
    );
  }

  Future<void> _onRefresh(){
    setState(() {
      _list = consoleLog;
    });
    return Future.delayed(const Duration(seconds: 1),(){});
  }

  Widget _item(ConsoleLogItem item){
    return GestureDetector(
      onTap: () => openDetailDialog(context, "日志详情", children: [
        _detailText("时间", item.date.toTime()),
        _detailText("类型", item.cate.toString().replaceAll("LogCate.", "").toUpperCase()),
        if(isNotNull(item.tag)) _detailText("标签", item.tag!),
        _detailText("方法", item.path.toString()),
        const SizedBox(height: 8),
        const Divider(height: 1, color: Colors.white),
        _detailText("内容", item.content.toString()),
      ]),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  _statusText(item.cate),
                  const SizedBox(width: 8,),
                  Text(item.tag ?? "", style: const TextStyle(
                      fontSize: 12,
                  )),
                  Expanded(child: Container()),
                  Text(item.date.toTime(), style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black38
                  )),
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(child: Text(item.content, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(
                    fontSize: 12,
                  ))),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusText(LogCate cate){
    Color backgroundColor = Colors.redAccent;
    switch(cate){
      case LogCate.debug:
        backgroundColor = Colors.blue;
        break;
      case LogCate.error:
        backgroundColor = Colors.redAccent;
        break;
      case LogCate.warn:
        backgroundColor = Colors.orangeAccent;
        break;
      case LogCate.system:
        backgroundColor = Colors.purple;
        break;
      default:
        backgroundColor = Colors.black38;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(3),
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 1.3,
          horizontal: 3
      ),
      child: Text(cate.toString().replaceAll("LogCate.", "").toUpperCase(), style: TextStyle(
        fontSize: 12,
        color: backgroundColor.antiWhite(),
      )),
    );
  }
}



class _NetworkLog extends StatefulWidget {
  const _NetworkLog({Key? key}) : super(key: key);

  @override
  State<_NetworkLog> createState() => _NetworkLogState();
}

class _NetworkLogState extends State<_NetworkLog> {

  List<NetworkLogItem> _list = [];

  @override
  void initState() {
    _list = networkLog;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfffafafa),
      ),
      child: RefreshIndicator(
        onRefresh: _onRefresh,//下拉刷新回调
        notificationPredicate: defaultScrollNotificationPredicate, //是否应处理滚动通知的检查（是否通知下拉刷新动作）
        child: ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          itemCount: _list.length,
          itemBuilder: (BuildContext context,int index) => _item(_list[index]),
        ),
      ),
    );
  }

  Future<void> _onRefresh(){
      setState(() {
        _list = networkLog;
      });
      return Future.delayed(const Duration(seconds: 1),(){});
  }



  Widget _item(NetworkLogItem item){
    return GestureDetector(
      onTap: () => openDetailDialog(context, "网络请求", children: [
        GestureDetector(
          onTap: (){
            Clipboard.setData(ClipboardData(text: item.url));
          },
          child: _detailText("请求Url", item.url),
        ),
        _detailText("请求时间", item.date.toTime()),
        _detailText("请求方法", item.method),
        _detailText("状态代码", item.statusCode.toString()),
        _detailText("请求消息", item.statusMessage.toString()),
        _detailText("请求参数", "\r\n${_convert(item.params, 2)}"),
        _detailText("请求头", "\r\n${_convert(item.header, 2)}"),
        const SizedBox(height: 8),
        const Divider(height: 1, color: Colors.white),
        _detailText("响应头", "\r\n${_convert(item.queryHeader, 2)}"),
        _detailText("响应时间", "${item.queryTime.toString()}ms"),
        _detailText("响应参数", "\r\n${_convert(item.data, 2)}"),
      ]),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  _statusText(item.statusCode),
                  const SizedBox(width: 8,),
                  Text(item.method, style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  )),
                  const SizedBox(width: 8,),
                  Text("${item.queryTime}ms", style: const TextStyle(
                    fontSize: 12,
                  )),

                  Expanded(child: Container()),
                  Text(item.date.toTime(), style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black38
                  )),
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(child: Text("Url: ${item.url}", style: const TextStyle(
                    fontSize: 12,
                  ))),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _statusText(int code){
    Color backgroundColor = Colors.redAccent;
    switch(code){
      case 200:
        backgroundColor = Colors.lightGreen;
        break;
      case 0:
        backgroundColor = Colors.black38;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(3),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 1.3,
        horizontal: 3
      ),
      child: Text("$code", style: TextStyle(
        fontSize: 12,
        color: backgroundColor.antiWhite(),
      )),
    );
  }
}

Widget _detailText(String title, String text){
  return Column(
    children: [
      const SizedBox(height: 8),
      Text("$title: $text", style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ))
    ],
  );
}


/// [object]  解析的对象
/// [deep]  递归的深度，用来获取缩进的空白长度
/// [isObject] 用来区分当前map或list是不是来自某个字段，则不用显示缩进。单纯的map或list需要添加缩进
String _convert(dynamic object, int deep, {bool isObject = false}) {
  var buffer = StringBuffer();
  var nextDeep = deep + 1;
  if (object is Map) {
    var list = object.keys.toList();
    if (!isObject) {//如果map来自某个字段，则不需要显示缩进
      buffer.write(getDeepSpace(deep));
    }
    buffer.write("{");
    if (list.isEmpty) {//当map为空，直接返回‘}’
      buffer.write("}");
    }else {
      buffer.write("\n");
      for (int i = 0; i < list.length; i++) {
        buffer.write("${getDeepSpace(nextDeep)}\"${list[i]}\":");
        buffer.write(_convert(object[list[i]], nextDeep, isObject: true));
        if (i < list.length - 1) {
          buffer.write(",");
          buffer.write("\n");
        }
      }
      buffer.write("\n");
      buffer.write("${getDeepSpace(deep)}}");
    }
  } else if (object is List) {
    if (!isObject) {//如果list来自某个字段，则不需要显示缩进
      buffer.write(getDeepSpace(deep));
    }
    buffer.write("[");
    if (object.isEmpty) {//当list为空，直接返回‘]’
      buffer.write("]");
    }else {
      buffer.write("\n");
      for (int i = 0; i < object.length; i++) {
        buffer.write(_convert(object[i], nextDeep));
        if (i < object.length - 1) {
          buffer.write(",");
          buffer.write("\n");
        }
      }
      buffer.write("\n");
      buffer.write("${getDeepSpace(deep)}]");
    }
  } else if (object is String) {//为字符串时，需要添加双引号并返回当前内容
    buffer.write("\"$object\"");
  } else if (object is num || object is bool) {//为数字或者布尔值时，返回当前内容
    buffer.write(object);
  }  else {//如果对象为空，则返回null字符串
    buffer.write("null");
  }
  return buffer.toString();
}


String getDeepSpace(int deep) {
  var tab = StringBuffer();
  for (int i = 0; i < deep; i++) {
    tab.write("\t");
  }
  return tab.toString();
}

void openDetailDialog(BuildContext context, String title, {List<Widget>? children}) => showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (BuildContext context){
      return GestureDetector(
        onTap: () => goback(),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: OuiSize.screenHeight() - 300,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            padding: const EdgeInsets.only(
                top: 8,
                left: 16,
                right: 16,
                bottom: 16,
            ),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, .9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      ...children!.map((e) => e).toList(),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      );
    }
);