import 'package:leaf/model/state/FeedState.dart';

class ChannelArticle {
  Map<String, Article> articles = new Map();

  static ChannelArticle parse(Map<String, dynamic> map) {
    ChannelArticle api = new ChannelArticle();
    if (map == null) {
      return api;
    }
    map['articles'].forEach((aid, articleJson) =>
        api.articles[aid] = parseArticle(aid, articleJson));
    return api;
  }

  static Article parseArticle(String aid, Map<String, dynamic> articleJson) {
    Article article = Article.parse(articleJson);
    return article;
  }
}
