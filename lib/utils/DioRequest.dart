/*
  基于dio二次封装
 */

import 'package:dio/dio.dart';
import 'package:fondia/constants/index.dart';
import 'package:fondia/stores/TokenManager.dart';

class DioRequest {
  final _dio = Dio();

  DioRequest() {
    _dio.options
      ..baseUrl = GlobalConstants.BASE_URL
      // 连接时间
      ..connectTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
      // 超时时间
      ..sendTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
      // 接收时间
      ..receiveTimeout = Duration(seconds: GlobalConstants.TIME_OUT);
    // 添加拦截器
    _addInterceptors();
  }

  // 拦截器
  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          // 注入token request.headers["Authorization"]  Bearer token;
          if (tokenManager.getToken().isNotEmpty) {
            request.headers = {
              "Authorization": "Bearer ${tokenManager.getToken()}",
            };
          }
          handler.next(request);
        },
        onResponse: (response, handler) {
          // 状态码
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            handler.next(response);
            return;
          }
          handler.reject(DioException(requestOptions: response.requestOptions));
        },
        onError: (error, handler) {
          String message = '';
          final data = error.response?.data;
          if (data is Map<String, dynamic>) {
            message = data['msg'] ?? data['error'] ?? data['message'] ?? '';
          }
          if (message.isEmpty) {
            final statusCode = error.response?.statusCode;
            if (statusCode == 503) {
              message = '后端用户服务不可用，请确认 jeecg-user 微服务已启动并注册到 Nacos';
            } else if (statusCode != null) {
              message = '请求失败($statusCode)';
            } else {
              message = error.message ?? '网络请求失败';
            }
          }
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              message: message,
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? params}) {
    return _handleResponse(_dio.get(url, queryParameters: params));
  }

  // 定义post
  Future<dynamic> post(String url, {Map<String, dynamic>? data}) {
    return _handleResponse(_dio.post(url, data: data));
  }

  Future<dynamic> delete(String url) {
    return _handleResponse(_dio.delete(url));
  }

  // 进一步处理返回结果的函数
  Future<dynamic> _handleResponse(Future<Response<dynamic>> task) async {
    try {
      Response<dynamic> result = await task;
      final data = result.data as Map<String, dynamic>;
      if (data["code"] == GlobalConstants.SUCCESS_CODE) {
        // 只要result结果
        return data["result"];
      }
      // 抛出异常
      // throw Exception(data['msg']??'加载数据异常');
      throw DioException(
        requestOptions: result.requestOptions,
        message: data['msg'] ?? '加载数据异常',
      );
    } catch (e) {
      // throw Exception(e);
      // 不改变原来抛出的异常类型
      rethrow;
    }
  }
}

// 单例对象
final dioRequest = DioRequest();

// 请求工具进一步解构，处理http状态和业务状态
// 把所有的接口data解放出来, 拿到真正的数据，要判断业务状态码是不是等于1
