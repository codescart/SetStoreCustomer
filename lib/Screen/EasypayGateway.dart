import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sethStore/Provider/CartProvider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EazyPayGateway extends StatefulWidget {
  final String myUrl;

  const EazyPayGateway({Key? key, required this.myUrl}) : super(key: key);

  @override
  State<EazyPayGateway> createState() => _EazyPayGatewayState();
}

class _EazyPayGatewayState extends State<EazyPayGateway> {

  WebViewController controller = WebViewController();

  @override
  void initState() {
    print(widget.myUrl);
    super.initState();
    controller
      ..loadRequest(Uri.parse(widget.myUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('upi://')) {
              canLaunchUrl(Uri.parse(request.url));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          }));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xff272139),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () {
          context.read<CartProvider>().cartList.clear();
        },
        label: const Text("Go back"),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
