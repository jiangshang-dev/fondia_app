/*
  存储基础地址、超时时间、业务状态、请求地址
 */

class GlobalConstants {
  static const String BASE_URL = 'http://localhost:9999';
  static const int TIME_OUT = 10;
  static const int SUCCESS_CODE = 200; // 成功
  static const String TOKEN_KEY = "hm_fondia_token"; // token持久化的key
}

class HttpConstants {
  static const String SEND_EMAIL_CODE = '/user/auth/sendEmailCode';
  static const String EMAIL_LOGIN = '/user/auth/emailLogin';
  static const String PASSWORD_LOGIN = '/user/auth/login';
}

