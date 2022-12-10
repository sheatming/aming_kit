import 'dart:io';

import 'package:aming_kit/aming_kit.dart';
import 'package:flutter/services.dart';

import 'console.dart';

void openDevTools({
  BuildContext? context,
  OuiDevOption? option1,
  OuiDevOption? option2,
  OuiDevOption? option3,
  OuiDevOption? option4,
  OuiDevOption? option5,
  OuiDevOption? option6,
  OuiDevOption? option7,
  OuiDevOption? option8,
  OuiDevOption? option9,
}) => openOverlay("devTools",
    OuiDevTools(
  option1: option1,
  option2: option2,
  option3: option3,
  option4: option4,
  option5: option5,
  option6: option6,
  option7: option7,
  option8: option8,
  option9: option9,
), context: context);

class OuiDevOption{
  OuiDevOption(this.icon, this.text, {this.onClick});
  final IconData? icon;
  final String? text;
  final GestureTapCallback? onClick;
}

class OuiDevTools extends StatefulWidget {
  const OuiDevTools({
    Key? key,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.option5,
    this.option6,
    this.option7,
    this.option8,
    this.option9,
  }):super(key: key);

  final OuiDevOption? option1;
  final OuiDevOption? option2;
  final OuiDevOption? option3;
  final OuiDevOption? option4;
  final OuiDevOption? option5;
  final OuiDevOption? option6;
  final OuiDevOption? option7;
  final OuiDevOption? option8;
  final OuiDevOption? option9;



  static void open({
    BuildContext? context,
    OuiDevOption? option1,
    OuiDevOption? option2,
    OuiDevOption? option3,
    OuiDevOption? option4,
    OuiDevOption? option5,
    OuiDevOption? option6,
    OuiDevOption? option7,
    OuiDevOption? option8,
    OuiDevOption? option9,
  }) {
    log.setDebugMode(true);
    OuiCache.setBool("runDebug", true);
    openOverlay("devTools", OuiDevTools(
      option1: option1 ?? OuiDevOption(Icons.construction_outlined, "控制台", onClick: isNotNull(OuiGlobal.globalContext) ? () => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: OuiGlobal.globalContext!,
        builder: (BuildContext context){
          return const OuiConsole();
        },
      ) : null),
      option2: option2 ?? OuiDevOption(Icons.warning, ""),
      option3: option3 ?? OuiDevOption(Icons.warning, ""),
      option4: option4 ?? OuiDevOption(Icons.warning, ""),
      option5: option5 ?? OuiDevOption(Icons.warning, ""),
      option6: option6 ?? OuiDevOption(Icons.rotate_left, isNotNull(OuiGlobal.globalContext) ? "重启应用" : "退出应用", onClick: (){
        if(isNotNull(OuiGlobal.globalContext) && OuiGlobal.initMaterialApp){
          OuiMaterialApp.restartApp();
        } else {
          exit(0);
        }
      }),
      option7: option7 ?? OuiDevOption(Icons.cleaning_services, "清空缓存", onClick: (){
        OuiCache.clear();
        OuiCache.setBool("runDebug", true);
        if(isNotNull(OuiGlobal.globalContext) && OuiGlobal.initMaterialApp){
          OuiMaterialApp.restartApp();
        } else {
          exit(0);
        }
      }),
      option8: option8 ?? OuiDevOption(Icons.cached, "重启工具", onClick: (){
        open(
            option1: option1,
            option2: option2,
            option3: option3,
            option4: option4,
            option5: option5,
            option6: option6,
            option7: option7,
            option8: option8,
            option9: option9
        );
      }),
      option9: option9 ?? OuiDevOption(Icons.exit_to_app, "退出工具", onClick: () => close()),
    ));
    log.system("initialization", tag: "DebugTools");
  }

  static void close() {
    log.setDebugMode(false);
    OuiCache.setBool("runDebug", false);
    closeOverlay("devTools");
  }

  @override
  State createState() => _OuiDevTools();
}

class _OuiDevTools extends State<OuiDevTools> {

  final String _configDX = "oui_bugbox_dx";
  final String _configDY = "oui_bugbox_dy";
  final double _size = 50;

  Offset? offset;
  double _opacity = 0;
  bool isOpen = false;

  List<OuiDevOption> options = [];

  @override
  void initState() {
    super.initState();
    if(mounted){
      setState(() {
        if(isNotNull(widget.option1)) options.add(widget.option1!);
        if(isNotNull(widget.option2)) options.add(widget.option2!);
        if(isNotNull(widget.option3)) options.add(widget.option3!);
        if(isNotNull(widget.option4)) options.add(widget.option4!);
        if(isNotNull(widget.option5)) options.add(widget.option5!);
        if(isNotNull(widget.option6)) options.add(widget.option6!);
        if(isNotNull(widget.option7)) options.add(widget.option7!);
        if(isNotNull(widget.option8)) options.add(widget.option8!);
        if(isNotNull(widget.option9)) options.add(widget.option9!);

        double x = OuiCache.getDouble(_configDX, defValue: 0.0);
        double y = OuiCache.getDouble(_configDY, defValue: kToolbarHeight + 100);
        // if(_x != 0 && (_x > OuiSize.screenW() || _x < OuiSize.screenW())){
        //     log.info(_x);
        //     _x = OuiSize.screenW();
        //     log.info(_x);
        // }
        offset = Offset(x, y);
      });
    }
  }


