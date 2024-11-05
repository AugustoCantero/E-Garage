import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

import 'Aprobado.dart';

class PagoScreen extends StatefulWidget {
  static const String routename = 'PagoScreen';
  final String? url;
  const PagoScreen({super.key, this.url});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: Uri.parse(("${widget.url}"))
              ),
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                print(url);
                
                if (url.toString().contains("https://www.egarage.com.ar/success")) {
                  webViewController?.goBack();
                  context.go('/aprobado');
                  return;
                } else if (url.toString().contains("https://www.egarage.com.ar/failure")) {
                  webViewController?.goBack();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AprobadoScreen()),
                  );
                  return;
                } else if (url.toString().contains("https://www.egarage.com.ar/pending")) {
                  webViewController?.goBack();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AprobadoScreen()),
                  );
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
