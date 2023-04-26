import 'dart:async';

import 'package:aming_kit/aming_kit.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';


class OuiApp{

  static String getTemporaryDir = "";
  static String getAppSupportDir = "";
  static String getAppDocumentDir = "";
  static PackageInfo? packageInfo;

  // static Future<void> init() async {
  //   await OuiCache.init();
  // }

  static Future run({
    required Widget appChild,
    SystemUiOverlayStyle? systemUiOverlayStyle,
    Function<Widget>(String message, Object error)? errorWidgetFn,
  }) async{

      FlutterError.onError = (FlutterErrorDetails details) {
        if(isNotNull(details) && isNotNull(details.stack))Zone.current.handleUncaughtError(details.exception, details.stack as StackTrace);
      };
      ErrorWidget.builder = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, details.stack as StackTrace);
        String message = '';
        assert(() {
          String stringify(Object exception) {
            try {
              return exception.toString();
            } catch (e) {
              // intentionally left empty.
            }
            return 'Error';
          }
          message = '${stringify(details.exception)}\nSee also: https://flutter.dev/docs/testing/errors';
          return true;
        }());
        final Object exception = details.exception;
        if (errorWidgetFn != null) return errorWidgetFn(message, exception);
        return ErrorWidget.withDetails(
            message: message,
            error: exception is FlutterError ? exception : null);
      };

    return runZonedGuarded(() async {
        WidgetsFlutterBinding.ensureInitialized();
        Future.delayed(const Duration(milliseconds: 300), () =>  runApp(appChild));
        if(isNotNull(systemUiOverlayStyle)) SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle!);
      },
      /// zone错误回调函数
      ((error, StackTrace stack) {
        log.error(error.toString().replaceAll("#0   ", " "), stackTrace: stack, showTraceList: true, tag: error.runtimeType.toString());
      }),
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          parent.print(self, line);
        },
      ),
    );
  }

  static Future initAppDir() async{
    getTemporaryDir = await getTemporaryDirectory().then((value) => value.path);
    getAppSupportDir = await getApplicationSupportDirectory().then((value) => value.path);
    getAppDocumentDir = await getApplicationDocumentsDirectory().then((value) => value.path);
    log.system("initialization", tag: "DirInfo");
  }


  static Future initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    log.system("initialization", tag: "PackageInfo");
  }

  static Future setEnv(String env) async{
    OuiCache.setString("oui_env", env);
  }

  static String getEnv() {
    return OuiCache.getString("oui_env", defValue: "");
  }
}

