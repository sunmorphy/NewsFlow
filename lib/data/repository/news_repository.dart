import '../local/database_helper.dart';
import '../local/models/local_article.dart';
import '../remote/news_service.dart';

class NewsRepository {
  final NewsService _apiService;
  final DatabaseHelper _dbHelper;

  NewsRepository({NewsService? apiService, DatabaseHelper? dbHelper})
    : _apiService = apiService ?? NewsService(),
      _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<LocalArticle>> getNews({
    String category = 'Latest',
    String? query,
  }) async {
    try {
      final remoteArticles = await _apiService.getTopHeadlines(
        category: category,
        query: query,
      );

      final localArticles = remoteArticles.map((remote) {
        return LocalArticle(
          url: remote.url ?? remote.title ?? DateTime.now().toIso8601String(),
          title: remote.title ?? 'No Title',
          author: remote.source?.name ?? remote.author ?? 'Unknown',
          description: remote.description ?? '',
          urlToImage: remote.urlToImage ?? '',
          publishedAt: remote.publishedAt ?? '',
          content: remote.content ?? '',
          category: category,
        );
      }).toList();

      if (localArticles.isNotEmpty) {
        await _dbHelper.cacheArticles(localArticles);
      }

      return localArticles;
    } catch (e) {
      final cachedNews = await _dbHelper.getCachedArticles(category: category);

      return cachedNews;
    }
  }
}
