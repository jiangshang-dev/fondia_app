import 'package:fondia/constants/index.dart';
import 'package:fondia/models/member_models.dart';
import 'package:fondia/utils/DioRequest.dart';
import 'package:fondia/utils/platform_util.dart';

class MemberApi {
  static final DioRequest _http = dioRequest;

  static Future<List<MemberPlan>> getPlans() async {
    final result = await _http.get(
      HttpConstants.MEMBER_PLANS,
      params: {'platform': getMemberPlanPlatform()},
    );
    final list = result as List<dynamic>;
    return list.map((e) => MemberPlan.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<MemberStatus> getMemberStatus() async {
    final result = await _http.get(HttpConstants.MEMBER_STATUS);
    return MemberStatus.fromJson(result as Map<String, dynamic>);
  }

  static Future<MemberOrder> createMemberOrder({
    required String planId,
    required String payChannel,
  }) async {
    final result = await _http.post(
      HttpConstants.MEMBER_ORDER_CREATE,
      params: {
        'planId': planId,
        'payChannel': payChannel,
        'clientPlatform': getClientPlatform(),
      },
    );
    return MemberOrder.fromJson(result as Map<String, dynamic>);
  }

  static Future<PointsAccountSummary> getPointsSummary() async {
    final result = await _http.get(HttpConstants.MEMBER_POINTS_SUMMARY);
    return PointsAccountSummary.fromJson(result as Map<String, dynamic>);
  }

  static Future<PageResult<PointsLedgerItem>> getPointsLedger({
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final result = await _http.get(
      HttpConstants.MEMBER_POINTS_LEDGER,
      params: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    return PageResult.fromJson(
      result as Map<String, dynamic>,
      PointsLedgerItem.fromJson,
    );
  }

  static Future<List<PointsTaskItem>> getPointsTasks() async {
    final result = await _http.get(HttpConstants.MEMBER_POINTS_TASKS);
    final list = result as List<dynamic>;
    return list.map((e) => PointsTaskItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<CheckinConfigItem>> getCheckinConfig() async {
    final result = await _http.get(HttpConstants.MEMBER_CHECKIN_CONFIG);
    final list = result as List<dynamic>;
    return list.map((e) => CheckinConfigItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<CheckinTodayStatus> getCheckinToday() async {
    final result = await _http.get(HttpConstants.MEMBER_CHECKIN_TODAY);
    return CheckinTodayStatus.fromJson(result as Map<String, dynamic>);
  }

  static Future<CheckinResult> doCheckin() async {
    final result = await _http.post(HttpConstants.MEMBER_CHECKIN_DO);
    return CheckinResult.fromJson(result as Map<String, dynamic>);
  }

  static Future<List<MallProduct>> getMallProducts() async {
    final result = await _http.get(HttpConstants.MEMBER_MALL_PRODUCTS);
    final list = result as List<dynamic>;
    return list.map((e) => MallProduct.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<MallProduct> getMallProductDetail(String id) async {
    final result = await _http.get(HttpConstants.MEMBER_MALL_PRODUCT_DETAIL, params: {'id': id});
    return MallProduct.fromJson(result as Map<String, dynamic>);
  }

  static Future<MallRedeemOrder> redeemProduct({
    required String productId,
    int quantity = 1,
    String? addressId,
  }) async {
    final result = await _http.post(
      HttpConstants.MEMBER_MALL_REDEEM,
      params: {
        'productId': productId,
        'quantity': quantity,
        if (addressId != null) 'addressId': addressId,
      },
    );
    return MallRedeemOrder.fromJson(result as Map<String, dynamic>);
  }

  static Future<List<UserAddress>> getAddressList() async {
    final result = await _http.get(HttpConstants.MEMBER_ADDRESS_LIST);
    final list = result as List<dynamic>;
    return list.map((e) => UserAddress.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<UserAddress> saveAddress(UserAddress address) async {
    final result = await _http.post(HttpConstants.MEMBER_ADDRESS_SAVE, data: address.toJson());
    return UserAddress.fromJson(result as Map<String, dynamic>);
  }

  static Future<void> deleteAddress(String id) async {
    await _http.delete(HttpConstants.MEMBER_ADDRESS_DELETE, params: {'id': id});
  }

  static Future<void> setDefaultAddress(String id) async {
    await _http.put('${HttpConstants.MEMBER_ADDRESS_DEFAULT}?id=$id');
  }

  static Future<void> completePointsTask(String taskCode, {String? bizRef}) async {
    await _http.post(
      HttpConstants.MEMBER_POINTS_TASK_COMPLETE,
      params: {
        'taskCode': taskCode,
        if (bizRef != null) 'bizRef': bizRef,
      },
    );
  }

  static Future<MemberOrder> confirmMemberPay(String orderNo) async {
    final result = await _http.post(
      HttpConstants.MEMBER_ORDER_PAY_CONFIRM,
      params: {'orderNo': orderNo},
    );
    return MemberOrder.fromJson(result as Map<String, dynamic>);
  }
}
