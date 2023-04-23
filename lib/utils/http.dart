import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:aming_kit/aming_kit.dart';

export 'package:dio/dio.dart';
// 阿明重构于 2022-04-25

OuiApi api = OuiApi();

class OuiApi {
  static final OuiApi _singleton = OuiApi._internal();

  factory OuiApi() {
    return _singleton;
  }

  OuiApi._internal();

  static BaseOptions? options;
  static String? _baseUrl;
  static Map<String, dynamic> _header = {};
  static Function? _err401; //未授权登陆
  static Function? _resultHandle;
  static bool _loading = false;

  static void init({
    String? baseUrl,
    Map<String, dynamic> header = const {},
    Function? err401,
    bool? loading,
    Function(Response response)? resultHandle
  }) {

    if (isNotNull(baseUrl)) _baseUrl = baseUrl;
    if (isNotNull(header)) _header = header;
    if (isNotNull(err401)) _err401 = err401;
    if (isNotNull(resultHandle)) _resultHandle = resultHandle;
    if (isNotNull(loading)) _loading = loading!;
    log.system("initialization", tag: "Dio");
    options = BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 10000,
      headers: _header,
      baseUrl: _baseUrl!,
    );
  }

  Future<ResponseModel> get(String path, {data, Map<String, dynamic>? header, String? baseUrl, bool? skipResultHandle}) async => await _request(
    path,
    method: "GET",
    data: data,
    header: header,
    baseUrl: baseUrl,
    skipResultHandle: skipResultHandle ?? false,
  );

  Future<ResponseModel> post(String path, {data, Map<String, dynamic>? header, String? baseUrl, bool? skipResultHandle}) async => await _request(
    path,
    method: "POST",
    data: data,
    header: header,
    baseUrl: baseUrl,
    skipResultHandle: skipResultHandle ?? false,
  );

  Future<ResponseModel> put(String path, {data, Map<String, dynamic>? header, String? baseUrl, bool? skipResultHandle}) async => await _request(
    path,
    method: "PUT",
    data: data,
    header: header,
    baseUrl: baseUrl,
    skipResultHandle: skipResultHandle ?? false,
  );

  Future<ResponseModel> delete(String path, {data, Map<String, dynamic>? header, String? baseUrl, bool? skipResultHandle}) async => await _request(
    path,
    method: "DELETE",
    data: data,
    header: header,
    baseUrl: baseUrl,
    skipResultHandle: skipResultHandle ?? false,
  );

  // Future<ResponseModel> upload() async{
  //
  // }

  Future<void> download(String url, String savePath, {
    ProgressCallback? onProgress,
    Function? onSuccess,
    Function? onFailed,
  }) async{
    int queryTime = DateTime.now().millisecondsSinceEpoch;
    if(!isNotNull(OuiApp.getTemporaryDir)) await OuiApp.initAppDir();
    String? dir = OuiApp.getTemporaryDir;
    File file = File("$dir/$savePath");
    var dio = Dio();
    try {
      log.debug(file.path, tag: "下载路径");

      if(_loading) showLoading();
      Response response = await dio.download(
        url,
        file.path,
        onReceiveProgress: onProgress,
      );
      if(_loading) closeToast();

      _pushLog(
        requestOptions: response.requestOptions,
        queryTime: queryTime,
        result: response,
        code: response.statusCode,
      );
      if(response.statusCode == 200){
        if(isNotNull(onSuccess)) onSuccess!(file);
      } else {
        if(isNotNull(onFailed)) onFailed!();
      }
    } catch (e) {
      log.error(e, tag: "Dio:Download");
      if(isNotNull(onFailed)) onFailed!();
    }
  }

  Future<ResponseModel> _request(
      String path, {
        data,
        String method = "GET",
        Map<String, dynamic>? header = const {},
        String? baseUrl,
        bool skipResultHandle = false,
      }) async {

    path = path.replaceAll("//", "/");
    BaseOptions tmpOptions = options ?? BaseOptions();
    Map<String, dynamic> h = {};
    if (isNotNull(_header)) h.addAll(_header);
    if (isNotNull(header)) h.addAll(header!);

    tmpOptions.method = method;
    tmpOptions.headers = h;
    if (isNotNull(_baseUrl)) tmpOptions.baseUrl = _baseUrl!;
    if (isNotNull(baseUrl)) tmpOptions.baseUrl = baseUrl!;

    ///避免双斜杠问题
    if(path.first == '/' && tmpOptions.baseUrl.last == '/') path = path.removeFirst;
    if(path.first != '/' && tmpOptions.baseUrl.last != '/') path = "/$path";

    tmpOptions.connectTimeout = 30000;
    Dio dio = Dio(tmpOptions);

    int queryTime = DateTime.now().millisecondsSinceEpoch;

    dio.interceptors.add(QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final Connectivity connectivity = Connectivity();
          var connectionStatus = await connectivity.checkConnectivity();
          if (connectionStatus == ConnectivityResult.none) {
            gotoNoNetWork(handler, options);
            return;
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.error is SocketException) {
            _pushLog(
              queryTime: queryTime,
              requestOptions: error.requestOptions,
              error: error,
              code: 503,
            );
            gotoNoNetWork(handler, error.requestOptions);
            return;
          }
          switch (error.type) {
            case DioErrorType.connectTimeout:
              _pushLog(
                queryTime: queryTime,
                requestOptions: error.requestOptions,
                error: error,
                code: 503,
              );
              gotoNoNetWork(handler, error.requestOptions);
              return;
            case DioErrorType.receiveTimeout:
              _pushLog(
                queryTime: queryTime,
                requestOptions: error.requestOptions,
                error: error,
                code: 503,
              );
              gotoNoNetWork(handler, error.requestOptions);
              return;
            default:
              _pushLog(
                queryTime: queryTime,
                requestOptions: error.requestOptions,
                error: error,
                code: 999,
              );
              handler.next(error);
              break;
          }
        },
        onResponse: (result, handler) {
          int? status = result.statusCode;
          if (status == 200) status = result.data['status'] ?? 0;

          switch (status) {
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
            case 403:
            //403 跳过
              log.info(403, tag: "Api");
              break;
            case 401:
            //没登录
              if(isNotNull(_err401)) _err401!();
              return;
            case 200:
              handler.next(result);
              return;
          }
          handler.next(result);
        }));

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return;
    };
    if (method == "GET" && isNotNull(data)) {
      path += "?${Map.from(data).toUrl}";
    }
    try{
      if(_loading) showLoading();
      var result = await dio.request(path, data: data);
      if(_loading) closeToast();
      _pushLog(
        queryTime: queryTime,
        requestOptions: result.requestOptions,
        result: result,
        code: result.statusCode.toString().toInt,
      );
      return await _handleResponse(result, skipResultHandle: skipResultHandle);
    } on DioError catch (e){

      Response response = Response(
        statusCode: e.response?.statusCode,
        requestOptions: e.requestOptions,
        statusMessage: e.response?.statusMessage,
        headers: e.response?.headers,
        data: e.response?.data,
      );

      _pushLog(
        queryTime: queryTime,
        requestOptions: response.requestOptions,
        result: response,
        code: response.statusCode,
      );
      return await _handleResponse(response, skipResultHandle: true);
    }

  }
  Future<ResponseModel> _handleResponse(Response response, {bool skipResultHandle = false}) async {
    ResponseModel responseModel = ResponseModel(response.statusMessage, response.statusCode, response.data, response.headers.map);
    if(skipResultHandle == true) return responseModel;
    if(isNotNull(_resultHandle)) {
      var res = _resultHandle!(response);
      if(isNotNull(res)){
        return res;
      } else {
        return responseModel;
      }
    } else {
      return responseModel;
    }
  }

  Future<String> getUrlParamsByMap(Map<String, dynamic> params) async {
    List<String> urlArr = [];
    params.forEach((key, value) {
      urlArr.add("$key=$value");
    });

    return urlArr.join("&");
  }

  void gotoNoNetWork(handler, requestOptions) => handler.resolve(Response(
    statusMessage: "请求超时",
    statusCode: 503,
    requestOptions: requestOptions,
  ));

  void headerAdd(Map<String, dynamic> header) => _header.addAll(header);
  void headerRemove(String key) => _header.remove(key);
}

