import 'package:fondia/constants/index.dart';
import 'package:fondia/stores/TokenManager.dart';
import 'package:fondia/utils/DioRequest.dart';

/// 登录相关接口
class LoginApi {
  static final DioRequest _http = dioRequest;

  /// 保存登录结果（邮箱/密码登录统一处理）
  static Future<void> saveLoginResult(dynamic result) async {
    if (result is! Map) return;
    final map = Map<String, dynamic>.from(result);
    await tokenManager.setToken(map['token']?.toString() ?? '');
    final userInfo = map['userInfo'];
    if (userInfo is Map) {
      await tokenManager.saveUserInfo(Map<String, dynamic>.from(userInfo));
    }
  }

  /// 发送邮箱验证码
  static Future<dynamic> sendEmailCode(String email, String scene) async {
    return _http.post(
      HttpConstants.SEND_EMAIL_CODE,
      data: {'email': email, 'scene': scene},
    );
  }

  /// 邮箱验证码登录
  static Future<dynamic> emailLogin(String email, String code) async {
    return _http.post(
      HttpConstants.EMAIL_LOGIN,
      data: {'email': email, 'code': code},
    );
  }

  /// 账号密码登录
  static Future<dynamic> passwordLogin(String account, String password) async {
    return _http.post(
      HttpConstants.PASSWORD_LOGIN,
      data: {'account': account, 'password': password},
    );
  }

  /// 发送重置密码验证码
  static Future<void> sendResetPasswordCode(String account) async {
    await _http.post(
      HttpConstants.SEND_RESET_PASSWORD_CODE,
      data: {'account': account},
    );
  }

  /// 重置密码
  static Future<void> resetPassword({
    required String account,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _http.post(HttpConstants.RESET_PASSWORD, data: {
      'account': account,
      'code': code,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });
  }
}
