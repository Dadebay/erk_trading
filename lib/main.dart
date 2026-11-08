import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'web_navigation_policy.dart';

const _brandColor = Color(0xff2e4736);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: _brandColor,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: _brandColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ErkTradingApp());
}

class ErkTradingApp extends StatelessWidget {
  const ErkTradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Erk Trading',
      debugShowCheckedModeBanner: false,
      home: ErkTradingWebView(),
    );
  }
}

class ErkTradingWebView extends StatefulWidget {
  const ErkTradingWebView({super.key});

  @override
  State<ErkTradingWebView> createState() => _ErkTradingWebViewState();
}

class _ErkTradingWebViewState extends State<ErkTradingWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasMainFrameError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _hasMainFrameError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != true || !mounted) return;
            setState(() {
              _isLoading = false;
              _hasMainFrameError = true;
            });
          },
          onNavigationRequest: (request) => isTrustedErkTradingUrl(request.url)
              ? NavigationDecision.navigate
              : NavigationDecision.prevent,
        ),
      )
      ..loadRequest(Uri.parse(erkTradingHomeUrl));
  }

  void _retry() {
    setState(() {
      _isLoading = true;
      _hasMainFrameError = false;
    });
    _controller.loadRequest(Uri.parse(erkTradingHomeUrl));
  }

  Future<void> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    } else {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: _brandColor,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                top: -10,
                child: WebViewWidget(controller: _controller),
              ),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              if (_hasMainFrameError)
                ColoredBox(
                  color: _brandColor,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Could not load Erk Trading.',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _retry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
