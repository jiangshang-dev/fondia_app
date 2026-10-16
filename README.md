<p align="center">
  <a href="https://github.com/jiangshang-dev/fondia_app">
    <img src="https://img.shields.io/badge/Fondia-食养智能菜谱-ff6b35?style=for-the-badge" alt="Fondia App">
  </a>
</p>

<p align="center">
  <a href="https://github.com/jiangshang-dev/fondia_app/stargazers">
    <img src="https://img.shields.io/github/stars/jiangshang-dev/fondia_app?style=social" alt="GitHub Stars">
  </a>
  <a href="https://github.com/jiangshang-dev/fondia">
    <img src="https://img.shields.io/badge/backend-fondia-1890ff.svg" alt="Backend">
  </a>
  <img src="https://img.shields.io/badge/Flutter-3.13+-02569B.svg" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.13+-0175C2.svg" alt="Dart">
</p>

<h1 align="center">Fondia 饭典 App</h1>

<p align="center">
  食养智能菜谱的 Flutter 客户端 · 对接后端
  <a href="https://github.com/jiangshang-dev/fondia">jiangshang-dev/fondia</a>
</p>

---

## 先 Star，再 Clone

这个仓库对 **已经 Star 的人** 开放学习和二次开发。

还没点 Star，请不要 Clone，也不要 Fork 之后只拉代码不回访。

