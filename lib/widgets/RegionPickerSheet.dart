import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fondia/utils/region_data.dart';

class RegionPickerSheet extends StatefulWidget {
  final RegionSelection? initial;

  const RegionPickerSheet({super.key, this.initial});

  static Future<RegionSelection?> show(
    BuildContext context, {
    RegionSelection? initial,
  }) {
    return showModalBottomSheet<RegionSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RegionPickerSheet(initial: initial),
    );
  }

  @override
  State<RegionPickerSheet> createState() => _RegionPickerSheetState();
}

class _RegionPickerSheetState extends State<RegionPickerSheet> {
  List<RegionNode> _provinces = [];
  bool _loading = true;

  int _provinceIndex = 0;
  int _cityIndex = 0;
  int _districtIndex = 0;

  FixedExtentScrollController? _provinceController;
  FixedExtentScrollController? _cityController;
  FixedExtentScrollController? _districtController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _provinceController?.dispose();
    _cityController?.dispose();
    _districtController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provinces = await RegionData.load();
    if (!mounted) return;

    var provinceIndex = 0;
    var cityIndex = 0;
    var districtIndex = 0;

    final initial = widget.initial;
    if (initial != null) {
      provinceIndex = provinces.indexWhere((item) => item.name == initial.province);
      if (provinceIndex < 0) provinceIndex = 0;

      final cities = provinces[provinceIndex].children;
      if (cities.isNotEmpty) {
        cityIndex = cities.indexWhere((item) => item.name == initial.city);
        if (cityIndex < 0) cityIndex = 0;

        final districts = cities[cityIndex].children;
        if (districts.isNotEmpty) {
          districtIndex = districts.indexWhere((item) => item.name == initial.district);
          if (districtIndex < 0) districtIndex = 0;
        }
      }
    }

    setState(() {
      _provinces = provinces;
      _provinceIndex = provinceIndex;
      _cityIndex = cityIndex;
      _districtIndex = districtIndex;
      _loading = false;
      _provinceController = FixedExtentScrollController(initialItem: provinceIndex);
      _cityController = FixedExtentScrollController(initialItem: cityIndex);
      _districtController = FixedExtentScrollController(initialItem: districtIndex);
    });
  }

  List<RegionNode> get _cities =>
      _provinces.isEmpty ? [] : _provinces[_provinceIndex].children;

  List<RegionNode> get _districts {
    if (_cities.isEmpty) return [];
    return _cities[_cityIndex.clamp(0, _cities.length - 1)].children;
  }

  void _syncCityAndDistrict() {
    if (_cityIndex >= _cities.length) {
      _cityIndex = 0;
      _cityController?.jumpToItem(0);
    }
    if (_districtIndex >= _districts.length) {
      _districtIndex = 0;
      _districtController?.jumpToItem(0);
    }
  }

  RegionSelection? _currentSelection() {
    if (_provinces.isEmpty) return null;
    final province = _provinces[_provinceIndex];
    final city = _cities.isEmpty ? null : _cities[_cityIndex];
    final district = _districts.isEmpty ? null : _districts[_districtIndex];
    return RegionSelection(
      province: province.name,
      city: city?.name ?? '',
      district: district?.name ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 360,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消', style: TextStyle(color: Colors.grey)),
                    ),
                    const Expanded(
                      child: Text(
                        '选择地址',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => Navigator.pop(context, _currentSelection()),
                      child: const Text(
                        '确定',
                        style: TextStyle(
                          color: Color(0xffff7f32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(color: Color(0xffff7f32)),
                      )
                    : Row(
                        children: [
                          _buildColumn(
                            label: '省份',
                            items: _provinces.map((e) => e.name).toList(),
                            controller: _provinceController!,
                            selectedIndex: _provinceIndex,
                            onSelected: (index) {
                              setState(() {
                                _provinceIndex = index;
                                _cityIndex = 0;
                                _districtIndex = 0;
                                _cityController?.jumpToItem(0);
                                _districtController?.jumpToItem(0);
                              });
                            },
                          ),
                          _buildColumn(
                            label: '城市',
                            items: _cities.map((e) => e.name).toList(),
                            controller: _cityController!,
                            selectedIndex: _cityIndex,
                            onSelected: (index) {
                              setState(() {
                                _cityIndex = index;
                                _districtIndex = 0;
                                _districtController?.jumpToItem(0);
                                _syncCityAndDistrict();
                              });
                            },
                          ),
                          _buildColumn(
                            label: '区县',
                            items: _districts.map((e) => e.name).toList(),
                            controller: _districtController!,
                            selectedIndex: _districtIndex,
                            onSelected: (index) {
                              setState(() => _districtIndex = index);
                            },
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn({
    required String label,
    required List<String> items,
    required FixedExtentScrollController controller,
    required int selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text('暂无', style: TextStyle(color: Colors.grey[400])))
                : CupertinoPicker(
                    scrollController: controller,
                    itemExtent: 40,
                    magnification: 1.08,
                    squeeze: 1.05,
                    useMagnifier: true,
                    onSelectedItemChanged: onSelected,
                    selectionOverlay: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.orange.withOpacity(0.25)),
                          bottom: BorderSide(color: Colors.orange.withOpacity(0.25)),
                        ),
                      ),
                    ),
                    children: items
                        .map(
                          (item) => Center(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 15,
                                color: items.indexOf(item) == selectedIndex
                                    ? const Color(0xffff7f32)
                                    : Colors.black87,
                                fontWeight: items.indexOf(item) == selectedIndex
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
