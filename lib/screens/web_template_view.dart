import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebTemplateView extends StatefulWidget {
  final String assetPath;

  const WebTemplateView({Key? key, required this.assetPath}) : super(key: key);

  @override
  State<WebTemplateView> createState() => _WebTemplateViewState();
}

class _WebTemplateViewState extends State<WebTemplateView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadFlutterAsset(widget.assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.assetPath.split('/').last)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
