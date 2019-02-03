import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leaf/model/FeedState.dart';
import 'package:leaf/redux/actions.dart';
import 'package:transparent_image/transparent_image.dart';

class ThreeImageCard extends StatelessWidget {
  final Article article;

  ThreeImageCard(this.article);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        getTitleText(article.title),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            getImageView(context, article.thumbnails[0]),
            getImageView(context, article.thumbnails[1]),
            getImageView(context, article.thumbnails[2]),
          ],
        )
      ],
    );
  }
}

class RightImageCard extends StatelessWidget {
  final Article article;

  RightImageCard(this.article);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: getTitleText(article.title),
          width: getUnitWidth(context) * 2,
        ),
        getImageView(context, article.thumbnails[0]),
      ],
    );
  }
}

class TextCard extends StatelessWidget {
  final Article article;

  TextCard(this.article);

  @override
  Widget build(BuildContext context) {
    return getTitleText(article.title);
  }
}

Widget getImageView(BuildContext context, Thumbnail thumbnail) {
  double imageWidth = getUnitWidth(context);
  double imageHeight = imageWidth * 0.618;
//  print(thumbnail.url +
//      '&width=' +
//      imageWidth.toString() +
//      '&height=' +
//      imageHeight.toString());
  return ClipRRect(
    child: FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      width: imageWidth,
      image: thumbnail.url +
          '&width=' +
          imageWidth.toString() +
          '&height=' +
          imageHeight.toString(),
      height: imageHeight,
      fit: BoxFit.cover,
    ),
    borderRadius: BorderRadius.circular(5.0),
  );
}

Widget getTitleText(String title) {
  return Container(
    child: Text(title,
        style: TextStyle(
            color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w600)),
    margin: EdgeInsets.fromLTRB(0, 5.0, 0, 10.0),
  );
}

double getUnitWidth(BuildContext context) {
  return (MediaQuery.of(context).size.width - 50.0) / 3.0;
}

typedef OnStateChanged = Function(Article item);
