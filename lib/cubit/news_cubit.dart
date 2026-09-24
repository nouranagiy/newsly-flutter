import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/news_repository.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository repository;
  final Connectivity connectivity;

  NewsCubit(this.repository, {Connectivity? connectivity})
    : connectivity = connectivity ?? Connectivity(),
      super(const NewsInitial());

  Future<void> fetchNews() async {
    emit(const NewsLoading());
    try {
      final result = await connectivity.checkConnectivity();
      final isOffline = result.contains(ConnectivityResult.none);
      final news = await repository.getNews();
      emit(NewsSuccess(news, isOffline: isOffline));
    } catch (_) {
      emit(const NewsError());
    }
  }
}
