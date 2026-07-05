import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fondia/api/ai_quota.dart';
import 'package:fondia/pages/Mine/VIP.dart';
import 'package:fondia/utils/DioRequest.dart';

/// AI 专属方案每日次数校验与提示
class AiQuotaHelper {
  static bool isQuotaExceededMessage(String? message) {
    if (message == null || message.isEmpty) return false;
    return message.contains('次数') ||
        message.contains('用完') ||
        message.contains('会员');
  }

  static void showQuotaExceededDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('今日次数已用完'),
        content: Text(
          message.isNotEmpty
              ? message
              : '今日免费次数已用完，开通会员可享更多 AI 问答次数',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('知道了')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VipView()));
            },
            child: const Text('开通会员'),
          ),
        ],
      ),
    );
  }

  /// 扣减一次配额。成功返回最新状态；失败弹窗并返回 null。
  static Future<Map<String, dynamic>?> consumeWithDialog(BuildContext context) async {
    try {
      final status = await AiQuotaApi.consume();
      return status;
    } on DioException catch (e) {
      final msg = e.message ?? '配额校验失败';
      if (isQuotaExceededMessage(msg)) {
        showQuotaExceededDialog(context, msg);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(dioErrorMessage(e, fallback: '配额校验失败'))),
        );
      }
      return null;
    }
  }

  static String formatRemainingHint(Map<String, dynamic>? status) {
    if (status == null) return '';
    final remaining = status['remaining'];
    final dailyLimit = status['dailyLimit'];
    final isMember = status['member'] == true;
    if (remaining == -1 || dailyLimit == -1) return '会员无限次';
    if (remaining is num && dailyLimit is num) {
      final left = remaining.toInt();
      final limit = dailyLimit.toInt();
      if (isMember) return '今日剩余 $left/$limit 次';
      return '今日免费剩余 $left/$limit 次';
    }
    return '';
  }
}
