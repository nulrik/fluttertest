import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

void main() {
  getNewsArticle(
          "https://www.grundfos.com/about-us/news-and-press/news/live-stream-the-deciding-moments-in-our-quest-to-find-the-fastest-installer.html")
      .then(print);
}

Future<List<NewsItem>> getNewsList() async {
  var client = Client();
  Response response = await client.get(
      'https://www.grundfos.com/about-us/news-and-press/news/jcr:content/mainContent/results_878a.html');
  return parse(response.body)
      .querySelectorAll('.details')
      .map((e) => NewsItem.createFromElement(e))
      .toList();
}

Future<NewsArticle> getNewsArticle(String url) async {
  var client = Client();
  Response response = await client.get(url);

  var body = parse(response.body);
  var title = body.querySelectorAll('h1').first;
  var article = body.querySelectorAll('.text').first;
  return NewsArticle.createFromElement(title.text.trim(), article, url);
}

class NewsArticle implements NewsItem {
  String url;
  String date;
  String imgurl;
  String title;
  String teaser;
  String htmlContent;

  NewsArticle.placeholder() {
    url = "";
    date = "";
    title = "";
    teaser = "";
    htmlContent = "";
  }

  NewsArticle.createFromElement(this.title, Element e, String url) {
    this.url = url;

    var dateElement = e.getElementsByTagName("p").first;
    date = dateElement.text;
    dateElement.remove();

    var imgElement = e.getElementsByTagName("img").first;
    imgurl = Uri.parse(url).resolve(imgElement.attributes['src']).toString();
    imgElement.remove();

    var teaserElement = e.getElementsByTagName("h2").first;
    teaser = teaserElement.text;
    teaserElement.remove();

    e.getElementsByClassName("img-container").forEach((e) => e.remove());

    e
        .getElementsByTagName("p")
        .where((e) => e.text.trim().isEmpty)
        .forEach((e) => e.remove());

    htmlContent = e.innerHtml;
  }

  @override
  String toString() {
    return 'NewsArticle{url: $url, date: $date, imgurl: $imgurl, title: $title, htmlContent: $htmlContent}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsArticle &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          date == other.date &&
          imgurl == other.imgurl &&
          title == other.title &&
          teaser == other.teaser &&
          htmlContent == other.htmlContent;

  @override
  int get hashCode =>
      url.hashCode ^
      date.hashCode ^
      imgurl.hashCode ^
      title.hashCode ^
      teaser.hashCode ^
      htmlContent.hashCode;
}

class NewsItem {
  String url;
  String imgurl;
  String date;
  String title;
  String teaser;

  NewsItem(this.title);

  NewsItem.createFromElement(Element element) {
    var a = element
        .getElementsByClassName("sepro-t")
        .first
        .getElementsByTagName("a")
        .first;
    url = a.attributes['href'];

    var imgurlSmall = element.getElementsByTagName("img").first.attributes['src'];
    imgurl = imgurlSmall.replaceFirst(".thumbnail_small.", ".");

    date = element
        .getElementsByClassName("sepro-t")
        .first
        .getElementsByTagName("span")
        .first
        .text
        .trim();

    title = a.text.trim();

    teaser = element
        .getElementsByClassName("value")
        .first
        .children
        .first
        .text
        .trim();
  }

  @override
  String toString() {
    return 'NewsItem{url: $url, imgurl: $imgurl, date: $date, title: $title, teaser: $teaser}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NewsItem &&
              runtimeType == other.runtimeType &&
              url == other.url &&
              imgurl == other.imgurl &&
              date == other.date &&
              title == other.title &&
              teaser == other.teaser;

  @override
  int get hashCode =>
      url.hashCode ^
      imgurl.hashCode ^
      date.hashCode ^
      title.hashCode ^
      teaser.hashCode;





}
