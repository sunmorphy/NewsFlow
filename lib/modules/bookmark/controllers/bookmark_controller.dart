import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/local/database_helper.dart';
import '../../../data/local/models/local_article.dart';

class BookmarkController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final TextEditingController searchController = TextEditingController();

  var allBookmarks = <LocalArticle>[];
  var bookmarks = <LocalArticle>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void loadBookmarks() async {
    isLoading.value = true;

    final result = await _dbHelper.getBookmarks();

    allBookmarks = result;
    bookmarks.assignAll(result);

    isLoading.value = false;
  }

  void searchBookmarks(String query) {
    if (query.isEmpty) {
      bookmarks.assignAll(allBookmarks);
    } else {
      final filtered = allBookmarks.where((article) {
        final titleLower = article.title.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();

      bookmarks.assignAll(filtered);
    }
  }

  Future<void> toggleBookmark(LocalArticle article) async {
    final isSaved = await _dbHelper.isBookmarked(article.url);

    if (isSaved) {
      await _dbHelper.removeBookmark(article.url);
      Get.snackbar("Removed", "Article removed from bookmarks");
    } else {
      await _dbHelper.addBookmark(article);
      Get.snackbar("Bookmark", "Article saved to bookmarks");
    }

    loadBookmarks();
  }

  Future<bool> checkBookmarkStatus(String url) async {
    return await _dbHelper.isBookmarked(url);
  }
}
