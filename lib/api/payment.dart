import 'package:fondia/constants/index.dart';
import 'package:fondia/utils/DioRequest.dart';
import 'package:fondia/utils/platform_util.dart';

class PaymentApi {
  static final DioRequest _http = dioRequest;

  static Future<Map<String, dynamic>> getChannels() async {
    final result = await _http.get(
      HttpConstants.PAYMENT_CHANNELS,
      params: {'platform': getClientPlatform()},
    );
    return Map<String, dynamic>.from(result ?? {});
  }

  static Future<Map<String, dynamic>> prepay({
    required String orderNo,
    required String payChannel,
  }) async {
    final result = await _http.post(
      HttpConstants.PAYMENT_PREPAY,
      data: {
        'orderNo': orderNo,
        'payChannel': payChannel,
      },
    );
    return Map<String, dynamic>.from(result ?? {});
  }

  static Future<Map<String, dynamic>> verify({
    required String orderNo,
    required String payChannel,
    String? receipt,
    String? productId,
  }) async {
    final result = await _http.post(
      HttpConstants.PAYMENT_VERIFY,
      data: {
        'orderNo': orderNo,
        'payChannel': payChannel,
        if (receipt != null) 'receipt': receipt,
        if (productId != null) 'productId': productId,
      },
    );
    return Map<String, dynamic>.from(result ?? {});
  }

  static Future<Map<String, dynamic>> getOrderStatus(String orderNo) async {
    final result = await _http.get(
      HttpConstants.PAYMENT_ORDER_STATUS,
      params: {'orderNo': orderNo},
    );
    return Map<String, dynamic>.from(result ?? {});
  }
}
