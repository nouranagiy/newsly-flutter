import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/models/news_model.dart';
import '../data/repositories/news_repository.dart';
abstract class NewsState {}
class NewsInitial extends NewsState {}
class NewsLoading extends NewsState {}
class NewsSuccess extends NewsState {
  final List<NewsModel> news;
  final bool isOffline;
  NewsSuccess(
      this.news, {
        this.isOffline = false,
      });
}
class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}
class NewsCubit extends Cubit<NewsState> {
  final NewsRepository repository;
  NewsCubit(this.repository) : super(NewsInitial());
  Future<void> fetchNews() async {
    emit(NewsLoading());
    try {
      final connectivity = await Connectivity().checkConnectivity();
      final isOffline = connectivity.contains(ConnectivityResult.none);
      final news = await repository.getNews();
      emit(
        NewsSuccess(
          news,
          isOffline: isOffline,
        ),
      );
    } catch (e) {
      emit(
        NewsError('Unable to load news. Please check your internet connection.',),
      );
    }
  }
}