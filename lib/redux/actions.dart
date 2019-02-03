import 'package:leaf/model/FeedState.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leaf/model/ApiModel.dart';

class OpenArticle {
  WebState _webState;

  WebState get webState => this._webState;

  OpenArticle(this._webState);
}

class UpdateArticle {
  Content _content;

  Content get content => this._content;

  UpdateArticle(this._content);
}

class RequestArticle {
  RequestArticle({Store<FeedState> store, controller, refreshType}) {
    store.state.refreshState = RefreshState(controller, refreshType);
    requestArticle(store);
  }
}

// ThunkAction
ThunkAction<FeedState> requestArticle = (Store<FeedState> store) async {
  RefreshType refreshType = store.state.refreshState.refreshType;
  RefreshController refreshController = store.state.refreshState.controller;
  bool up = refreshType == RefreshType.PULL_DOWN;

  String fetchUrl =
      "http://iflow.uczzd.cn/iflow/api/v1/channel/100?app=uc-iflow&sp_gz=4&xss_enc=0&ab_tag=1168A2;1167C2;&recoid=7410374990011175254&ftime=1547099879611&method=new&count=20&no_op=0&auto=2&content_ratio=0&_tm=1547193407696&ssign=AAPEBAeEAxlu2Ib91edDVSR4c2nljZdxWYxsn7knV2mvSr3ZLKqEGqBvZmw6qX23utI%3D&scene=0&earphone=0&moving=-1&puser=0&enable_ad=1&ad_extra=AAPtYwIQWftB3nixavZFw3Q8&cindex=1&active_time=AAMdxrFyfL4mN3Ul58rJJDFd&ressc=44&uc_param_str=dnnivebichfrmintcpgimewidsudsvlissnw&dn=33002649689-8032251b&nn=AASDRT%2FvAZbxLrG0GdnKBLE%2BX%2BpfVuqVMFhNppdbL575ng%3D%3D&ve=12.2.6.1124&bi=997&ch=iphone%40ucweb.com&fr=iphone&mi=x86_64&nt=99&pc=AAQNqqrcScBIyzoh2ImR7%2BiChP98JXzE%2F6lGHpFPppOyJirABSQLGyNsaIbI2N4sIZPglR8afX3cmgmltJ%2BZdgAlbg1E4oM2kjM2cOvI2BPXpw%3D%3D&me=AASDEKoe7fmdUN0CzlrL2fOQYR6fGshkvpsas5JUedbgppZj3ScPufDTVKv5mtRWM2c%3D&ut=AAQSmTRUAJpBYWkF89bS3bVZ7V%2BKUs3r5OUKw6V0DxtbEA%3D%3D&ai=AAQ%3D&sv=test&lb=AATc5wxBTG7fcH6pVawC7x9YrTqlY5U%2BDE%2FuoW7xJc65Ag%3D%3D&ss=414x896&nw=WIFI";
  http.Response response = await http.get(fetchUrl);
  ArticleApi api = ArticleApi.parse(json.decode(response.body)['data']);
  Content content = store.state.content;
  content.requestTime = DateTime.now().millisecondsSinceEpoch;
  List<Article> newArticle = new List();
  api.articles.forEach((aid, article) => newArticle.add(article));
  if (refreshController != null) {
    if (response.statusCode == 200) {
      if (newArticle.length > 0) {
        if (up) {
          refreshController.sendBack(up, RefreshStatus.completed);
        } else {
          refreshController.sendBack(up, RefreshStatus.idle);
        }
      } else {
        refreshController.sendBack(up, RefreshStatus.noMore);
      }
    } else {
      refreshController.sendBack(up, RefreshStatus.failed);
    }
  }

  if (refreshType == RefreshType.PULL_DOWN) {
    newArticle.addAll(content.articles);
    content.articles = newArticle;
  } else {
    content.articles.addAll(newArticle);
  }

  store.dispatch(new UpdateArticle(content));
};
