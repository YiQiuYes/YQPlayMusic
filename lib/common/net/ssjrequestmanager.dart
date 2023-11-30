import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yqplaymusic/common/net/myoptions.dart';

import '../utils/crypto.dart';

const String bytesUserAgent =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.76";

class SSJRequestManager {
  static final Dio _dio = Dio();
  PersistCookieJar? _persistCookieJar;

  Future<void> persistCookieJarInit() async {
    Directory tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    _persistCookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(tempPath),
    );
    // 添加拦截器
    _dio.interceptors.add(CookieManager(_persistCookieJar!));
  }

  PersistCookieJar? getPersistCookieJar() {
    return _persistCookieJar;
  }

  Dio getDio() {
    return _dio;
  }

  SSJRequestManager();

  // 获取二进制数据
  Future<Response> getBytes(
    String path, {
    Map<String, dynamic>? queryParameters,
    MyOptions? myOptions,
  }) async {
    myOptions ??= MyOptions(); // 为空则创建
    myOptions.method = "GET";
    myOptions.responseType = ResponseType.bytes; // 设置返回类型为二进制格式
    myOptions.headers = {"User-Agent": bytesUserAgent};

    Response response = await _dio.get(path,
        queryParameters: queryParameters, options: myOptions);
    return response.data;
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters, MyOptions? myOptions}) async {
    myOptions ??= MyOptions(); // 为空则创建
    myOptions.method = "GET";
    myOptions.responseType = ResponseType.json;
    myOptions.headers = {"User-Agent": bytesUserAgent};

    // 处理参数
    Map<String, dynamic> resultParam = await _samePrecess(url,
        queryParameters: queryParameters, myOptions: myOptions);
    queryParameters = resultParam["queryParameters"];
    myOptions = resultParam["myOptions"];

    Response response = await _dio.get(url,
        queryParameters: queryParameters, options: myOptions);
    return response;
  }

  Future<Response> post(String url,
      {Map<String, dynamic>? queryParameters, MyOptions? myOptions}) async {
    myOptions ??= MyOptions(); // 为空则创建
    myOptions.method = "POST";
    myOptions.responseType = ResponseType.json;
    myOptions.headers = {"User-Agent": bytesUserAgent};

    // 处理参数
    Map<String, dynamic> resultParam = await _samePrecess(url,
        queryParameters: queryParameters, myOptions: myOptions);

    queryParameters = resultParam["queryParameters"];
    myOptions = resultParam["myOptions"];

    Response response = await _dio.post(url,
        queryParameters: queryParameters, options: myOptions);
    return response;
  }

  Future<Map<String, dynamic>> _samePrecess(String url,
      {Map<String, dynamic>? queryParameters,
      required MyOptions myOptions}) async {
    // 添加请求头
    if (myOptions.method?.toUpperCase() == "POST") {
      _dio.options.headers["Content-Type"] =
          "application/x-www-form-urlencoded";
    }

    if (url.contains("music.163.com")) {
      _dio.options.headers["Referer"] = "https://music.163.com";
    }

    if (myOptions.reaIP != null) {
      _dio.options.headers['X-Real-IP'] = myOptions.reaIP;
      _dio.options.headers['X-Forwarded-For'] = myOptions.reaIP;
    }

    if (_persistCookieJar == null) {
      await persistCookieJarInit();
    }

    // {
    //   Map<String, dynamic> cookieMap = {};
    //   cookieMap["__remember_me"] = "true";
    //   cookieMap["_ntes_nuid"] = Encrypted.fromSecureRandom(16).base16;
    //
    //   if (!url.contains("login")) {
    //     cookieMap['NMTID'] = Encrypted.fromSecureRandom(16).base16;
    //   }
    //
    //   if (cookieMap["MUSIC_U"] == null) {
    //     // 游客
    //     if (cookieMap["MUSIC_A"] == null) {
    //       cookieMap["MUSIC_A"] = _anonymousToken();
    //     }
    //   }
    //
    //   String cookieParam = "";
    //   cookieMap.forEach((key, value) {
    //     cookieParam =
    //         "$cookieParam${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}; ";
    //   });
    //
    //   _dio.options.headers["Cookie"] = cookieParam;
    // }

    if (myOptions.crypto?.toLowerCase() == "weapi") {
      _dio.options.headers["User-Agent"] =
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.1938.69";
      // RegExp exp = RegExp(r"_csrf=([^(;|$)]+)");
      // String csrfToken = exp
      //         .firstMatch(
      //           jsonEncode(
      //             _dio.options.headers["Cookie"],
      //           ),
      //         )
      //         ?.group(1) ??
      //     "";
      //
      // queryParameters?["csrf_token"] = csrfToken != "" ? csrfToken : "";
      queryParameters =
          jsonDecode(nestedCrypto.weapi(jsonEncode(queryParameters)));
      RegExp exp = RegExp(r"\w*api");
      url = url.replaceAll(exp, "weapi");
    }

    return {
      "url": url,
      "queryParameters": queryParameters,
      "myOptions": myOptions,
    };
  }

  String anonymousToken() {
    return Encrypted.fromSecureRandom(16)
        .bytes
        .map((n) {
          return "abcdefghijklmnopqrstuvwxyz0123456789"[(n % 36)];
        })
        .toList()
        .join();
  }
}

final SSJRequestManager ssjRequestManager = SSJRequestManager();
