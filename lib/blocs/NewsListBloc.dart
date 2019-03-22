import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grundfos_news/scraper.dart';
import 'package:grundfos_news/widgets/NewsArticleScreen.dart';

class NewsListBloc extends Bloc<bool, List<NewsItem>> {
  final List<NewsItem> initialState = [];

  @override
  Stream<List<NewsItem>> mapEventToState(
      List<NewsItem> currentState, bool force) async* {
    if (currentState.isEmpty || force) {
      if (force) yield [];
      var list = await getNewsList();
      if (!DeepCollectionEquality().equals(currentState, list)) yield list;
    }
  }

  navigatoTo(BuildContext context, NewsItem item) {
    articleBloc.dispatch(item.url);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              NewsArticleScreen(item, item.imgurl, key: Key(item.url))),
    );
  }
}
