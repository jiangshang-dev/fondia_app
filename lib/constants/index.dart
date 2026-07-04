/*
  存储基础地址、超时时间、业务状态、请求地址
 */

class GlobalConstants {
  static const String BASE_URL = 'http://192.168.18.198:9999';
  static const int TIME_OUT = 10;
  static const int SUCCESS_CODE = 200; // 成功
  static const String TOKEN_KEY = "hm_fondia_token"; // token持久化的key
}

class HttpConstants {
  static const String SEND_EMAIL_CODE = '/user/auth/sendEmailCode';
  static const String EMAIL_LOGIN = '/user/auth/emailLogin';
  static const String PASSWORD_LOGIN = '/user/auth/passwordLogin';
  static const String SEND_RESET_PASSWORD_CODE = '/user/auth/sendResetPasswordCode';
  static const String RESET_PASSWORD = '/user/auth/resetPassword';

  // 用户资料
  static const String USER_PROFILE = '/user/profile';
  static const String USER_UPLOAD = '/user/upload';
  static const String USER_INFO = '/user/auth/info';
  static const String USER_FEEDBACK_SUBMIT = '/user/feedback/submit';
  static const String USER_ACCOUNT_DELETE_PREVIEW = '/user/account/deletePreview';
  static const String USER_ACCOUNT_SEND_DELETE_CODE = '/user/account/sendDeleteCode';
  static const String USER_ACCOUNT_DELETE = '/user/account/delete';
  static const String USER_ACCOUNT_CHANGE_PASSWORD = '/user/account/changePassword';

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

  // 在线客服
  static const String SUPPORT_CONFIG = '/support/config';
  static const String SUPPORT_FAQ_LIST = '/support/faq/list';
  static const String SUPPORT_QUICK_ENTRY_LIST = '/support/quick-entry/list';
  static const String SUPPORT_AI_CHAT = '/support/ai/chat';
  static const String SUPPORT_AI_SESSIONS = '/support/ai/sessions';
  static const String SUPPORT_AI_SESSION_NEW = '/support/ai/session/new';
  static const String SUPPORT_AI_SESSION_ACTIVE = '/support/ai/session/active';
  static const String SUPPORT_SESSION_TRANSFER = '/support/session/transfer';
  static const String SUPPORT_SESSION_ACTIVE = '/support/session/active';
  static const String SUPPORT_SESSION_MESSAGES = '/support/session';
  static const String SUPPORT_SESSION_CLOSE = '/support/session';

  // 搜索
  static const String SEARCH_RECIPE = '/search/recipe';

  // 会员 / 积分 / 签到 / 商城
  static const String MEMBER_PLANS = '/member/plans';
  static const String MEMBER_STATUS = '/member/status';
  static const String MEMBER_ORDER_CREATE = '/member/order/create';
  static const String MEMBER_POINTS_SUMMARY = '/member/points/summary';
  static const String MEMBER_POINTS_LEDGER = '/member/points/ledger';
  static const String MEMBER_POINTS_TASKS = '/member/points/tasks';
  static const String MEMBER_CHECKIN_CONFIG = '/member/checkin/config';
  static const String MEMBER_CHECKIN_TODAY = '/member/checkin/today';
  static const String MEMBER_CHECKIN_DO = '/member/checkin/do';
  static const String MEMBER_MALL_PRODUCTS = '/member/mall/products';
  static const String MEMBER_MALL_PRODUCT_DETAIL = '/member/mall/product/detail';
  static const String MEMBER_MALL_REDEEM = '/member/mall/redeem';
  static const String MEMBER_MALL_ORDERS = '/member/mall/orders';
  static const String MEMBER_ADDRESS_LIST = '/member/address/list';
  static const String MEMBER_ADDRESS_SAVE = '/member/address/save';
  static const String MEMBER_ADDRESS_DEFAULT = '/member/address/default';
  static const String MEMBER_ADDRESS_DELETE = '/member/address/delete';
  static const String MEMBER_POINTS_TASK_COMPLETE = '/member/points/task/complete';
  static const String MEMBER_ORDER_PAY_CONFIRM = '/member/order/pay/confirm';
}

