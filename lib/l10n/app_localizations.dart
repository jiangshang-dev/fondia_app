import 'package:flutter/material.dart';

/// 应用固定文案国际化（简体 / 繁体 / 英文）
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const supportedLocales = [
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
    Locale('en', 'US'),
  ];

  String get _lang {
    if (locale.languageCode == 'en') return 'en';
    if (locale.countryCode == 'TW') return 'zh_TW';
    return 'zh_CN';
  }

  String _t(String zhCN, String zhTW, String en) {
    switch (_lang) {
      case 'zh_TW':
        return zhTW;
      case 'en':
        return en;
      default:
        return zhCN;
    }
  }

  // ── 底部导航 ──
  String get tabHome => _t('首页', '首頁', 'Home');
  String get tabCategory => _t('分类', '分類', 'Category');
  String get tabAi => _t('AI助手', 'AI助手', 'AI Assistant');
  String get tabMine => _t('我的', '我的', 'Mine');

  // ── 通用 ──
  String get help => _t('帮助', '幫助', 'Help');
  String get cancel => _t('取消', '取消', 'Cancel');
  String get confirm => _t('确定', '確定', 'Confirm');
  String get tip => _t('提示', '提示', 'Notice');
  String get retry => _t('重试', '重試', 'Retry');
  String get more => _t('更多', '更多', 'More');
  String get loading => _t('加载中...', '載入中...', 'Loading...');
  String get loadFailed => _t('加载失败', '載入失敗', 'Load failed');
  String get sendFailed => _t('发送失败', '發送失敗', 'Send failed');
  String get noData => _t('暂无数据', '暫無資料', 'No data');
  String get needLogin => _t('请先登录后再操作', '請先登入後再操作', 'Please log in first');
  String get needLoginFeedback => _t('提交反馈需要先登录', '提交回饋需要先登入', 'Please log in to submit feedback');
  String get goLogin => _t('去登录', '去登入', 'Log in');
  String get all => _t('全部', '全部', 'All');

  // ── 语言设置 ──
  String get languageSettings => _t('语言设置', '語言設定', 'Language Settings');

  // ── 设置页 ──
  String get settings => _t('设置', '設定', 'Settings');
  String get accountSecurity => _t('账号与安全', '帳號與安全', 'Account & Security');
  String get changePassword => _t('修改密码', '修改密碼', 'Change Password');
  String get deleteAccount => _t('注销账号', '註銷帳號', 'Delete Account');
  String get generalSettings => _t('通用设置', '通用設定', 'General');
  String get darkMode => _t('深色模式', '深色模式', 'Dark Mode');
  String get fontSize => _t('字体大小', '字體大小', 'Font Size');
  String get medium => _t('中', '中', 'Medium');
  String get clearCache => _t('清除缓存', '清除快取', 'Clear Cache');
  String get downloadManagement => _t('下载管理', '下載管理', 'Downloads');
  String get messageNotification => _t('消息通知', '訊息通知', 'Notifications');
  String get kitchenPreferences => _t('厨房偏好设置', '廚房偏好設定', 'Kitchen Preferences');
  String get smartRecommend => _t('智能推荐偏好', '智能推薦偏好', 'Smart Recommendations');
  String get dietaryRestrictions => _t('忌口设置', '忌口設定', 'Dietary Restrictions');
  String get dietGoal => _t('饮食目标设置', '飲食目標設定', 'Diet Goal');
  String get healthyDiet => _t('健康饮食', '健康飲食', 'Healthy Diet');
  String get allergyReminder => _t('食材过敏提醒', '食材過敏提醒', 'Allergy Alerts');
  String get recipeDifficulty => _t('食谱难度偏好', '食譜難度偏好', 'Recipe Difficulty');
  String get difficultyMedium => _t('中等', '中等', 'Medium');
  String get dailyRecommendTime => _t('每日推荐时间', '每日推薦時間', 'Daily Recommend Time');
  String get morning7 => _t('上午 7:00', '上午 7:00', '7:00 AM');
  String get aboutUs => _t('关于我们', '關於我們', 'About Us');
  String get userAgreement => _t('用户协议', '用戶協議', 'Terms of Service');
  String get privacyPolicy => _t('隐私政策', '隱私政策', 'Privacy Policy');
  String get aboutFondia => _t('关于饭典', '關於飯典', 'About Fondia');
  String get rateUs => _t('给我们评分', '給我們評分', 'Rate Us');
  String get logout => _t('退出登录', '退出登入', 'Log Out');
  String get notificationSettings => _t('通知设置', '通知設定', 'Notification Settings');

  // ── 我的页 ──
  String get myContent => _t('我的内容', '我的內容', 'My Content');
  String get clickToLogin => _t('点击登录', '點擊登入', 'Tap to Log In');
  String get loginForMore => _t('登录后享受更多功能', '登入後享受更多功能', 'Log in for more features');
  String consecutiveCheckIn(int days) => _t('连续签到 $days 天', '連續簽到 $days 天', '$days-day check-in streak');
  String growthValue(int current, int total) =>
      _t('成长值 $current/$total', '成長值 $current/$total', 'Growth $current/$total');
  String get myPoints => _t('我的积分', '我的積分', 'My Points');
  String pointsCount(int count) => _t('$count 积分', '$count 積分', '$count pts');
  String get pointsDetail => _t('积分明细 >', '積分明細 >', 'Points >');
  String get earnPoints => _t('去赚积分', '去賺積分', 'Earn Points');
  String get dailyCheckIn => _t('每日签到', '每日簽到', 'Daily Check-in');
  String get pointsMall => _t('积分商城', '積分商城', 'Points Mall');
  String get vipCenter => _t('会员中心', '會員中心', 'VIP Center');
  String get myCollection => _t('我的收藏', '我的收藏', 'My Favorites');
  String get myLikes => _t('我的点赞', '我的點讚', 'My Likes');
  String get myComments => _t('我的评论', '我的評論', 'My Comments');
  String get browseHistory => _t('浏览记录', '瀏覽記錄', 'History');
  String get onlineService => _t('在线客服', '線上客服', 'Support');
  String get feedback => _t('意见反馈', '意見回饋', 'Feedback');

  // ── 首页 ──
  String get hotCuisines => _t('热门菜系', '熱門菜系', 'Popular Cuisines');
  String get noHotCuisines => _t('暂无热门菜系', '暫無熱門菜系', 'No popular cuisines');
  String get cuisineCategory => _t('菜系分类', '菜系分類', 'Cuisine Categories');
  String get todayRecommend => _t('今日推荐', '今日推薦', "Today's Picks");
  String get refresh => _t('换一换', '換一換', 'Refresh');

  // ── 分类 ──
  String get noCuisineData => _t('暂无菜系数据', '暫無菜系資料', 'No cuisine data');
  String get dishes => _t('菜品', '菜品', 'Dishes');
  String get staples => _t('主食', '主食', 'Staples');
  String get dishCatalog => _t('菜品目录', '菜品目錄', 'Dish Catalog');
  String get loadMore => _t('上拉加载更多', '上拉載入更多', 'Pull up to load more');
  String get noMore => _t('没有更多了', '沒有更多了', 'No more items');
  String get collect => _t('收藏', '收藏', 'Save');
  String get collected => _t('已收藏', '已收藏', 'Saved');
  String get collectSuccess => _t('收藏成功', '收藏成功', 'Saved successfully');
  String get cookTime => _t('烹饪时间', '烹飪時間', 'Cook Time');
  String minutes(int m) => _t('$m分钟', '$m分鐘', '$m min');

  // ── 登录 ──
  String get helpCenter => _t('帮助中心', '幫助中心', 'Help Center');
  String get welcomeTo => _t('欢迎来到', '歡迎來到', 'Welcome to');
  String get recipes => _t('菜谱', '菜譜', 'Recipes');
  String get loginSlogan => _t('让做饭更简单，爱生活，爱美食', '讓做飯更簡單，愛生活，愛美食', 'Cook easier. Love life. Love food.');
  String get quickLogin => _t('快捷登录', '快捷登入', 'Quick Login');
  String get loginWithGoogle => _t('使用 Google 账号登录', '使用 Google 帳號登入', 'Continue with Google');
  String get loginWithApple => _t('使用Apple账号登录', '使用Apple帳號登入', 'Continue with Apple');
  String get loginWithAlipay => _t('使用支付宝登录', '使用支付寶登入', 'Continue with Alipay');
  String get loginWithPhone => _t('使用手机号登录', '使用手機號登入', 'Continue with Phone');
  String get otherLogin => _t('其他方式登录', '其他方式登入', 'Other Login Methods');
  String get emailLogin => _t('邮箱登录', '郵箱登入', 'Email Login');
  String get passwordLogin => _t('密码登录', '密碼登入', 'Password Login');

  // ── 意见反馈 ──
  String get feedbackTitle => _t('意见反馈', '意見回饋', 'Feedback');
  String get feedbackType => _t('反馈类型', '回饋類型', 'Feedback Type');
  String get feedbackContent => _t('反馈内容', '回饋內容', 'Feedback Content');
  String get contactOptional => _t('联系方式（选填）', '聯絡方式（選填）', 'Contact (optional)');
  String get feedbackHint =>
      _t('请详细描述您遇到的问题或提出的建议，小厨会认真阅读并不断优化体验～', '請詳細描述您遇到的問題或提出的建議，小廚會認真閱讀並不斷優化體驗～',
          'Please describe your issue or suggestion in detail.');
  String get uploadImagesHint => _t('最多可上传 3 张截图或图片（选填）', '最多可上傳 3 張截圖或圖片（選填）', 'Up to 3 screenshots (optional)');
  String get uploadImage => _t('传图片', '傳圖片', 'Add Image');
  String get contactHint => _t('手机号 / 邮箱 / QQ（方便我们与您联系）', '手機號 / 郵箱 / QQ（方便我們與您聯繫）', 'Phone / Email / QQ');
  String get submitFeedback => _t('提交反馈', '提交回饋', 'Submit Feedback');
  String get fillFeedbackContent => _t('请填写反馈内容', '請填寫回饋內容', 'Please enter feedback content');
  String get thankYouFeedback =>
      _t('感谢您的反馈，我们会尽快处理！', '感謝您的回饋，我們會盡快處理！', 'Thank you! We will review it soon.');
  String get pickFromGallery => _t('从相册选择', '從相簿選擇', 'Choose from Gallery');
  String get takePhoto => _t('拍照上传', '拍照上傳', 'Take Photo');
  String get feedbackTypeFeature => _t('功能建议', '功能建議', 'Feature Suggestion');
  String get feedbackTypePerformance => _t('性能问题', '性能問題', 'Performance Issue');
  String get feedbackTypeContent => _t('内容报错', '內容報錯', 'Content Error');
  String get feedbackTypePoints => _t('积分/签到', '積分/簽到', 'Points / Check-in');
  String get feedbackTypeOther => _t('其他问题', '其他問題', 'Other');

  List<String> get feedbackTypes => [
        feedbackTypeFeature,
        feedbackTypePerformance,
        feedbackTypeContent,
        feedbackTypePoints,
        feedbackTypeOther,
      ];

  // ── 在线客服 ──
  String get humanService => _t('人工客服', '人工客服', 'Live Agent');
  String get aiSelfService => _t('智能自助', '智能自助', 'AI Self-Service');
  String get transferToHuman => _t('转人工', '轉人工', 'Talk to Agent');
  String get customerOnline => _t('客服在线中', '客服在線中', 'Agent Online');
  String get describeProblem => _t('描述您遇到的问题...', '描述您遇到的問題...', 'Describe your issue...');
  String get askAiQuestion =>
      _t('请输入您的问题，AI将基于知识库为您解答...', '請輸入您的問題，AI將基於知識庫為您解答...', 'Ask a question — AI will answer from our knowledge base.');
  String get faqSelfService => _t('常见问题自助', '常見問題自助', 'FAQ Self-Service');
  String get summonHuman => _t('召唤人工客服', '召喚人工客服', 'Talk to Live Agent');
  String get welcomeTag => _t('智能自助', '智能自助', 'AI Self-Service');
  String get welcomeDesc => _t('我是小厨专属客服，有什么可以帮您的？', '我是小廚專屬客服，有什麼可以幫您的？', 'Hi! How can I help you today?');
  String get privacyTipDefault =>
      _t('小厨致力保护您的隐私，本次通话已加密。', '小廚致力保護您的隱私，本次通話已加密。', 'Your privacy is protected. This chat is encrypted.');
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    if (locale.languageCode == 'en') return true;
    if (locale.languageCode == 'zh') {
      return locale.countryCode == 'CN' || locale.countryCode == 'TW' || locale.countryCode == null;
    }
    return false;
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    Locale resolved = locale;
    if (locale.languageCode == 'zh' && locale.countryCode == null) {
      resolved = const Locale('zh', 'CN');
    }
    return AppLocalizations(resolved);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
