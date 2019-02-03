import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leaf/model/state/FeedState.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:leaf/redux/reducers.dart';
import 'package:leaf/view/home_page.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

void main() {
  runApp(new FlutterApp());
}

class FlutterApp extends StatelessWidget {
  final DevToolsStore<FeedState> store = new DevToolsStore<FeedState>(
    feedReducer,
    initialState: new FeedState(),
    middleware: [thunkMiddleware],
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<FeedState>(
        store: store,
        child: new MyHomePage(store),
    );
  }
}
