import '../data/models/news_model.dart';

enum FeedMode { forYou, topStories }

/// Applies feed-level rules to a raw article list:
/// - disliked articles are permanently dropped from every feed;
/// - "For You" only keeps articles matching the user's categories;
/// - "Top Stories" shows everything;
/// - a non-empty search query narrows whichever feed is active.
List<NewsModel> visibleNews({
  required List<NewsModel> news,
  required FeedMode mode,
  required Set<String> preferredCategories,
  required Set<String> dislikedIds,
  required String query,
}) {
  final result = <NewsModel>[];
  final normalizedQuery = query.trim().toLowerCase();
  final showsAll =
      mode == FeedMode.topStories ||
      preferredCategories.isEmpty ||
      preferredCategories.contains('general');

  for (final article in news) {
    if (dislikedIds.contains('${article.id}')) continue;
    if (!showsAll && !preferredCategories.contains(article.category)) {
      continue;
    }
    if (normalizedQuery.isNotEmpty && !_matches(article, normalizedQuery)) {
      continue;
    }
    result.add(article);
  }
  return result;
}

bool _matches(NewsModel article, String query) {
  return article.title.toLowerCase().contains(query) ||
      article.body.toLowerCase().contains(query) ||
      article.tags.any((tag) => tag.toLowerCase().contains(query));
}