1. 打开 [jiangshang-dev/fondia_app](https://github.com/jiangshang-dev/fondia_app)。
2. 点右上角 **Star**。
3. Star 成功之后，再执行下面的命令。

```bash
git clone https://github.com/jiangshang-dev/fondia_app.git
cd fondia_app
```

后端是独立仓库：[jiangshang-dev/fondia](https://github.com/jiangshang-dev/fondia)。App 只负责界面和接口调用，菜谱、用户、会员、支付和 AI 都在后端。

Star 是这个项目继续维护文档和问题回复的前提。未 Star 就 Clone，视为没有接受本仓库的使用约定。

---

## 这是什么

Fondia（饭典）App 是「菜谱浏览 + AI 厨伴 + 会员积分」的移动端。底部四个页签：首页、分类、AI、我的。登录、菜谱、搜索、收藏评论、在线客服、会员支付都通过 HTTP 访问后端网关。

适合用来学习：

- Flutter 多页面菜谱客户端怎么拆页面、接口和状态
- 如何对接一套 Spring Cloud 网关（用户、菜谱、搜索、互动、客服、会员、支付）
- 邮箱登录、流式 AI 对话、会员配额和积分商城的客户端流程

服务端、管理端和库表不在本仓库。请先按后端文档把服务跑起来，再启动 App。

## 相关仓库

| 仓库 | 地址                                                                            | 内容                      |
|----|-------------------------------------------------------------------------------|-------------------------|
| 后端 | [jiangshang-dev/fondia](https://github.com/jiangshang-dev/fondia)             | JeecgBoot 微服务、网关、管理端、库表 |
| 前端 | [jiangshang-dev/fondia-views](https://github.com/jiangshang-dev/fondia-views) | 管理后台前端 Vue3、TypeScript  |
| App | [jiangshang-dev/fondia_app](https://github.com/jiangshang-dev/fondia_app)     | 本仓库，Flutter 客户端         |

## 功能

| 页签 / 模块 | 说明 |
|-------------|------|
| 首页 | Banner、热门分类、菜谱推荐 |
| 分类 | 菜系与子分类、菜谱列表、图文步骤和视频 |
| 搜索 | 菜谱关键词检索 |
| AI | 厨伴会话、流式回复、历史会话、每日额度 |
| 登录 | 邮箱验证码、密码登录、找回密码 |
| 互动 | 收藏、点赞、评论、浏览记录 |
| 我的 | 资料、头像、改密、反馈、注销账号 |
| 客服 | 常见问题、快捷入口、转人工、页内 AI |
| 会员 | 套餐、下单、支付渠道、支付结果 |
| 积分 | 签到、任务、流水、积分商城、收货地址 |

界面文案支持简体中文和英文。

## 怎么连到后端

```text
Fondia App
    │  Dio  →  GlobalConstants.BASE_URL
    ▼
Gateway :9999          或单体  :8080/jeecg-boot
    │
 user · cuisine · search · interaction · support · member · payment
```

接口前缀和后端网关一致，例如 `/user/**`、`/cuisine/**`、`/search/**`、`/interaction/**`、`/support/**`、`/member/**`、`/payment/**`、`/agent/ai/**`。定义在 `lib/constants/index.dart` 的 `HttpConstants`。

真机或模拟器访问电脑上的服务时，把地址改成电脑的局域网 IP，不要用 `localhost`。

```dart
class GlobalConstants {
  // 微服务网关
  static const String BASE_URL = 'http://192.168.x.x:9999';
  // 单体模式示例：'http://192.168.x.x:8080/jeecg-boot'
}
```

改完后重新运行。支付密钥、邮箱和对象存储只配置在后端，不要写进 App。

## 技术栈

| 层次 | 选型 |
|------|------|
| 框架 | Flutter、Dart（见 `pubspec.yaml` 的 SDK 约束） |
| 网络 | Dio、http、fetch_client |
| 本地 | shared_preferences（登录 token） |
| 媒体 | image_picker、video_player |
| 实时 | web_socket_channel |
| 展示 | flutter_markdown |
| 平台 | Android、iOS、Web、macOS、Linux、Windows |

## 工程结构

```text
fondia_app
├── lib/api            按后端服务拆开的请求
├── lib/pages          首页、分类、AI、我的、登录
├── lib/components     可复用界面
├── lib/models         接口模型
├── lib/stores         本地状态
├── lib/routes         根路由
├── lib/constants      网关地址和接口路径
├── lib/l10n           中英文案
├── lib/utils          Dio 封装
├── android / ios      移动端工程
├── web                Web
└── macos / linux / windows
```

菜谱表的正式脚本在后端仓库 `db/`。本仓库 `db/init_recipe_tables.sql` 只是早期草稿，初始化数据库请用后端文档里的脚本。

## 环境要求

- Flutter 3.13+，Dart 版本满足 `pubspec.yaml`
- Android Studio 或 Xcode（跑真机 / 模拟器时）
- 已启动的 Fondia 后端。网关默认 `http://<局域网IP>:9999`

后端的 JDK、MySQL、Redis、Nacos 见 [后端 README](https://github.com/jiangshang-dev/fondia#readme)。

## 快速开始

确认已经 Star 本仓库，并且后端网关可以访问。

```bash
git clone https://github.com/jiangshang-dev/fondia_app.git
cd fondia_app
flutter pub get
```

编辑 `lib/constants/index.dart` 里的 `BASE_URL`，指向你的网关。

```bash
flutter devices
flutter run
```

指定设备：

```bash
flutter run -d chrome
flutter run -d <deviceId>
```

Android 真机需要允许明文 HTTP（调试地址是 `http://` 时），或改为可访问的 HTTPS。

## 参与贡献

1. 先 Star 本仓库。后端改动请到 [fondia](https://github.com/jiangshang-dev/fondia) 提。
2. Fork 之后从默认分支拉分支，分支名带上改动意图。
3. 提交前说明影响的页面和接口，不要提交本机 IP、token 和密钥。
4. Pull Request 写清动机、验证方式和不兼容变更。

问题请到 [Issues](https://github.com/jiangshang-dev/fondia_app/issues) 提交。接口报错请同时附上后端服务名、网关地址和复现步骤。

## 开源协议

使用、修改和再分发时保留版权与许可声明。服务端协议见后端仓库 [Apache License 2.0](https://github.com/jiangshang-dev/fondia/blob/fondia/LICENSE)。

## 致谢

- [Fondia 后端](https://github.com/jiangshang-dev/fondia)
- [Flutter](https://flutter.dev)

---

如果这份客户端帮到了你，回到仓库点一次 **Star**。还没 Star，就先不要 Clone。
