import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff2e4736), // Navigasyon barı yeşil
      systemNavigationBarIconBrightness: Brightness.light, // İkonlar beyaz
      statusBarColor: Color(0xff2e4736), // Status bar şeffaf
      statusBarIconBrightness: Brightness.light, // Status bar ikonları beyaz
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Erk Trading',
      debugShowCheckedModeBanner: false,
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;
  bool _isLoading = true;
  final String primaryUrl = 'https://erktrading.com/indexmobile/';
  final String fallbackUrl = 'http://194.67.67.38/';
  bool _useFallback = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JavaScript etkin
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });

            // Eğer primary URL hata verirse, fallback URL'e geç
            if (!_useFallback && error.errorType == WebResourceErrorType.hostLookup || error.errorType == WebResourceErrorType.connect || error.errorType == WebResourceErrorType.timeout) {
              setState(() {
                _useFallback = true;
              });
              _controller.loadRequest(Uri.parse(fallbackUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ana bağlantı başarısız. Yedek bağlantıya geçiliyor...'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Hata: ${error.description}'),
                ),
              );
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://erktrading.com/') || request.url.startsWith('http://194.67.67.38/')) {
              return NavigationDecision.navigate; // Bu URL'lere gitmesine izin ver
            }
            return NavigationDecision.prevent; // Diğer URL'leri engelle
          },
        ),
      )
      ..loadRequest(Uri.parse(primaryUrl));
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false; // Uygulamadan çıkma
    }
    return true; // Eğer WebView'de geri gidilecek sayfa yoksa uygulamadan çık
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xff2e4736), // Arka plan rengi
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                top: -10,
                child: WebViewWidget(controller: _controller),
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
