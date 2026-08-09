import '../../core/network/api_service.dart';
import '../models/news_model.dart';
class NewsRepository {
  final ApiService apiService;
  NewsRepository(this.apiService);
  Future<List<NewsModel>> getNews() async {
    final data = await apiService.getNews();
    return data.map(
          (item) => NewsModel.fromJson(item),
    ).toList();
  }
}