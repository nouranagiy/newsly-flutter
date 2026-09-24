import 'news_model.dart';

class SavedArticle {
  final NewsModel article;
  final DateTime savedAt;

  const SavedArticle({required this.article, required this.savedAt});
}
