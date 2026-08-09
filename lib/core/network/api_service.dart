import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  final Dio dio;
  ApiService()
      : dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  Future<List<dynamic>> getNews() async {
    try {
      final response = await dio.get('/posts');
      final posts = response.data['posts'];
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        'cached_news',
        jsonEncode(posts),
      );
      return posts;
    } on DioException {
      final preferences = await SharedPreferences.getInstance();
      final cachedData = preferences.getString('cached_news');
      if (cachedData != null) {
        return jsonDecode(cachedData);
      }
      rethrow;
    }
  }
}