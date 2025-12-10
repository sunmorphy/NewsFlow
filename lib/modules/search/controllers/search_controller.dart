import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/local/models/local_article.dart';
import '../../../data/repository/news_repository.dart';

class NewsSearchController extends GetxController {
  final NewsRepository _repository = NewsRepository();

  var searchResults = <LocalArticle>[].obs;
  var isLoading = false.obs;
  final TextEditingController searchTextController = TextEditingController();

  Future<void> searchNews(String query) async {
    try {
      isLoading.value = true;

      if (query.isEmpty) {
        searchResults.clear();
      } else {
        final result = await _repository.getNews(query: query);
        searchResults.assignAll(result);
      }
    } catch (e) {
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
