import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/news_cubit.dart';
import '../data/models/news_model.dart';
import 'news_details_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsCubit>().fetchNews();
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  List<String> _getCategories(List<NewsModel> news) {
    final categories = <String>{'All'};
    for (final article in news) {
      categories.addAll(article.tags);
    }
    return categories.toList();
  }
  List<NewsModel> _filterNews(List<NewsModel> news) {
    final query = _searchQuery.toLowerCase().trim();
    return news.where((article) {
      final matchesSearch = query.isEmpty ||
              article.title.toLowerCase().contains(query) ||
              article.body.toLowerCase().contains(query) ||
              article.tags.any(
                    (tag) => tag.toLowerCase().contains(query),
              );
      final matchesCategory = _selectedCategory == 'All' || article.tags.contains(_selectedCategory);
      return matchesSearch && matchesCategory;
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newsly',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NewsCubit>().fetchNews();
            },
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is NewsError) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context.read<NewsCubit>().fetchNews();
              },
            );
          }
          if (state is NewsSuccess) {
            final categories = _getCategories(state.news);
            final news = _filterNews(state.news);
            if (!categories.contains(_selectedCategory)) {
              _selectedCategory = 'All';
            }
            return RefreshIndicator(
              onRefresh: () {
                return context.read<NewsCubit>().fetchNews();
              },
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (state.isOffline)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          0,
                        ),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.cloud_off_outlined,),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text('You are offline. Showing cached news.',),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        8,
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search news...',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {_searchQuery = '';});
                            },
                            icon: const Icon(Icons.clear,),
                          ) : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 52,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: 8,
                            ),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 8),
                  ),
                  if (news.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No news found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        16,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final article = news[index];
                            return _NewsCard(
                              article: article,
                            );
                          },
                          childCount: news.length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
class _NewsCard extends StatelessWidget {
  final NewsModel article;
  const _NewsCard({
    required this.article,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 14),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetailsScreen(
                article: article,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(article.body,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 5),
                  Text('${article.views} views'),
                  Spacer(),
                  Icon(
                    Icons.thumb_up_outlined,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text('${article.likes}'),
                ],
              ),
              if (article.tags.isNotEmpty) ...[
                SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: article.tags.map((tag) => Chip(
                      label: Text('#$tag'),
                      visualDensity: VisualDensity.compact,
                    ),
                  ).toList(),
                ),
              ],
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Read more',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_outlined,
              size: 70,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 16),
            Text('Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}