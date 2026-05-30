# 架构设计

xxl-job
链路追踪集成skywalking

## 服务拆分

用户与权限服务
jeecg-module-user
登录（微信/支付宝/Google/手机号/密码）、个人信息修改、账号安全、设置（设备管理、注销）

菜谱内容服务
jeecg-module-recipe
首页 Banner、热门菜系、菜谱分类、菜谱详情（视频/图文步骤、食材准备、难度、热量）

互动与社交服务
jeecg-module-interaction
业务域：菜谱收藏、点赞、评论（带层级回复）、用户关注与粉丝、互动消息通知。

AI智能与健康服务
jeecg-module-aihealth
AI 营养咨询（减脂、控糖、高血压等方案定制）、厨房偏好设置（忌口、过敏源）、智能推荐、每日推荐。

通知与消息服务
jeecg-module-notification
系统公告、评论/点赞/关注的Push通知、邮件订阅。

文件与媒体服务 (Media Service)
jeecg-module-media
阿里云视频点播集成（上传、播放、管理视频）

搜索服务
jeecg-module-search
菜谱搜索（根据名称、食材、难度等）、菜谱分类搜索。

# 功能设计

app全局配置功能包括：
- 系统公告管理（发布、删除、编辑）
- 系统设置（如：应用名称、应用图标、应用描述）
- 系统日志管理（查看、导出）
- 系统语言配置（如：中文、英文）

