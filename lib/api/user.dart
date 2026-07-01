import 'package:fondia/constants/index.dart';
import 'package:fondia/models/user_profile.dart';
import 'package:fondia/utils/DioRequest.dart';

class UserApi {
  static final DioRequest _http = dioRequest;

  static Future<UserProfile> getProfile() async {
    final result = await _http.get(HttpConstants.USER_PROFILE);
    return UserProfile.fromJson(result as Map<String, dynamic>);
  }

  static Future<UserProfile> updateProfile(UserProfile profile) async {
    final result = await _http.put(
      HttpConstants.USER_PROFILE,
      data: profile.toUpdateJson(),
    );
    return UserProfile.fromJson(result as Map<String, dynamic>);
  }

  static Future<String> uploadAvatar(String filePath) async {
    final result = await _http.uploadFile(
      HttpConstants.USER_UPLOAD,
      filePath,
      biz: 'avatar',
    );
    final map = result as Map<String, dynamic>;
    return map['url']?.toString() ?? map['path']?.toString() ?? '';
  }
}