  Offset _calOffset(Size size, Offset offset, Offset nextOffset) {
    double dx = 0;
    if (offset.dx + nextOffset.dx <= 0) {
      dx = 0;
    } else if (offset.dx + nextOffset.dx >= (size.width - _size)) {
      dx = size.width - _size;
    } else {
      dx = offset.dx + nextOffset.dx;
    }
    double dy = 0;
    if (offset.dy + nextOffset.dy >= (size.height - 100)) {
      dy = size.height - 100;
    } else if (offset.dy + nextOffset.dy <= kToolbarHeight) {
      dy = kToolbarHeight;
    } else {
      dy = offset.dy + nextOffset.dy;
    }
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        appBarTheme: AppBarTheme.of(context).copyWith(
          // brightness: Brightness.dark,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
          )
        ),

      ),
      child: AnimatedPositioned(
        left: isOpen == true ? (OuiSize.screenWidth() / 2 - 125) : offset?.dx,
        top: isOpen == true ? (OuiSize.screenHeight() / 2 - 125) : offset?.dy,
        duration: const Duration(milliseconds: 80),
        child: GestureDetector(
          onTap: _open,
          onPanUpdate: (detail) {
            if(isOpen == false){
              setState(() {
                _opacity = 0.3;
                offset = _calOffset(OuiSize.mediaQuery.size, offset!, detail.delta);
              });
            }
          },
          onPanEnd: (detail) {
            double screenWidget = OuiSize.screenWidth() - _size;
            double screen50Widget = screenWidget / 2;
            Offset? offset1 = offset;
            Offset? offset2 = offset;
            if(offset!.dx > screen50Widget){
              offset2 = Offset(screenWidget, 0);
            } else {
              offset1 = Offset(0, offset!.dy);
              offset2 = const Offset(0, 0);
            }
            setState(() {
              offset = _calOffset(MediaQuery.of(context).size, offset1!, offset2!);
              OuiCache.setDouble(_configDX, offset!.dx);
              OuiCache.setDouble(_configDY, offset!.dy);
            });
            setTimeout((){
              if(isOpen == false){
                setState(() {
                  _opacity = 0;
                });
              }
            }, time: 1500);
          },

          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            // firstCurve: Curves.easeInCirc,
            // secondCurve: Curves.easeInToLinear,
            // sizeCurve: Curves.bounceOut,
            crossFadeState: !isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            secondChild: Material(
              color: Theme.of(context).textTheme.headline6!.color!.withOpacity(0.5 + _opacity),
              borderRadius: BorderRadius.circular(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Theme.of(context).textTheme.headline6!.color!.withOpacity(0.5 + _opacity),
                  ),
                  child: Center(
                    child: Wrap(
                      spacing: 0,
                      runSpacing: 0,
                      children: options.map<Widget>(_btn).toList(),
                    ),
                  ),
                ),
              ),
            ),
            firstChild: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _size,
              width: _size,
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.headline6!.color!.withOpacity(0.2 + _opacity),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _size - 15,
                  width: _size - 15,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5 + _opacity),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: _size - 23,
                      width: _size - 23,
                      decoration: BoxDecoration(

                        color: Colors.white.withOpacity(0.5 + _opacity),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Icon(Icons.bug_report,
                        color: Colors.black.withOpacity(0.3),
                        size: _size - 30,
                      ),

                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }

  void _open(){
    if(!isOpen){
      setState(() {
        isOpen = true;
        _opacity = 0.3;
        setTimeout((){
          setState(() {
            isOpen = false;
            _opacity = 0;
          });
        }, time: 5000, key: "debugToolX");
      });
    }
  }

  Widget _btn(OuiDevOption option){
    GestureTapCallback? onClick = option.onClick;
    String? text = option.text;
    IconData? icon = option.icon;

    return Visibility(
      visible: isOpen,
      child: GestureDetector(
        onTap: (){
          setState(() {
            clearTimeout("debugToolX");
            isOpen = false;
            _opacity = 0;
          });
          if(isNotNull(onClick)) onClick!();
        },

        child: Container(
          margin: const EdgeInsets.all(1),
          height: 80,
          width: 80,
          decoration: const BoxDecoration(
          ),
          child: Center(
            child: isNotNull(onClick) ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: Icon(icon, color: Colors.white),
                  ),
                ),
                Text(text ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ) : null,
          ),
        ),
      ),
    );
  }
}


autoOpenDevTool({
  BuildContext? context,
  OuiDevOption? option1,
  OuiDevOption? option2,
  OuiDevOption? option3,
  OuiDevOption? option4,
  OuiDevOption? option5,
  OuiDevOption? option6,
  OuiDevOption? option7,
  OuiDevOption? option8,
  OuiDevOption? option9,
}){
  if(OuiCache.getBool("runDebug", defValue: false)){
    OuiDevTools.open(
        option1: option1,
        option2: option2,
        option3: option3,
        option4: option4,
        option5: option5,
        option6: option6,
        option7: option7,
        option8: option8,
        option9: option9
    );
  }
}

class OuiRunTimePoint{

  static Map<String, Map<String, dynamic>> pointLog = {};

  static void startPoint(String name, String title) async{
    pointLog.remove(name);
    pointLog.addAll({name: {"sp": DateTime.now().millisecondsSinceEpoch, "ep": 0, "title": title}});
  }

  static void endPoint(String name) async{
    if(pointLog.containsKey(name)){
      Map<String, dynamic>? tmp = pointLog[name];
      tmp!['ep'] = DateTime.now().millisecondsSinceEpoch;
      pointLog[name] = tmp;
    }
  }

  static int getMS(String name) {
    if(pointLog.containsKey(name)){
      Map<String, dynamic>? tmp = pointLog[name];
      if(tmp!['ep']! == 0) return -2;
      if(tmp['sp']! == 0) return -1;
      return tmp['ep']! - tmp['sp']!;
    } else {
      return -2;
    }
  }
}
