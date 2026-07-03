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
          if (tokenManager.getToken().isNotEmpty) {
            request.headers['Authorization'] = 'Bearer ${tokenManager.getToken()}';
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

  Future<dynamic> post(String url, {Map<String, dynamic>? data, Map<String, dynamic>? params}) {
    return _handleResponse(_dio.post(url, data: data, queryParameters: params));
  }

  Future<dynamic> put(String url, {Map<String, dynamic>? data}) {
    return _handleResponse(_dio.put(url, data: data));
  }

  Future<dynamic> delete(String url, {Map<String, dynamic>? params}) {
    return _handleResponse(_dio.delete(url, queryParameters: params));
  }

  Future<dynamic> uploadFile(
    String url,
    String filePath, {
    String fieldName = 'file',
    String? biz,
  }) {
    final formData = FormData.fromMap({
      fieldName: MultipartFile.fromFileSync(filePath),
      if (biz != null) 'biz': biz,
    });
    return _handleResponse(_dio.post(url, data: formData));
  }

  // 进一步处理返回结果的函数
  Future<dynamic> _handleResponse(Future<Response<dynamic>> task) async {
    try {
      Response<dynamic> result = await task;
      final data = result.data as Map<String, dynamic>;
      if (data["code"] == GlobalConstants.SUCCESS_CODE) {
        return data["result"];
      }
      throw DioException(
        requestOptions: result.requestOptions,
        message: _extractApiMessage(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  static String _extractApiMessage(Map<String, dynamic> data) {
    final msg = data['msg'] ?? data['message'];
    if (msg != null && msg.toString().isNotEmpty) {
      return msg.toString();
    }
    return '加载数据异常';
  }
}

/// 从 Dio 或业务异常中提取可读错误信息
String dioErrorMessage(Object error, {String fallback = '请求失败'}) {
  if (error is DioException) {
    final message = error.message;
    if (message != null && message.isNotEmpty) {
      return message;
    }
    return fallback;
  }
  final text = error.toString();
  if (text.startsWith('DioException')) {
    final idx = text.indexOf(': ');
    if (idx >= 0 && idx + 2 < text.length) {
      return text.substring(idx + 2);
    }
  }
  return text.replaceFirst('Exception: ', '').replaceFirst('DioException: ', '');
}

// 单例对象
final dioRequest = DioRequest();

// 请求工具进一步解构，处理http状态和业务状态
// 把所有的接口data解放出来, 拿到真正的数据，要判断业务状态码是不是等于1
