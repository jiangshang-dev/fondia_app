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
    return _uploadFile(filePath, biz: 'avatar');
  }

  static Future<String> uploadFeedbackImage(String filePath) async {
    return _uploadFile(filePath, biz: 'feedback');
  }

  static Future<void> submitFeedback({
    required String feedbackType,
    required String content,
    String? contact,
    List<String>? images,
  }) async {
    await _http.post(HttpConstants.USER_FEEDBACK_SUBMIT, data: {
      'feedbackType': feedbackType,
      'content': content,
      if (contact != null && contact.trim().isNotEmpty) 'contact': contact.trim(),
      'images': images ?? [],
    });
  }

  static Future<String> _uploadFile(String filePath, {required String biz}) async {
    final result = await _http.uploadFile(
      HttpConstants.USER_UPLOAD,
      filePath,
      biz: biz,
    );
    final map = result as Map<String, dynamic>;
    return map['url']?.toString() ?? map['path']?.toString() ?? '';
  }
}
