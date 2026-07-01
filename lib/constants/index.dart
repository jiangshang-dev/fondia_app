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

  // 用户资料
  static const String USER_PROFILE = '/user/profile';
  static const String USER_UPLOAD = '/user/upload';
  static const String USER_INFO = '/user/auth/info';

  // 菜谱/菜品
  static const String CUISINE_CATEGORY = '/cuisine/category';
  static const String CUISINE_CATEGORY_HOT = '/cuisine/category/hot';
  static const String CUISINE_CATEGORY_LIST = '/cuisine/category/list';
  static const String CUISINE_RECIPE = '/cuisine/recipe';
  static const String CUISINE_RECIPE_LIST = '/cuisine/recipe/list';
  static const String CUISINE_RECIPE_VIDEO_PLAY = '/cuisine/recipe/video/play';
  static const String CUISINE_TAG_LIST = '/cuisine/tag/list';
  static const String CUISINE_BANNER_LIST = '/cuisine/banner/list';

  // 互动/评论
  static const String INTERACTION_COMMENT_TREE = '/interaction/comment/tree';
  static const String INTERACTION_COMMENT_ADD = '/interaction/comment/add';
  static const String INTERACTION_COMMENT_REPLY = '/interaction/comment/reply';
  static const String INTERACTION_COMMENT_REACTION = '/interaction/comment/reaction';
  static const String INTERACTION_COMMENT = '/interaction/comment';

  // 互动/收藏、点赞、浏览
  static const String INTERACTION_COLLECT_MY = '/interaction/collect/my';
  static const String INTERACTION_COLLECT_TOGGLE = '/interaction/collect/toggle';
  static const String INTERACTION_COLLECT_STATUS = '/interaction/collect/status';
  static const String INTERACTION_LIKE_MY = '/interaction/like/my';
  static const String INTERACTION_LIKE_TOGGLE = '/interaction/like/toggle';
  static const String INTERACTION_LIKE_STATUS = '/interaction/like/status';
  static const String INTERACTION_BROWSE_MY = '/interaction/browse/my';
  static const String INTERACTION_BROWSE_RECORD = '/interaction/browse/record';
}

