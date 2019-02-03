import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedState {
  Content content;
  WebState webState;
  RefreshState refreshState = new RefreshState(null, RefreshType.PULL_DOWN);

  FeedState() {
    content = new Content();
  }
}

class Content {
  List<Article> articles = new List();
  int requestTime;
}

class Article {
  String title;
  String url;

  List<Thumbnail> thumbnails = new List();

  static Article parse(Map<String, dynamic> json) {
    Article article = new Article();
    article.title = json['title'];
    article.url = json['url'];
    List<dynamic> thumbnailJson = json['thumbnails'];
    thumbnailJson
        .forEach((json) => article.thumbnails.add(Thumbnail.parse(json)));
    return article;
  }
}

class Thumbnail {
  String url;
  int height;
  int width;

  static Thumbnail parse(Map<String, dynamic> json) {
    Thumbnail thumbnail = new Thumbnail();
    thumbnail.url = json['url'];
    thumbnail.height = json['height'];
    thumbnail.width = json['width'];
    return thumbnail;
  }
}

class WebState {
  String currentUrl;
  String title;

  WebState({url, title}) {
    this.currentUrl = url;
    this.title = title;
  }
}

class RefreshState {
  final RefreshController controller;
  final RefreshType refreshType;

  RefreshState(this.controller, this.refreshType);
}

enum RefreshType { PULL_DOWN, PULL_UP }
