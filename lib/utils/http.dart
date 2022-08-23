import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:aming_kit/aming_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

// 阿明重构于 2022-04-25

OuiApi api = OuiApi();

class OuiApi {
  static final OuiApi _singleton = OuiApi._internal();

  factory OuiApi() {
    return _singleton;
  }

  OuiApi._internal();

  static late BaseOptions options;
  static String? _baseUrl;
  static String? _uploadUrl;
  static Map<String, dynamic> _header = {};
  static Function? _err401; //未授权登陆

  static void init({
    String? baseUrl,
    Map<String, dynamic> header = const {},
    Function? err401
  }) {

    if (isNotNull(baseUrl)) _baseUrl = baseUrl;
    if (isNotNull(header)) _header = header;
    if (isNotNull(err401)) _err401 = err401;
    log.system("initialization", tag: "Dio");
    options = BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 10000,
      headers: _header,
      baseUrl: _baseUrl!,
    );
  }

  Future<ResponseModel> get(String path, {data, Map<String, dynamic>? header, String? host, bool getFull = false}) async {
    return await _request(
      path,
      method: "GET",
      data: data,
      header: header,
      host: host,
      getFull: getFull,
    );
  }

  Future<ResponseModel> post(String path, {data, Map<String, dynamic>? header, String? host, bool getFull = false}) async {
    return await _request(
      path,
      method: "POST",
      data: data,
      header: header,
      host: host,
      getFull: getFull,
    );
  }

  Future<ResponseModel> put(String path, {data, Map<String, dynamic>? header, String? host, bool getFull = false}) async {
    return await _request(
      path,
      method: "PUT",
      data: data,
      header: header,
      host: host,
      getFull: getFull,
    );
  }

  Future<ResponseModel> delete(String path, {data, Map<String, dynamic>? header, String? host, bool getFull = false}) async {
    return await _request(
      path,
      method: "DELETE",
      data: data,
      header: header,
      host: host,
      getFull: getFull,
    );
  }

  // Future<ResponseModel> upload() async{
  //
  // }

  Future<void> download(String url, String savePath, {
    Function? onProgress,
    Function? onSuccess,
    Function? onFailed,
  }) async{
    String? dir = await getExternalCacheDirectories().then((value) => value?.first.path);
    File file = File("$dir$savePath");
    var dio = Dio();
    try {

      Response response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if(isNotNull(onProgress)) onProgress!(received, total);
        },
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0),
      );
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      if(await file.exists()){
        log.http("保存完成", tag: "Dio:Download");
        if(isNotNull(onSuccess)) onSuccess!(file);
      } else {
        if(isNotNull(onFailed)) onFailed!();
      }
    } catch (e) {
      log.http(e, tag: "Dio:Download");
      if(isNotNull(onFailed)) onFailed!();
    }
  }

  Future<ResponseModel> _request(
    String path, {
    data,
    String method = "POST",
    Map<String, dynamic>? header,
    String? baseUrl,
    String? host,
    bool getFull = false,
  }) async {
    path = path.replaceAll("//", "/");
    BaseOptions _options = options;
    if (isNotNull(header)) {
      header!.forEach((key, value) {
        _header[key] = value;
      });
    }

    if(isNotNull(host)){
      _options.baseUrl = host!;
    } else if(isNotNull(_baseUrl)){
      _options.baseUrl = _baseUrl!;
    }

    _options.method = method;
    _options.headers = _header;

    if (isNotNull(baseUrl)) _options.baseUrl = baseUrl!;
    Dio dio = Dio(_options);

    int _queryTime = DateTime.now().millisecondsSinceEpoch;

    dio.interceptors.add(QueuedInterceptorsWrapper(onRequest: (options, handler) async {
      final Connectivity connectivity = Connectivity();
      var connectionStatus = await connectivity.checkConnectivity();
      if (connectionStatus == ConnectivityResult.none) {
        gotoNoNetWork(handler, options);
        return;
      }
      return handler.next(options);
    }, onError: (error, handler) {

      if (error.error is SocketException) {
        String _log = "🔗 ${error.requestOptions.baseUrl}${error.requestOptions.path}#br#${error.error}#br#📦 ${error.requestOptions.data ?? "-"}#br#📧 ${data ?? "-"}#br#👨 ${error.requestOptions.headers}";
        log.http(_log);
        if(OuiLog.oDebugMode){
          networkLog.insert(0, NetworkLogItem(
            statusCode: 503,
            statusMessage: error.error.toString(),
            url: "${error.requestOptions.baseUrl}${error.requestOptions.path}",
            method: error.requestOptions.method,
            params: error.requestOptions.data,
            data: "-",
            header: error.requestOptions.headers,
            queryTime: DateTime.now().millisecondsSinceEpoch - _queryTime,
          ));
        }

        gotoNoNetWork(handler, error.requestOptions);
        return;
      }
      switch (error.type) {
        case DioErrorType.connectTimeout:
          gotoNoNetWork(handler, error.requestOptions);
          return;
        case DioErrorType.receiveTimeout:
          gotoNoNetWork(handler, error.requestOptions);
          return;
        case DioErrorType.other:
          handler.next(error);
          break;
        default:
          handler.next(error);
          break;
      }
    }, onResponse: (result, handler) {
      int? _status = result.statusCode;
      if (_status == 200) _status = result.data['status'];
      String _log = "🔗 ${result.requestOptions.baseUrl}${result.requestOptions.path}#br#[$_status] - ${result.statusMessage}#br#📦 ${result.requestOptions.data ?? "-"}#br#📧 ${result.data}#br#👨 ${result.requestOptions.headers}";
      log.http(_log);
      if(OuiLog.oDebugMode){
        networkLog.insert(0, NetworkLogItem(
          statusCode: _status ?? 0,
          statusMessage: result.statusMessage ?? '-',
          url: "${result.requestOptions.baseUrl}${result.requestOptions.path}",
          method: result.requestOptions.method,
          params: result.requestOptions.data,
          data: result.data,
          header: result.requestOptions.headers,
          queryHeader: result.headers.map,
          queryTime: DateTime.now().millisecondsSinceEpoch - _queryTime,
        ));
      }


      switch (_status) {
        case 503:
          //通用错误
          log.info(503, tag: "Api");
          // showToast('网络异常,请稍后再试');
          break;
        case 511:
          //封停账号
          log.info(511, tag: "Api");
          break;
        case 422:
          //归类到通用错误 记录日志
          log.info(422, tag: "Api");
          break;
        case 404:
          //无接口 跳过
          handler.next(result);
          return;
        case 401:
          //没登录
          if(isNotNull(_err401)) _err401!();
          return;
        case 200:
          handler.next(result);
          return;
      }
      handler.next(result);
      // handler.reject(DioError(requestOptions: result.requestOptions), true);
    }));

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return;
    };

    if (method == "GET" && isNotNull(data)) {
      path += "?${await getUrlParamsByMap(data)}";
    }
    var result = await dio.request(path, data: data);
    return await _handleResponse(result, getFull);
  }

  Future<ResponseModel> _handleResponse(Response response, bool getFull) async {
    ResponseModel _responseModel = ResponseModel(response.statusMessage, response.statusCode, response.data, response.headers.map);
    switch(response.statusCode){
      case 200:
        var _data = Map<String, dynamic>.from(response.data);
        if(isNotNull(_data) && _data['status'] == 200){
          return ResponseModel(_responseModel.data['message'], _responseModel.data['status'], getFull ? _data : _data['data'], response.headers.map);
        } else {
          return ResponseModel(_responseModel.data['message'], _responseModel.data['status'], _data, response.headers.map);
        }
      default:
        return _responseModel;
    }
  }

  Future<String> getUrlParamsByMap(Map<String, dynamic> params) async {
    List<String> _urlArr = [];
    params.forEach((key, value) {
      _urlArr.add("$key=$value");
    });

    return _urlArr.join("&");
  }

  void gotoNoNetWork(handler, requestOptions) {
    handler.resolve(Response(
      statusMessage: "请求超时",
      statusCode: 503,
      data: {
        "status": 503,
        "message": "请求超时"
      },
        requestOptions: requestOptions,
    ));
    // Future.delayed(Duration(milliseconds: 1000), () {
    //   BuildContext context = Global.navigatorKey.currentState.overlay.context;
    //   if (Global.routerHistory.last != AppRoute.nonetwork.index) {
    //     Future.delayed(Duration.zero, () => Navigator.of(context).pushReplacementNamed(AppRoute.nonetwork.index));
    //   }
    // });
  }
}

class ResponseModel<T> {
  ResponseModel(this.message, this.status, this.data, this.header);

  final T data;
  final String? message;
  final int? status;
  final Map header;
}


class ApiResponse {
  final String? message;
  final dynamic status;
  final dynamic data;
  final Response response;

  ApiResponse(
      this.message,
      this.status,
      this.data,
      this.response,
      );

  factory ApiResponse.fromJson(Response response) {
    return _$ApiResponseFromJson(response);
  }
}


ApiResponse _$ApiResponseFromJson(Response responsen) {
  return ApiResponse(
      responsen.data['message'] as String?,
      responsen.data['status'],
      responsen.data['data'],
      responsen
  );
}