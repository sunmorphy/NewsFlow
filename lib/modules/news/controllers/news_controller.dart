import 'package:get/get.dart';
import '../../../data/local/models/local_article.dart';
import '../../../data/repository/news_repository.dart';

class NewsController extends GetxController {
  final NewsRepository _repository = NewsRepository();

  var articles = <LocalArticle>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final categories = ['Latest', 'Politics', 'Tech', 'Sport', 'Entertainment'];
  var selectedCategory = 'Latest'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  void changeCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    fetchNews(category: category);
  }

  Future<void> fetchNews({String category = 'Latest'}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getNews(category: category);

      articles.assignAll(result);
    } catch (e) {
      errorMessage.value = "No Internet.";
      articles.clear();
    } finally {
      isLoading.value = false;
    }
  }
}