import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/local/models/local_article.dart';
import '../../bookmark/controllers/bookmark_controller.dart';
import '../../chat/views/chat_view.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalArticle article = Get.arguments as LocalArticle;

    final bookmarkController = Get.put(BookmarkController());

    final isBookmarked = false.obs;
    bookmarkController.checkBookmarkStatus(article.url).then((value) {
      isBookmarked.value = value;
    });

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: article.urlToImage,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        height: 300,
                        color: context.theme.disabledColor.withOpacity(0.2),
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: context.textTheme.headlineMedium?.copyWith(
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Text(
                              "${article.author.isNotEmpty ? article.author : 'Unknown Author'} - ${DateFormat('MMM d, yyyy').format(DateTime.parse(article.publishedAt))}",
                              style: context.textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: context.theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                article.category.isNotEmpty
                                    ? article.category.capitalizeFirst!
                                    : 'News',
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: context.theme.colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Text(
                          article.content.isNotEmpty &&
                                  article.content != 'null'
                              ? article.content
                              : article.description,
                          style: context.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(
                  context,
                  key: Key('back_button'),
                  icon: Icons.arrow_back,
                  onTap: () => Get.back(),
                ),
                Obx(
                  () => _buildCircleButton(
                    context,
                    key: Key('bookmark_button'),
                    icon: isBookmarked.value
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    onTap: () async {
                      await bookmarkController.toggleBookmark(article);
                      isBookmarked.value = !isBookmarked.value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Get.to(() => const ChatView());
        },
        shape: CircleBorder(),
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
              ),
            ),
            Center(child: Icon(Icons.chat_bubble_rounded, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(
    BuildContext context, {
    required Key key,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.theme.cardColor.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
          ],
        ),
        child: Icon(icon, color: context.theme.iconTheme.color, size: 24),
      ),
    );
  }
}
