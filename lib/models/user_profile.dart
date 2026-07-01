import 'package:fondia/constants/index.dart';

class UserProfile {
  final String? id;
  final String? username;
  final String? nickname;
  final String? avatar;
  final String? phone;
  final String? email;
  final String? gender;
  final String? birthday;
  final String? province;
  final String? city;
  final String? district;
  final String? sign;
  final int? cookingLevel;
  final String? tastePreference;
  final String? dietaryPreference;
  final bool notifyEnabled;
  final bool activityEnabled;
  final int growthValue;
  final int points;
  final int checkInDays;
  final bool accountProtected;

  UserProfile({
    this.id,
    this.username,
    this.nickname,
    this.avatar,
    this.phone,
    this.email,
    this.gender,
    this.birthday,
    this.province,
    this.city,
    this.district,
    this.sign,
    this.cookingLevel,
    this.tastePreference,
    this.dietaryPreference,
    this.notifyEnabled = true,
    this.activityEnabled = true,
    this.growthValue = 0,
    this.points = 0,
    this.checkInDays = 0,
    this.accountProtected = false,
  });

  String get displayName =>
      (nickname != null && nickname!.isNotEmpty)
          ? nickname!
          : (username ?? '用户');

  String get displaySign =>
      (sign != null && sign!.isNotEmpty)
          ? sign!
          : '爱生活，爱美食，爱分享每一道好菜~';

  String? get avatarUrl {
    if (avatar == null || avatar!.isEmpty || avatar == 'null') return null;
    if (avatar!.startsWith('http://') || avatar!.startsWith('https://')) {
      return avatar;
    }
    final normalized = avatar!.replaceAll('\\', '/').replaceFirst(RegExp(r'^/+'), '');
    return '${GlobalConstants.BASE_URL}/user/common/static/$normalized';
  }

  String get birthdayDisplayText {
    if (birthday == null || birthday!.isEmpty) return '未设置';
    final date = DateTime.tryParse(birthday!);
    if (date == null) return birthday!;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}年$month月$day日';
  }

  String get addressText {
    final parts = [province, city, district]
        .where((e) => e != null && e!.isNotEmpty)
        .map((e) => e!)
        .toList();
    return parts.isEmpty ? '未设置' : parts.join(' ');
  }

  String get genderText {
    switch (gender) {
      case '1':
        return '男';
      case '2':
        return '女';
      default:
        return '未知';
    }
  }

  String get cookLevelText {
    switch (cookingLevel) {
      case 1:
        return 'Lv.1 初学者';
      case 2:
        return 'Lv.2 入门厨友';
      case 3:
        return 'Lv.3 进阶大厨';
      case 4:
        return 'Lv.4 厨艺达人';
      default:
        return 'Lv.${cookingLevel ?? 1} 厨艺达人';
    }
  }

  String get securityText => accountProtected ? '已保护' : '待完善';

  double get growthProgress {
    const max = 1000;
    if (growthValue <= 0) return 0;
    if (growthValue >= max) return 1;
    return growthValue / max;
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString(),
      username: json['username']?.toString(),
      nickname: json['nickname']?.toString(),
      avatar: json['avatar']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      gender: json['gender']?.toString(),
      birthday: _formatBirthday(json['birthday']),
      province: json['province']?.toString(),
      city: json['city']?.toString(),
      district: json['district']?.toString(),
      sign: json['sign']?.toString(),
      cookingLevel: _asInt(json['cookingLevel'], defaultValue: 1),
      tastePreference: json['tastePreference']?.toString(),
      dietaryPreference: json['dietaryPreference']?.toString(),
      notifyEnabled: _asInt(json['notifyEnabled'], defaultValue: 1) == 1,
      activityEnabled: _asInt(json['activityEnabled'], defaultValue: 1) == 1,
      growthValue: _asInt(json['growthValue']),
      points: _asInt(json['points']),
      checkInDays: _asInt(json['checkInDays']),
      accountProtected: json['accountProtected'] == true,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'nickname': nickname,
      'avatar': avatar,
      'gender': gender,
      if (birthday != null && birthday!.isNotEmpty) 'birthday': birthday,
      'province': province,
      'city': city,
      'district': district,
      'sign': sign,
      'cookingLevel': cookingLevel,
      'tastePreference': tastePreference,
      'dietaryPreference': dietaryPreference,
      'notifyEnabled': notifyEnabled ? 1 : 0,
      'activityEnabled': activityEnabled ? 1 : 0,
    };
  }

  UserProfile copyWith({
    String? nickname,
    String? avatar,
    String? gender,
    String? birthday,
    String? province,
    String? city,
    String? district,
    String? sign,
    int? cookingLevel,
    String? tastePreference,
    String? dietaryPreference,
    bool? notifyEnabled,
    bool? activityEnabled,
  }) {
    return UserProfile(
      id: id,
      username: username,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      phone: phone,
      email: email,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      province: province ?? this.province,
      city: city ?? this.city,
      district: district ?? this.district,
      sign: sign ?? this.sign,
      cookingLevel: cookingLevel ?? this.cookingLevel,
      tastePreference: tastePreference ?? this.tastePreference,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      notifyEnabled: notifyEnabled ?? this.notifyEnabled,
      activityEnabled: activityEnabled ?? this.activityEnabled,
      growthValue: growthValue,
      points: points,
      checkInDays: checkInDays,
      accountProtected: accountProtected,
    );
  }
}

String? _formatBirthday(dynamic value) {
  if (value == null) return null;
  final text = value.toString();
  if (text.length >= 10) return text.substring(0, 10);
  return text;
}

int _asInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? defaultValue;
}
