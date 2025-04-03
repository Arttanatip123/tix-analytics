import 'package:flutter/material.dart';
import 'package:tix_analytics/tix.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> with Tix {
  late WebViewController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // คุณสามารถตรวจสอบความคืบหน้าการโหลดได้ที่นี่
          },
          onPageStarted: (String url) {
            print("Page Started: $url");
          },
          onPageFinished: (String url) {
            print("Page Finished: $url");
          },
          onHttpError: (HttpResponseError error) {
            print("HTTP Error: ${error.response}");
          },
          onWebResourceError: (WebResourceError error) {
            print("WebResource Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse('https://alpha-api.bluedragonlottery.cloud/poc/webview'));

    _controller.addJavaScriptChannel(
        'messageHandler',
        onMessageReceived: (message){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Webview')),
      body: WebViewWidget(
        controller: _controller,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_upward),
        onPressed: () {
          _controller.runJavaScript('fromFlutter("From Flutter")');
        },
      ),
    );
  }
}
