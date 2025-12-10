import 'package:dio/dio.dart';

import '../../utils/constants.dart';
import 'models/article_response.dart';

class NewsService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  Future<List<RemoteArticle>> getTopHeadlines({String? category}) async {
    try {
      final Map<String, dynamic> queryParams = {
        // 'country': 'id',
        'apiKey': Constants.apiKey,
      };

      if (category != null && category.toLowerCase() != 'latest') {
        queryParams['category'] = category.toLowerCase();
      }

      final response = await _dio.get(
        Constants.topHeadlinesEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final result = ArticleResponse.fromJson(response.data);
        return result.articles.where((a) => a.title != '[Removed]').toList();
      } else {
        throw Exception('Failed to load news: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
