import 'dart:convert';

import 'package:flutter/services.dart';

class RegionNode {
  final String code;
  final String name;
  final List<RegionNode> children;

  const RegionNode({
    required this.code,
    required this.name,
    this.children = const [],
  });

  factory RegionNode.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'] as List<dynamic>? ?? [];
    return RegionNode(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      children: rawChildren
          .map((item) => RegionNode.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RegionSelection {
  final String province;
  final String city;
  final String district;

  const RegionSelection({
    required this.province,
    required this.city,
    required this.district,
  });

  String get displayText => '$province $city $district'.trim();
}

class RegionData {
  static List<RegionNode>? _cache;

  static Future<List<RegionNode>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('lib/assets/addr/pca-code.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _cache = list
        .map((item) => RegionNode.fromJson(item as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  static RegionSelection? matchSelection(
    List<RegionNode> provinces, {
    String? province,
    String? city,
    String? district,
  }) {
    if (province == null || province.isEmpty) return null;

    final provinceNode = provinces.firstWhere(
      (item) => item.name == province,
      orElse: () => provinces.first,
    );
    final cityNode = provinceNode.children.isEmpty
        ? null
        : provinceNode.children.firstWhere(
            (item) => item.name == city,
            orElse: () => provinceNode.children.first,
          );
    final districtNode = cityNode == null || cityNode.children.isEmpty
        ? null
        : cityNode.children.firstWhere(
            (item) => item.name == district,
            orElse: () => cityNode.children.first,
          );

    return RegionSelection(
      province: provinceNode.name,
      city: cityNode?.name ?? '',
      district: districtNode?.name ?? '',
    );
  }
}
