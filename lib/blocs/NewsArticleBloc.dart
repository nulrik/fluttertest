import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:grundfos_news/scraper.dart';
import 'package:grundfos_news/widgets/NewsListWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsArticleBloc extends Bloc<String, NewsItem> {
  final NewsArticle initialState = NewsArticle.placeholder();

  Map<String, NewsArticle> _articles = Map();
  String currentUrl;

  @override
  Stream<NewsItem> mapEventToState(
      NewsItem currentState, String url) async* {
    currentUrl = url;
    if (!_articles.containsKey(url)) {
      yield (listBloc.currentState.where((i)=>i.url == url).first)??initialState;
      _articles[url] = await getNewsArticle(url);
//      await Future.delayed(Duration(seconds: 3));
    }
    if (!DeepCollectionEquality().equals(currentState, _articles[url]))
      yield _articles[url];
  }

  void openUrl(url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void openArticleInBrowser() {
    if (currentState != null) openUrl(currentState.url);
  }

  void refresh() {
    _articles.remove(currentUrl);
    dispatch(currentUrl);
  }
}
