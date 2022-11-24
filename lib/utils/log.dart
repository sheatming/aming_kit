import 'package:aming_kit/extension/string.dart';
import 'package:aming_kit/utils/common.dart';
import 'package:flutter/foundation.dart';

final OuiLog log = OuiLog();

enum LogCate {
  info,
  error,
  warn,
  debug,
  http,
  system,
}

class OuiLog {
  static bool _oDebugMode = false;
  static bool get oDebugMode => _oDebugMode;
  void setDebugMode(bool value){
    _oDebugMode = value;
  }

  void info(object, {String? tag, String? type, StackTrace? stackTrace, bool? showTraceList}) => _print(object,
    tag: tag,
    cate: LogCate.info,
    type: type,
    stackTrace: stackTrace,
    showTraceList: showTraceList,
  );
  void error(object, {String? tag, String? type, StackTrace? stackTrace, bool? showTraceList}) => _print(object,
    tag: tag,
    cate: LogCate.error,
    type: type,
    stackTrace: stackTrace,
    showTraceList: showTraceList,
  );
  void warn(object, {String? tag, String? type, StackTrace? stackTrace, bool? showTraceList}) => _print(object,
    tag: tag,
    cate: LogCate.warn,
    type: type,
    stackTrace: stackTrace,
    showTraceList: showTraceList,
  );
  void debug(object, {String? tag, String? type, StackTrace? stackTrace, bool? showTraceList}) => _print(object,
    tag: tag,
    cate: LogCate.debug,
    type: type,
    stackTrace: stackTrace,
    showTraceList: showTraceList,
  );
  void http(object, {String? tag, String? type, StackTrace? stackTrace, bool? showTraceList}) => _print(object,
    tag: tag,
    cate: LogCate.http,
    type: type,
    stackTrace: stackTrace,
    showTraceList: showTraceList,
  );
  void system(object, {String? tag, String? type, StackTrace? stackTrace, bool? showTraceList}) => _print(object,
    tag: tag,
    cate: LogCate.system,
    type: type,
    stackTrace: stackTrace,
    showTraceList: showTraceList,
  );

  static _print(Object? object, {String? tag, required LogCate cate, String? type, StackTrace? stackTrace, bool? showTraceList}){
    // if(!isNotNull(_list["All"])){
    //     _list.addAll({"All": []});
    // }
    var _tag = "";

    switch(cate){
      case LogCate.info:
        _tag = ".*INFO.* ";
        break;
      case LogCate.error:
        _tag = ".*ERROR.* ";
        break;
      case LogCate.warn:
        _tag = ".*WARN.* ";
        break;
      case LogCate.debug:
        _tag = ".*DEBUG.* ";
        break;
      case LogCate.http:
        _tag = ".*HTTP.* ";
        break;
      case LogCate.system:
        _tag = ".*SYSTEM.* ";
        break;
      default:
        break;
    }

    List<String> _st = formatStackTrace(stackTrace ?? StackTrace.current)!;
    // var _stc = _st.last.replaceAll("#${methodCount-1}   ", " ");
    var _stc = _st.first.replaceAll("#0   ", " ");
    if(kDebugMode){
      debugPrint("$_tag=======================================================================");
      debugPrint("$_tag${isNotNull(tag) ? "$tag >>> " : ""}${_stc.removeFirst} ⬇️");

      object = object.toString().replaceAll("\n", "#br#");
      List objArr = object.toString().split("#br#");
      for (var element in objArr) {
        debugPrint("$_tag${element.toString()}");
      }
      if(showTraceList == true){
        for (var element in _st) {
          debugPrint("$_tag${element.toString()}");
        }
      }
      debugPrint("$_tag=======================================================================");
      debugPrint("");
    }

    if((_oDebugMode && cate != LogCate.http) || cate == LogCate.system){
      consoleLog.insert(0, ConsoleLogItem(
        tag: tag,
        content: object.toString().replaceAll("#br#", "\r\n"),
        cate: cate,
        path: _stc.removeFirst,
        stackTrace: StackTrace.current,
      ));
    }
  }
}

List<ConsoleLogItem> consoleLog = [];

class ConsoleLogItem{
  final int date = DateTime.now().millisecondsSinceEpoch;
  final String? tag;
  final String content;
  final String path;
  final LogCate cate;
  final StackTrace? stackTrace;
  ConsoleLogItem({this.tag, required this.content, required this.cate, required this.path, this.stackTrace});
}




final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

List<String>? formatStackTrace(StackTrace stackTrace) {
  var lines = stackTrace.toString().split('\n');
  var formatted = <String>[];
  var count = 0;
  for (var line in lines) {
    var match = stackTraceRegex.matchAsPrefix(line);
    if (match != null) {
      if (match.group(2)!.startsWith('package:aming_kit/utils/log.dart')) {
        continue;
      }
      var newLine = '#$count   ${match.group(1)} (${match.group(2)})';
      formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
      // if (++count == methodCount) {
      //   break;
      // }
    } else {
      formatted.add(line);
    }
  }

  if (formatted.isEmpty) {
    return null;
  } else {
    return formatted;
  }
}

List<NetworkLogItem> networkLog = [];

class NetworkLogItem{
  final int date = DateTime.now().millisecondsSinceEpoch;
  final int statusCode;
  final String statusMessage;
  final String url;
  final String method;
  final dynamic header;
  final dynamic queryHeader;
  final dynamic params;
  final dynamic data;
  final int queryTime;
  NetworkLogItem({required this.statusCode, required this.statusMessage, required this.url, this.params = "-", this.data = "-", required this.method, this.queryTime = 0, this.header, this.queryHeader = "-"});
}