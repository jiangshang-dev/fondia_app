import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../constants/index.dart';

class UserInfo {
  final String? id;
  final String? username;
  final String? nickname;
  final String? phone;
  final String? email;
  final String? gender;
  final String? birthday;
  final String? province;
  final String? city;
  final String? district;
  final String? sign;
  final String? cookLevel;

  UserInfo({
    this.id,
    this.username,
    this.nickname,
    this.phone,
    this.email,
    this.gender,
    this.birthday,
    this.province,
    this.city,
    this.district,
    this.sign,
    this.cookLevel,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id']?.toString(),
      username: json['username'],
      nickname: json['nickname'],
      phone: json['phone'],
      email: json['email'],
      gender: json['gender']?.toString(),
      birthday: json['birthday'],
      province: json['province'],
      city: json['city'],
      district: json['district'],
      sign: json['sign'],
      cookLevel: json['cookLevel']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nickname': nickname,
      'phone': phone,
      'email': email,
      'gender': gender,
      'birthday': birthday,
      'province': province,
      'city': city,
      'district': district,
      'sign': sign,
      'cookLevel': cookLevel,
    };
  }
}

class TokenManager {
  static const String USER_INFO_KEY = "hm_fondia_user_info";

  Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  String _token = "";
  Map<String, dynamic>? _userInfoMap;

  Future<void> init() async {
    final prefs = await _getInstance();
    _token = prefs.getString(GlobalConstants.TOKEN_KEY) ?? "";
    final userInfoJson = prefs.getString(USER_INFO_KEY);
    if (userInfoJson != null) {
      _userInfoMap = jsonDecode(userInfoJson);
    }
  }

  Future<void> setToken(String val) async {
    final prefs = await _getInstance();
    prefs.setString(GlobalConstants.TOKEN_KEY, val);
    _token = val;
  }

  String getToken() {
    return _token;
  }

  Future<void> saveUserInfo(Map<String, dynamic> userInfoMap) async {
    final prefs = await _getInstance();
    prefs.setString(USER_INFO_KEY, jsonEncode(userInfoMap));
    _userInfoMap = userInfoMap;
  }

  Map<String, dynamic>? getUserInfo() {
    return _userInfoMap;
  }

  String getNickname() {
    return _userInfoMap?['nickname'] ?? _userInfoMap?['username'] ?? '用户昵称';
  }

  String getSign() {
    return _userInfoMap?['sign'] ?? '爱生活，爱美食，爱分享每一道好菜~';
  }

  Future<void> removeToken() async {
    final prefs = await _getInstance();
    prefs.remove(GlobalConstants.TOKEN_KEY);
    prefs.remove(USER_INFO_KEY);
    _token = "";
    _userInfoMap = null;
  }

  bool isLoggedIn() {
    return _token.isNotEmpty;
  }
}

final tokenManager = TokenManager();
