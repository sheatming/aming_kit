import 'package:aming_kit/aming_kit.dart';

/// 检查是否为空
bool isNotNull(object) {
  if (object == null) return false;
  if (object == "null") return false;
  if (object == "false") return false;
  if (object == false) return false;
  if (object == "") return false;
  if (object == {}) return false;
  if (object.toString() == "{}") return false;
  if (object == []) return false;
  if (object.toString().isEmpty) return false;
  if (object.runtimeType == List && object.length == 0) return false;
  return true;
}

Map<String, TimerUtil?> _timeUtil = {};

TimerUtil? setTimeout(Function f, {int time = 1000, String? key}) {
  String index = key ?? f.hashCode.toString();
  if (isNotNull(_timeUtil[index])) {
    _timeUtil[index]?.cancel();
    _timeUtil[index] = null;
  }
  try {
    _timeUtil[index] = TimerUtil(mInterval: 1, mTotalTime: time);
    _timeUtil[index]!.setOnTimerTickCallback((int value) {
      if (value == 0) {
        _timeUtil[index]!.cancel();
        _timeUtil[index] = null;
        f();
        return;
      }
    });
    _timeUtil[index]!.startCountDown();
  } catch (e) {
    log.error(e, tag: "setTimeout");
    _timeUtil[index]?.cancel();
    _timeUtil[index] = null;
  }
  return _timeUtil[index];
}

clearTimeout(String key) {
  _timeUtil[key]?.cancel();
  _timeUtil.remove(key);
}

TimerUtil? setCountDown({
  Function? onDone,
  Function? onProgress,
  int time = 60,
  String? key,
}) {
  String index = key ?? time.toString();
  if (isNotNull(_timeUtil[index])) {
    _timeUtil[index]?.cancel();
    _timeUtil[index] = null;
  }
  try {
    _timeUtil[index] = TimerUtil(mInterval: 1000, mTotalTime: time * 1000);
    _timeUtil[index]!.setOnTimerTickCallback((int value) {
      if (value == 0) {
        if (isNotNull(onProgress)) onProgress!(0);
        _timeUtil[index]!.cancel();
        _timeUtil[index] = null;
        if (isNotNull(onDone)) onDone!();
        return;
      } else {
        if (isNotNull(onProgress)) onProgress!(value ~/ 1000);
      }
    });
    _timeUtil[index]!.startCountDown();
  } catch (e) {
    log.error(e, tag: "setTimeout");
    _timeUtil[index]?.cancel();
    _timeUtil[index] = null;
  }
  return _timeUtil[index];
}

getData(field, {defValue}) {
  return isNotNull(field) ? field : defValue;
}

void openOverlay(String key, Widget child, {BuildContext? context}) {
  BuildContext? tmpContext = context ?? OuiGlobal.globalContext;
  if (!isNotNull(tmpContext)) throw contextError;

  if (isNotNull(OuiMaterialApp.entrys[key])) {
    OuiMaterialApp.entrys[key]?.remove();
    OuiMaterialApp.entrys[key] = null;
  }
  OuiMaterialApp.entrys[key] = OverlayEntry(builder: (context) {
    return child;
  });

  setTimeout(() => Overlay.of(tmpContext!).insert(OuiMaterialApp.entrys[key]!), time: 100);
}

void closeOverlay(String key) {
  if (isNotNull(OuiMaterialApp.entrys[key])) {
    OuiMaterialApp.entrys[key]?.remove();
    OuiMaterialApp.entrys[key] = null;
  }
}
