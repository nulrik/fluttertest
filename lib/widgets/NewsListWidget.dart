import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grundfos_news/blocs/NewsListBloc.dart';
import 'package:grundfos_news/scraper.dart';
import 'package:grundfos_news/widgets/NewsArticleScreen.dart';

final listBloc = NewsListBloc();

class NewsList extends StatelessWidget {
  NewsList() {
    listBloc.dispatch(false);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Grundfos News'),
      ),
      body: BlocBuilder<bool, List<NewsItem>>(
          bloc: listBloc,
          builder: (BuildContext context, List<NewsItem> state) {
            if (state.isEmpty)
              return Center(child: CircularProgressIndicator());
            return Scrollbar(
              child: ListView(
                padding: EdgeInsets.all(8),
                children: state
                    .map((NewsItem i) => new NewsCard(i, key: Key(i.url)))
                    .toList(),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => listBloc.dispatch(true),
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ), //
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsItem item;

  const NewsCard(
    this.item, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => listBloc.navigatoTo(context, item),
      child: Card(
        margin: EdgeInsets.all(8),
        child: ArticleStart(imgurl: item.imgurl, article: item, card: true),
      ),
    );
  }
}
