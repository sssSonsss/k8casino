import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class K8HomePage extends StatefulWidget {
  const K8HomePage({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<K8HomePage> createState() => _K8HomePageState();
}

class _K8HomePageState extends State<K8HomePage> {
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? webViewController;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        const Color(0xff212639).withOpacity(0.11),
        const Color(0xff3F4C77).withOpacity(0.7),
      ], begin: Alignment.bottomLeft)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.title,
          ),
          centerTitle: true,
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(widget.url),
          ),
          initialOptions: InAppWebViewGroupOptions(

            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              userAgent:
                  "Mozilla/5.0 (Linux; Android 4.4.4; SAMSUNG-SM-N900A  SAMSUNG-SM-A536E Build/tt) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36;",
            ),
            android: AndroidInAppWebViewOptions(
              useHybridComposition: false,
              domStorageEnabled: true,
            ),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
            ),
          ),
          onWebViewCreated: (controller) {
            print('------ $controller');
            webViewController = controller;
            controller.addJavaScriptHandler(
              handlerName: FunctionTransfer.handleNavigate.name,
              callback: (args) {
                launchHttps(widget.url);
              },
            );
          },
        ),
        // WebViewWidget(
        //   controller: controller,
        // )
      ),
    );
  }
}

enum FunctionTransfer {
  handleNavigate,
  handleRequest,
  handleAddToken,
  handleSharing
}

void launchHttps(String urlHttps) async {
  try {
    final url = Uri.parse(urlHttps);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    print(e.toString());
  }
}
