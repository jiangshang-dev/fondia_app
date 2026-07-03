class MemberPlan {
  final String id;
  final String planCode;
  final String name;
  final String? subtitle;
  final int durationDays;
  final double price;
  final double? originalPrice;
  final String currency;
  final String platformScope;
  final int bonusPoints;
  final int bonusGrowth;

  MemberPlan({
    required this.id,
    required this.planCode,
    required this.name,
    this.subtitle,
    required this.durationDays,
    required this.price,
    this.originalPrice,
    this.currency = 'CNY',
    this.platformScope = 'ALL',
    this.bonusPoints = 0,
    this.bonusGrowth = 0,
  });

  factory MemberPlan.fromJson(Map<String, dynamic> json) {
    return MemberPlan(
      id: json['id']?.toString() ?? '',
      planCode: json['planCode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      durationDays: _asInt(json['durationDays']),
      price: _asDouble(json['price']),
      originalPrice: json['originalPrice'] != null ? _asDouble(json['originalPrice']) : null,
      currency: json['currency']?.toString() ?? 'CNY',
      platformScope: json['platformScope']?.toString() ?? 'ALL',
      bonusPoints: _asInt(json['bonusPoints']),
      bonusGrowth: _asInt(json['bonusGrowth']),
    );
  }
}

class MemberStatus {
  final bool isMember;
  final MemberSubscription? subscription;

  MemberStatus({required this.isMember, this.subscription});

  factory MemberStatus.fromJson(Map<String, dynamic> json) {
    return MemberStatus(
      isMember: json['isMember'] == true,
      subscription: json['subscription'] != null
          ? MemberSubscription.fromJson(json['subscription'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MemberSubscription {
  final String id;
  final String planCode;
  final int status;
  final int expireTime;

  MemberSubscription({
    required this.id,
    required this.planCode,
    required this.status,
    required this.expireTime,
  });

  factory MemberSubscription.fromJson(Map<String, dynamic> json) {
    return MemberSubscription(
      id: json['id']?.toString() ?? '',
      planCode: json['planCode']?.toString() ?? '',
      status: _asInt(json['status']),
      expireTime: _asInt(json['expireTime']),
    );
  }

  DateTime? get expireDate {
    if (expireTime <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(expireTime);
  }
}

class PointsAccountSummary {
  final int balance;
  final int frozen;
  final int totalEarned;
  final int totalSpent;

  PointsAccountSummary({
    this.balance = 0,
    this.frozen = 0,
    this.totalEarned = 0,
    this.totalSpent = 0,
  });

  factory PointsAccountSummary.fromJson(Map<String, dynamic> json) {
    return PointsAccountSummary(
      balance: _asInt(json['balance']),
      frozen: _asInt(json['frozen']),
      totalEarned: _asInt(json['totalEarned']),
      totalSpent: _asInt(json['totalSpent']),
    );
  }
}

class PointsLedgerItem {
  final String id;
  final int changeAmount;
  final int balanceAfter;
  final String bizType;
  final String? title;
  final int createTime;

  PointsLedgerItem({
    required this.id,
    required this.changeAmount,
    required this.balanceAfter,
    required this.bizType,
    this.title,
    required this.createTime,
  });

  factory PointsLedgerItem.fromJson(Map<String, dynamic> json) {
    return PointsLedgerItem(
      id: json['id']?.toString() ?? '',
      changeAmount: _asInt(json['changeAmount']),
      balanceAfter: _asInt(json['balanceAfter']),
      bizType: json['bizType']?.toString() ?? '',
      title: json['title']?.toString(),
      createTime: _asInt(json['createTime']),
    );
  }
}

class PointsTaskItem {
  final String id;
  final String taskCode;
  final String title;
  final String? description;
  final int rewardPoints;
  final String actionType;

  PointsTaskItem({
    required this.id,
    required this.taskCode,
    required this.title,
    this.description,
    required this.rewardPoints,
    required this.actionType,
  });

  factory PointsTaskItem.fromJson(Map<String, dynamic> json) {
    return PointsTaskItem(
      id: json['id']?.toString() ?? '',
      taskCode: json['taskCode']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      rewardPoints: _asInt(json['rewardPoints']),
      actionType: json['actionType']?.toString() ?? 'MANUAL',
    );
  }
}

class CheckinConfigItem {
  final int dayIndex;
  final int rewardPoints;
  final int rewardGrowth;

  CheckinConfigItem({
    required this.dayIndex,
    required this.rewardPoints,
    required this.rewardGrowth,
  });

  factory CheckinConfigItem.fromJson(Map<String, dynamic> json) {
    return CheckinConfigItem(
      dayIndex: _asInt(json['dayIndex']),
      rewardPoints: _asInt(json['rewardPoints']),
      rewardGrowth: _asInt(json['rewardGrowth']),
    );
  }
}

class CheckinTodayStatus {
  final bool checkedIn;

  CheckinTodayStatus({required this.checkedIn});

  factory CheckinTodayStatus.fromJson(Map<String, dynamic> json) {
    return CheckinTodayStatus(checkedIn: json['checkedIn'] == true);
  }
}

class CheckinResult {
  final int rewardPoints;
  final int rewardGrowth;
  final int streakDays;
  final int balanceAfter;

  CheckinResult({
    required this.rewardPoints,
    required this.rewardGrowth,
    required this.streakDays,
    required this.balanceAfter,
  });

  factory CheckinResult.fromJson(Map<String, dynamic> json) {
    return CheckinResult(
      rewardPoints: _asInt(json['rewardPoints']),
      rewardGrowth: _asInt(json['rewardGrowth']),
      streakDays: _asInt(json['streakDays']),
      balanceAfter: _asInt(json['balanceAfter']),
    );
  }
}

class MallProduct {
  final String id;
  final String productCode;
  final String name;
  final String? subtitle;
  final String? coverImage;
  final String productType;
  final int pointsPrice;
  final int stock;
  final String? virtualConfigJson;

  bool get isPhysical => productType.toUpperCase() == 'PHYSICAL';
  bool get isVirtual => !isPhysical;

  MallProduct({
    required this.id,
    required this.productCode,
    required this.name,
    this.subtitle,
    this.coverImage,
    required this.productType,
    required this.pointsPrice,
    required this.stock,
    this.virtualConfigJson,
  });

  factory MallProduct.fromJson(Map<String, dynamic> json) {
    return MallProduct(
      id: json['id']?.toString() ?? '',
      productCode: json['productCode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      coverImage: json['coverImage']?.toString(),
      productType: json['productType']?.toString() ?? 'VIRTUAL',
      pointsPrice: _asInt(json['pointsPrice']),
      stock: _asInt(json['stock']),
      virtualConfigJson: json['virtualConfigJson']?.toString(),
    );
  }
}

class MemberOrder {
  final String id;
  final String orderNo;
  final String planName;
  final double amount;
  final int payStatus;

  MemberOrder({
    required this.id,
    required this.orderNo,
    required this.planName,
    required this.amount,
    required this.payStatus,
  });

  factory MemberOrder.fromJson(Map<String, dynamic> json) {
    return MemberOrder(
      id: json['id']?.toString() ?? '',
      orderNo: json['orderNo']?.toString() ?? '',
      planName: json['planName']?.toString() ?? '',
      amount: _asDouble(json['amount']),
      payStatus: _asInt(json['payStatus']),
    );
  }
}

class UserAddress {
  final String? id;
  final String receiverName;
  final String receiverPhone;
  final String? province;
  final String? city;
  final String? district;
  final String detailAddress;
  final int isDefault;

  UserAddress({
    this.id,
    required this.receiverName,
    required this.receiverPhone,
    this.province,
    this.city,
    this.district,
    required this.detailAddress,
    this.isDefault = 0,
  });

  String get fullText {
    return '${province ?? ''}${city ?? ''}${district ?? ''}$detailAddress';
  }

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id']?.toString(),
      receiverName: json['receiverName']?.toString() ?? '',
      receiverPhone: json['receiverPhone']?.toString() ?? '',
      province: json['province']?.toString(),
      city: json['city']?.toString(),
      district: json['district']?.toString(),
      detailAddress: json['detailAddress']?.toString() ?? '',
      isDefault: _asInt(json['isDefault']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'receiverName': receiverName,
        'receiverPhone': receiverPhone,
        'province': province,
        'city': city,
        'district': district,
        'detailAddress': detailAddress,
        'isDefault': isDefault,
      };
}

class MallRedeemOrder {
  final String id;
  final String orderNo;
  final String productName;
  final int pointsCost;
  final int orderStatus;
  final String? virtualPayload;

  MallRedeemOrder({
    required this.id,
    required this.orderNo,
    required this.productName,
    required this.pointsCost,
    required this.orderStatus,
    this.virtualPayload,
  });

  factory MallRedeemOrder.fromJson(Map<String, dynamic> json) {
    return MallRedeemOrder(
      id: json['id']?.toString() ?? '',
      orderNo: json['orderNo']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      pointsCost: _asInt(json['pointsCost']),
      orderStatus: _asInt(json['orderStatus']),
      virtualPayload: json['virtualPayload']?.toString(),
    );
  }
}

class PageResult<T> {
  final List<T> records;
  final int total;

  PageResult({required this.records, required this.total});

  factory PageResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final list = json['records'] as List<dynamic>? ?? [];
    return PageResult(
      records: list.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      total: _asInt(json['total']),
    );
  }
}

int _asInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? defaultValue;
}

double _asDouble(dynamic value, {double defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? defaultValue;
}
