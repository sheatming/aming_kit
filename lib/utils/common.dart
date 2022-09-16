
import 'package:aming_kit/aming_kit.dart';
import 'package:flutter/material.dart';


/// 检查是否为空
bool isNotNull(object){
  if(object == null) return false;
  if(object == "null") return false;
  if(object == "false") return false;
  if(object == false) return false;
  if(object == "") return false;
  if(object == {}) return false;
  if(object.toString() == "{}") return false;
  if(object == []) return false;
  if(object.toString().isEmpty) return false;
  if(object.runtimeType == List && object.length == 0) return false;
  return true;
}

Map <int, TimerUtil?> _timeUtil = {};

TimerUtil? setTimeout(Function f, [int time = 1000]){
  int index = f.hashCode;
  if(isNotNull(_timeUtil[index])){
    _timeUtil[index]?.cancel();
    _timeUtil[index] = null;
  }
  try{
    _timeUtil[index] = TimerUtil(mInterval: 1, mTotalTime: time);
    _timeUtil[index]!.setOnTimerTickCallback((int value) {
      if(value == 0) {
        _timeUtil[index]!.cancel();
        _timeUtil[index] = null;
        f();
        return;
      }
    });
    _timeUtil[index]!.startCountDown();
  } catch (e){
    log.error(e, tag: "setTimeout");
    _timeUtil[index]?.cancel();
    _timeUtil[index] = null;
  }
  return _timeUtil[index];
}

TimerUtil? setCountDown({
  Function? onDone,
  Function? onProgress,
  int time = 60
}){
  int index = time;
  if(isNotNull(_timeUtil[index])){
    _timeUtil[index]?.cancel();
    _timeUtil[index] = null;
  }
  try{
    _timeUtil[index] = TimerUtil(mInterval: 1000, mTotalTime: time * 1000);
    _timeUtil[index]!.setOnTimerTickCallback((int value) {
      if(value == 0) {
        if(isNotNull(onProgress)) onProgress!(0);
        _timeUtil[index]!.cancel();
        _timeUtil[index] = null;
        if(isNotNull(onDone)) onDone!();
        return;
      } else {
        if(isNotNull(onProgress)) onProgress!(value ~/ 1000);
      }
    });
    _timeUtil[index]!.startCountDown();
  } catch (e){
    log.error(e, tag: "setTimeout");
    _timeUtil[index]?.cancel();
    _timeUtil[index] = null;
  }
  return _timeUtil[index];

}

getData(field, {defValue}){
  return isNotNull(field) ? field : defValue;
}

Map<String, OverlayEntry?> entrys = {};

void openOverlay(String key, Widget child, {BuildContext? context}){

  BuildContext? _context = context ?? OuiGlobal.globalContext;
  // if(!isNotNull(child)) return;
  if(!isNotNull(_context)){
    log.error("context无效");
    return;
  }

  if(isNotNull(entrys[key])){
    entrys[key]?.remove();
    entrys[key] = null;
  }
  entrys[key] = OverlayEntry(builder: (context) {
    return child;
  });

  setTimeout(() => Overlay.of(_context!)!.insert(entrys[key]!), 100);
}

void closeOverlay(String key){
  if(isNotNull(entrys[key])){
    entrys[key]?.remove();
    entrys[key] = null;
  }
}