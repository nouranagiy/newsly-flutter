import 'package:flutter/material.dart';
import '../data/models/news_model.dart';
class NewsDetailsScreen extends StatelessWidget {
  final NewsModel article;
  const NewsDetailsScreen({
    super.key,
    required this.article,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 6),
                Text('${article.views} views'),
                SizedBox(width: 20),
                Icon(
                  Icons.thumb_up_outlined,
                  size: 20,
                ),
                SizedBox(width: 6),
                Text('${article.likes}'),
              ],
            ),
            SizedBox(height: 24),
            Text(article.body,
              style: TextStyle(
                fontSize: 17,
                height: 1.7,
              ),
            ),
            if (article.tags.isNotEmpty) ...[
              SizedBox(height: 28),
              Text('Categories',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: article.tags.map((tag) => Chip(
                    label: Text('#$tag'),
                  ),
                ).toList(),
              ),
            ],
            SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Icon(Icons.thumb_up_outlined,),
                          SizedBox(height: 6),
                          Text('${article.likes}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text('Likes'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Icon(Icons.thumb_down_outlined,),
                          SizedBox(height: 6),
                          Text('${article.dislikes}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text('Dislikes'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}