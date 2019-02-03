import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leaf/model/FeedState.dart';
import 'package:leaf/redux/actions.dart';
import 'package:leaf/view/card.dart';
import 'package:leaf/view/web.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

class MyHomePage extends StatelessWidget {
  final DevToolsStore<FeedState> store;

  MyHomePage(this.store);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ChannelView(store),
      routes: <String, WidgetBuilder>{
        '/web': (BuildContext context) => WebPage(store),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChannelView extends StatelessWidget {
  final DevToolsStore<FeedState> store;

  ChannelView(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed-Flutter-Redux'),
      ),
      body: ChannelList(store),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => store.dispatch(
            RequestArticle(store: store, refreshType: RefreshType.PULL_DOWN)),
        child: Icon(Icons.add),
      ),
      endDrawer: Container(
          width: 240.0, color: Colors.white, child: new ReduxDevTools(store)),
    );
  }
}

class ChannelList extends StatefulWidget {
  final DevToolsStore<FeedState> store;

  ChannelList(this.store);

  @override
  _ChannelListState createState() => new _ChannelListState(store);
}

class _ChannelListState extends State<ChannelList> {
  final DevToolsStore<FeedState> store;

  _ChannelListState(this.store);

  @override
  void initState() {
    super.initState();
    store.dispatch(
        RequestArticle(store: store, refreshType: RefreshType.PULL_DOWN));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FeedState, Content>(
      converter: (Store<FeedState> store) => store.state.content,
      builder: (context, content) {
        RefreshController controller = RefreshController();
        return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: controller,
            onRefresh: (up) => _onRefresh(up, controller, store),
            child: _buildListView(content));
      },
    );
  }

  ListView _buildListView(Content content) {
    return ListView.builder(
        itemCount: content.articles.length,
        itemBuilder: (context, position) => getCard(
            context,
            content.articles[position],
            () => store.dispatch(OpenArticle(WebState(
                url: content.articles[position].url,
                title: content.articles[position].title)))));
  }

  void _onRefresh(up, RefreshController controller, store) {
    print("_onRefresh ****************");
    if (up) {
      //headerIndicator callback
      store.dispatch(RequestArticle(
          store: store,
          controller: controller,
          refreshType: RefreshType.PULL_DOWN));
    } else {
      print("_onRefresh ****************  down");
      //footerIndicator Callback
      store.dispatch(RequestArticle(
          store: store,
          controller: controller,
          refreshType: RefreshType.PULL_UP));
    }
  }
}

Widget getCard(BuildContext context, Article article, openArticle) {
  Widget card;
  if (article.thumbnails.length >= 3) {
    card = ThreeImageCard(article);
  } else if (article.thumbnails.length >= 1) {
    card = RightImageCard(article);
  } else {
    card = TextCard(article);
  }
  return Card(
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: card,
        ),
        onTap: () {
          openArticle(); // 理论上应该做webview的url变化监听
          Navigator.of(context).pushNamed('/web');
        },
      ),
      margin: EdgeInsets.fromLTRB(5, 8, 5, 8),
      elevation: 0);
}
