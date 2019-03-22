import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:grundfos_news/blocs/NewsArticleBloc.dart';
import 'package:grundfos_news/scraper.dart';
import 'package:transparent_image/transparent_image.dart';

final articleBloc = NewsArticleBloc();

class NewsArticleScreen extends StatelessWidget {
  final NewsItem article;

  final String imgurl;

  NewsArticleScreen(
    this.article,
    this.imgurl, {
    @required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grundfos News'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.open_in_browser),
            tooltip: "Open in browser",
            onPressed: articleBloc.openArticleInBrowser,
          ),
        ],
      ),
      body: BlocBuilder<String, NewsItem>(
          bloc: articleBloc,
          builder: (context, article) {
//            if (article.url.isEmpty) {
//              return SingleChildScrollView(
//                child: new NewsArticlePlaceholder(article,
//                    key: Key("#placeholder"), imgurl: imgurl),
//              );
//            }
            return SingleChildScrollView(
              child: new NewsArticleWidget(article,
                  key: Key(article.url), imgurl: imgurl),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: articleBloc.refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ), //
    );
  }
}

class NewsArticleWidget extends StatelessWidget {
  final NewsItem article;
  final String imgurl;

  const NewsArticleWidget(
    this.article, {
    @required Key key,
    @required this.imgurl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body;
    if ((article is NewsArticle)) {
      body = Html(
          padding: EdgeInsets.symmetric(horizontal: 24),
          onLinkTap: (url) => articleBloc.openUrl(url),
          data: (article as NewsArticle).htmlContent);
    } else {
      Container(
        height: 200,
        child: body = Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(children: [
      ArticleStart(imgurl: imgurl, article: article, card: false),
      body,
    ]);
  }
}

class ArticleStart extends StatelessWidget {
  const ArticleStart({
    Key key,
    @required this.card,
    @required this.imgurl,
    @required this.article,
  }) : super(key: key);

  final String imgurl;
  final NewsItem article;
  final bool card;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Hero(
            tag: imgurl,
            child: AspectRatio(
                aspectRatio: 1.444,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(card ? 4 : 0),
                        topRight: Radius.circular(card ? 4 : 0)),
                    child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage, image: imgurl)))),
        Padding(
          padding: card
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
          child: Hero(
            tag: article.url,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(article.title,
                        style: Theme.of(context).textTheme.headline)),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(article.date,
                      style: Theme.of(context).textTheme.subhead),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(article.teaser,
                      style: Theme.of(context).textTheme.subtitle),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
