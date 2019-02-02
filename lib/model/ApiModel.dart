import 'package:leaf/model/FeedState.dart';

class ArticleApi {
  Map<String, Article> articles = new Map();

  static ArticleApi parse(Map<String, dynamic> map) {
    ArticleApi api = new ArticleApi();
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
