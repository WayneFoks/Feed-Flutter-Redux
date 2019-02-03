import 'package:leaf/model/state/FeedState.dart';
import 'package:leaf/redux/actions.dart';

FeedState feedReducer(FeedState pre, dynamic inAction) {
  if (inAction is UpdateArticle) {
    UpdateArticle action = inAction;
    FeedState feedState = new FeedState();
    feedState.content = action.content;
    return feedState;
  } else if (inAction is OpenArticle) {
    OpenArticle action = inAction;
    FeedState feedState = new FeedState();
    feedState.content = pre.content;
    feedState.webState = action.webState;

    return feedState;
  } else {
    return pre;
  }
}
