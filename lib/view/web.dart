import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:leaf/model/FeedState.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

class WebPage extends StatefulWidget {
  final DevToolsStore<FeedState> store;

  WebPage(this.store);

  @override
  _WebPageState createState() => _WebPageState(store);
}

class _WebPageState extends State<WebPage> {
  final DevToolsStore<FeedState> store;

  _WebPageState(this.store);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: store.state.webState == null ? "" : store.state.webState.currentUrl,
      appBar: AppBar(
        title: Text(
            store.state.webState == null ? "" : store.state.webState.title),
      ),
      withLocalStorage: true,
      withJavascript: true,
      appCacheEnabled: true,
      initialChild: Container(
        child: const Center(
          child: Text('加载中....'),
        ),
      ),
    );
  }
}
