import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fondia/constants/index.dart';

/// 解析后台上传的相对路径为可访问 URL
String? resolveStaticImageUrl(String? path) {
  if (path == null || path.isEmpty || path == 'null') return null;
  final trimmed = path.trim();
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  if (trimmed.startsWith('lib/') || trimmed.startsWith('assets/')) {
    return trimmed;
  }
  final normalized = trimmed.replaceAll('\\', '/').replaceFirst(RegExp(r'^/+'), '');
  return '${GlobalConstants.BASE_URL}/sys/common/static/$normalized';
}

/// 网络图片地址规范化：对路径中的中文/空格做 percent-encode
String encodeHttpImageUrl(String url) {
  final trimmed = url.trim();
  if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
    return trimmed;
  }

  final match = RegExp(r'^(https?):\/\/([^/?#]+)([^?#]*)(\?[^#]*)?(#.*)?$')
      .firstMatch(trimmed);
  if (match == null) return trimmed;

  final scheme = match.group(1)!;
  final authority = match.group(2)!;
  final path = match.group(3) ?? '';
  final query = match.group(4);
  final fragment = match.group(5);

  final encodedPath = path.split('/').map((segment) {
    if (segment.isEmpty) return segment;
    try {
      return Uri.encodeComponent(Uri.decodeComponent(segment));
    } catch (_) {
      return Uri.encodeComponent(segment);
    }
  }).join('/');

  final buffer = StringBuffer('$scheme://$authority$encodedPath');
  if (query != null) buffer.write(query);
  if (fragment != null) buffer.write(fragment);
  return buffer.toString();
}

String _networkImageUrl(String url) {
  final resolved = resolveStaticImageUrl(url) ?? url.trim();
  return encodeHttpImageUrl(resolved);
}

/// 专用 Dio，避免走业务拦截器（仅 App/桌面端使用）
final Dio _imageDio = Dio(BaseOptions(
  responseType: ResponseType.bytes,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 30),
  followRedirects: true,
  headers: const {
    'Accept': 'image/*,*/*',
    'User-Agent': 'FondiaApp/1.0',
  },
));

final Map<String, Uint8List> _imageCache = {};

Future<Uint8List?> _fetchImageBytes(String url) async {
  final key = _networkImageUrl(url);
  final cached = _imageCache[key];
  if (cached != null) return cached;

  try {
    final response = await _imageDio.get<List<int>>(key);
    if (response.statusCode == 200 && response.data != null) {
      final bytes = Uint8List.fromList(response.data!);
      _imageCache[key] = bytes;
      return bytes;
    }
  } catch (_) {}
  return null;
}

Widget _recipeImageErrorBox() {
  return Container(
    color: const Color(0xFFF5F5F5),
    alignment: Alignment.center,
    child: Icon(Icons.broken_image, color: Colors.grey[400]),
  );
}

Widget _recipeImageLoadingBox(double? progress) {
  return Container(
    color: const Color(0xFFF5F5F5),
    alignment: Alignment.center,
    child: SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.orange,
        value: progress,
      ),
    ),
  );
}

/// Web 端走浏览器 img 标签展示，不受 XHR CORS 限制
class _RecipeWebNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const _RecipeWebNetworkImage({
    required this.url,
    required this.fit,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      _networkImageUrl(url),
      fit: fit,
      width: width,
      height: height,
      gaplessPlayback: true,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        final total = loadingProgress.expectedTotalBytes;
        final loaded = loadingProgress.cumulativeBytesLoaded;
        return _recipeImageLoadingBox(
          total != null ? loaded / total : null,
        );
      },
      errorBuilder: (_, __, ___) => _recipeImageErrorBox(),
    );
  }
}

class _RecipeNetworkImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const _RecipeNetworkImage({
    required this.url,
    required this.fit,
    this.width,
    this.height,
  });

  @override
  State<_RecipeNetworkImage> createState() => _RecipeNetworkImageState();
}

class _RecipeNetworkImageState extends State<_RecipeNetworkImage> {
  Uint8List? _bytes;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _RecipeNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _bytes = null;
      _failed = false;
      _load();
    }
  }

  Future<void> _load() async {
    final bytes = await _fetchImageBytes(widget.url);
    if (!mounted) return;
    setState(() {
      _bytes = bytes;
      _failed = bytes == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes != null) {
      return Image.memory(
        _bytes!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _recipeImageErrorBox(),
      );
    }
    if (_failed) return _recipeImageErrorBox();
    return _recipeImageLoadingBox(null);
  }
}

/// 菜谱封面：支持 asset / network
class RecipeImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const RecipeImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    final raw = url?.trim();
    if (raw == null || raw.isEmpty || raw == 'null') {
      child = Container(
        color: const Color(0xFFF5F5F5),
        alignment: Alignment.center,
        child: Icon(Icons.restaurant, color: Colors.grey[400], size: 32),
      );
    } else if (raw.startsWith('lib/') || raw.startsWith('assets/')) {
      child = Image.asset(raw, fit: fit, width: width, height: height);
    } else if (kIsWeb) {
      child = _RecipeWebNetworkImage(
        url: raw,
        fit: fit,
        width: width,
        height: height,
      );
    } else {
      child = _RecipeNetworkImage(
        url: raw,
        fit: fit,
        width: width,
        height: height,
      );
    }

    if (width == null && height == null) {
      child = AspectRatio(aspectRatio: 16 / 9, child: child);
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}

/// 菜系 emoji 图标
Widget cuisineIconWidget(String? icon, {double size = 26}) {
  if (icon == null || icon.isEmpty) {
    return Icon(Icons.restaurant_menu, size: size, color: Colors.orange);
  }
  final trimmed = icon.trim();
  if (trimmed.startsWith('http') ||
      trimmed.startsWith('lib/') ||
      trimmed.startsWith('assets/')) {
    return RecipeImage(url: trimmed, width: size, height: size);
  }
  return Text(trimmed, style: TextStyle(fontSize: size));
}
