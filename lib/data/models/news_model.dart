class NewsModel {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int views;
  final int likes;
  final int dislikes;
  NewsModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.views,
    required this.likes,
    required this.dislikes,
  });
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      views: json['views'] ?? 0,
      likes: json['reactions']?['likes'] ?? 0,
      dislikes: json['reactions']?['dislikes'] ?? 0,
    );
  }
}