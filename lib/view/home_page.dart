import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leaf/model/FeedState.dart';
import 'package:leaf/redux/actions.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';

class MyHomePage extends StatelessWidget {
  final DevToolsStore<FeedState> store;

  MyHomePage(this.store);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter-Redux-Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new ChannelView(store),
    );
  }
}

class ChannelView extends StatelessWidget {
  final DevToolsStore<FeedState> store;

  ChannelView(this.store);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ShoppingCart'),
      ),
      body: new ChannelList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => (store.dispatch(requestArticle)),
        child: new Icon(Icons.add),
      ),
      endDrawer: new Container(
          width: 240.0, color: Colors.white, child: new ReduxDevTools(store)),
    );
  }
}

class ChannelList extends StatefulWidget {
  @override
  _ChannelListState createState() => new _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<FeedState, Content>(
      converter: (Store<FeedState> store) => store.state.content,
      builder: (context, content) {
        print(content.requestTime.toString() +
            '  ' +
            content.articles.length.toString());
        return new ListView.builder(
            itemCount: content.articles.length,
            itemBuilder: (context, position) =>
                getCard(content.articles[position]));
      },
    );
  }
}

ArticleCard getCard(Article article) {
  print(article.title);
  return new ArticleCard(article);
}

class ArticleCard extends StatelessWidget {
  final Article article;

  ArticleCard(this.article);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<FeedState, OnStateChanged>(converter: (store) {
      return (item) => store.dispatch(Action.ClickArticle);
    }, builder: (context, callback) {
      return new ListTile(title: new Text(article.title));
    });
  }
}

typedef OnStateChanged = Function(Article item);
