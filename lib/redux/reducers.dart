import 'package:leaf/model/FeedState.dart';
import 'package:leaf/redux/actions.dart';

FeedState feedReducer(FeedState pre, dynamic action) {
  if (action is UpdateArticle) {
    UpdateArticle requestArticles = action;
    FeedState feedState = new FeedState();
    feedState.content = requestArticles.content;
    return feedState;
  } else {
    return pre;
  }
}
