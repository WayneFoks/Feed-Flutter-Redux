class FeedState {
  Content content;

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

  List<Thumbnail> thumbnails = new List();

  static Article parse(Map<String, dynamic> json) {
    Article article = new Article();
    article.title = json['title'];
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
