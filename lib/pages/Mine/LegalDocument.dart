import 'package:flutter/material.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/constants/LegalContent.dart';

/// 用户协议 / 隐私政策详情页
class LegalDocumentView extends StatelessWidget {
  const LegalDocumentView({super.key, required this.docType});

  final LegalDocType docType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FondiaAppBar(
        title: LegalContent.title(docType),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Text(
          LegalContent.content(docType),
          style: const TextStyle(
            fontSize: 14,
            height: 1.7,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}
