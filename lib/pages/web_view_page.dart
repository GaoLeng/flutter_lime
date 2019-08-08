import 'package:flutter/material.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

//通用网页页面
class WebViewPage extends StatefulWidget {
  String _themeColor;
  String _title;
  String _url;

  WebViewPage(final this._title, final this._url) {
    _themeColor = themeColors[currThemeColorIndex]
        .value
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2);
    LogUtils.i("_themeColor: $_themeColor");
  }

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _webViewController;

  bool _isLoading = true;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    final list = <Widget>[];
    if (_isLoading) {
      list.add(LinearProgressIndicator(
        value: _progress,
        backgroundColor: Colors.white,
      ));
    }
    list.add(Expanded(
        child: WebView(
            initialUrl: widget._url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: onWebViewCreated,
            navigationDelegate: (navigation) {
              return NavigationDecision.prevent;
            },
            onPageFinished: onPageFinished,
            debuggingEnabled: is_debug)));

    return Scaffold(
        appBar: AppBar(title: Text(widget._title)),
        body: Column(children: list));
  }

  onWebViewCreated(webViewController) {
    _webViewController = webViewController;
    _isLoading = true;
    updateProgress();
  }

  onPageFinished(url) {
    LogUtils.i("onPageFinished url: $url");
    _progress = 1;
  }

  void updateProgress() async {
    _progress = 0;
    while (_isLoading) {
      await Future.delayed(Duration(milliseconds: 10), () {
        if (_progress < 0.5) {
          _progress += 0.05;
        } else if (_progress < 1) {
          _progress += 0.01;
        } else if (_progress < 1.5) {
          _progress += 0.08;
        } else {
          _isLoading = false;
        }
        setState(() {});
        LogUtils.i("updateProgress _progress: $_progress");
      });
    }
  }

  modifyCss(clzName, key, {value, index = 0}) {
    value ??= "#${widget._themeColor}";
    modifyWeb(clzName, index, "style.$key=\"$value\"");
  }

  modifyWeb(clzName, index, modify) {
    _webViewController.evaluateJavascript(
        "document.getElementsByClassName(\"$clzName\")[$index].$modify");
  }
}
