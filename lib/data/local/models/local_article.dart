class LocalArticle {
  final String title;
  final String author;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String category;

  LocalArticle({
    required this.title,
    required this.author,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'category': category,
    };
  }

  factory LocalArticle.fromMap(Map<String, dynamic> map) {
    return LocalArticle(
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      urlToImage: map['urlToImage'] ?? '',
      publishedAt: map['publishedAt'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? 'latest',
    );
  }
}