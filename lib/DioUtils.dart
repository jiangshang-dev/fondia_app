import 'package:dio/dio.dart';

class Dioutils {
  final Dio _dio = Dio();

  Dioutils() {
    // 基本操作
    // 配置基础地址，超时时间
    // _dio.options.baseUrl = "https://api.github.com";
    // 连接超时
    // _dio.options.connectTimeout = Duration(seconds: 15);
    // 发送超时
    // _dio.options.sendTimeout = Duration(seconds: 15);
    // 接收超时
    // _dio.options.receiveTimeout = Duration(seconds: 15);

    // 简写
    _dio.options
      ..baseUrl = "https://geek.itheima.net"
      ..connectTimeout = Duration(seconds: 15)
      ..sendTimeout = Duration(seconds: 15)
      ..receiveTimeout = Duration(seconds: 15);

    // 拦截器
    _addInterceptors();
  }

  // 向外暴露一个get方法
  Future<Response<dynamic>> get(String url, {Map<String, dynamic>? param}) {
    return _dio.get(url, queryParameters: param);
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        // 请求拦截器
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          // handler.next(requestOptions); // 放过请求
          // handler.reject(error) // 拦截请求
          handler.next(options);
        },
        // 响应拦截器
        onResponse: (context, ResponseInterceptorHandler handler) {
          // http状态码  2xx成功 3 4 5
          if (context.statusCode! >= 200 && context.statusCode! < 300) {
            handler.next(context);
            return;
          }
          // 异常
          return handler.reject(DioException(requestOptions: context.requestOptions));
        },
        // 错误拦截器
        onError: (context, ErrorInterceptorHandler handler) {
          handler.reject(context);
        },
      ),
    );
  }
}
