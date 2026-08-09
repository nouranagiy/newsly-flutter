import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/screens/home_screen.dart';
import 'core/network/api_service.dart';
import 'data/repositories/news_repository.dart';
import 'cubit/news_cubit.dart';
void main() {
  final apiService = ApiService();
  final repository = NewsRepository(apiService);
  runApp(
    BlocProvider(
      create: (_) => NewsCubit(repository),
      child: const NewslyApp(),
    ),
  );
}
class NewslyApp extends StatelessWidget {
  const NewslyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Newsly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}