import '../data/models/news_model.dart';

sealed class NewsState {
  const NewsState();
}

class NewsInitial extends NewsState {
  const NewsInitial();
}

class NewsLoading extends NewsState {
  const NewsLoading();
}

class NewsSuccess extends NewsState {
  final List<NewsModel> news;
  final bool isOffline;

  const NewsSuccess(this.news, {this.isOffline = false});
}

class NewsError extends NewsState {
  const NewsError();
}
