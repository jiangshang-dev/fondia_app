import 'package:fondia/constants/index.dart';
import 'package:fondia/utils/DioRequest.dart';

/// 登录相关接口
class LoginApi {
  static final DioRequest _http = dioRequest;

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
}
