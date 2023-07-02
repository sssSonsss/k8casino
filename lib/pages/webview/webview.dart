import 'dart:async';

import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

class K8HomePage extends StatefulWidget {
  const K8HomePage({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<K8HomePage> createState() => _K8HomePageState();
}

class _K8HomePageState extends State<K8HomePage> {
  late final WebViewController controller;
  double progress = 0;

  @override
  // void initState() {
  //   controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setBackgroundColor(const Color(0x00000000))
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           // Update loading bar.
  //         },
  //         onPageStarted: (String url) {
  //           print('----------url:$url');
  //         },
  //         onPageFinished: (String url) {
  //           print('----------url:$url');
  //         },
  //         onWebResourceError: (WebResourceError error) {
  //           print('----------${error.description}');
  //         },
  //         onNavigationRequest: (NavigationRequest request) {
  //           if (request.url.startsWith(widget.url)) {
  //             return NavigationDecision.prevent;
  //           }
  //           return NavigationDecision.navigate;
  //         },
  //       ),
  //     )
  //     ..addJavaScriptChannel(
  //       'Print',
  //       onMessageReceived: (JavaScriptMessage result) {
  //         final json = result.message
  //             .replaceAll('message: craftgateResponse,',
  //                 '"message": "craftgateResponse",')
  //             .replaceAll('value', '"value"');
  //       },
  //     )
  //     ..loadRequest(
  //       Uri.parse(widget.url),
  //     );
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? webViewController;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xff212639).withOpacity(0.11),
        Color(0xff3F4C77).withOpacity(0.7),
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
        body: Container(
          child: InAppWebView(
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