class ResponseModel<T> {
  ResponseModel(this.message, this.status, this.data, this.header);

  final T? data;
  final String? message;
  final int? status;
  final Map header;
}


// class ApiResponse {
//   final String? message;
//   final dynamic status;
//   final dynamic data;
//   final Response response;
//
//   ApiResponse(
//       this.message,
//       this.status,
//       this.data,
//       this.response,
//       );
//
//   factory ApiResponse.fromJson(Response response) {
//     return _$ApiResponseFromJson(response);
//   }
// }
//
//
// ApiResponse _$ApiResponseFromJson(Response responsen) {
//   return ApiResponse(
//       responsen.data['message'] as String?,
//       responsen.data['status'],
//       responsen.data['data'],
//       responsen
//   );
// }

void _pushLog({
  int queryTime = 0,
  required RequestOptions requestOptions,
  DioError? error,
  Response? result,
  int? code = 0,
}){


  int? status = code ?? result?.statusCode ?? 500;
  String tmpLog = "🔗 ${requestOptions.method}: "
      "${requestOptions.baseUrl}${requestOptions.path}#br#";
  if(isNotNull(result)) tmpLog += "[$status] - ${result?.statusMessage ?? "-"}#br#";
  if(isNotNull(error)) tmpLog += "[$status] - ${error?.error ?? "-"}#br#";

  tmpLog += "⌚️ ${DateTime.now().millisecondsSinceEpoch - queryTime}ms#br#";
  tmpLog += "📦 ${requestOptions.data ?? "-"}#br#";
  tmpLog += "📧 ${result?.data ?? '-'}#br#";
  tmpLog += "👨 ${requestOptions.headers}";

  log.http(tmpLog);
  if(OuiLog.oDebugMode){
    networkLog.insert(0, NetworkLogItem(
      statusCode: status,
      statusMessage: isNotNull(error) ? "${error?.error ?? "-"}" : (result?.statusMessage ?? '-'),
      url: "${requestOptions.baseUrl}${requestOptions.path}",
      method: requestOptions.method,
      header: requestOptions.headers,
      params: requestOptions.data,
      data: result?.data ?? "-",
      queryHeader: result?.headers.map ?? "-",
      queryTime: DateTime.now().millisecondsSinceEpoch - queryTime,
    ));
  }
}