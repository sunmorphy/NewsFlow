import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../controllers/news_controller.dart';
import 'widgets/news_card.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NewsController());

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  context.theme.colorScheme.primary,
                  context.theme.colorScheme.secondary,
                ],
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: kToolbarHeight + 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top News\nIndonesia",
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    FilledButton(
                      onPressed: () => {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Icon(Icons.search, size: 28),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.categories.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final category = controller.categories[index];

                              return Obx(() {
                                final isSelected =
                                    controller.selectedCategory.value ==
                                    category;
                                final primaryColor =
                                    context.theme.colorScheme.primary;
                                final surfaceColor = context
                                    .theme
                                    .inputDecorationTheme
                                    .fillColor;

                                return GestureDetector(
                                  onTap: () =>
                                      controller.changeCategory(category),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : surfaceColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          color: isSelected
                                              ? context
                                                    .theme
                                                    .colorScheme
                                                    .onPrimary
                                              : context.theme.hintColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (controller.articles.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.article_outlined,
                                      size: 60,
                                      color: context.theme.disabledColor,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      controller.errorMessage.value.isNotEmpty
                                          ? controller.errorMessage.value
                                          : "No news available",
                                    ),
                                    if (controller
                                        .errorMessage
                                        .value
                                        .isNotEmpty)
                                      TextButton(
                                        onPressed: () => controller.fetchNews(
                                          category:
                                              controller.selectedCategory.value,
                                        ),
                                        child: const Text("Retry"),
                                      ),
                                  ],
                                ),
                              );
                            }

                            return RefreshIndicator(
                              onRefresh: () async {
                                await controller.fetchNews(
                                  category: controller.selectedCategory.value,
                                );
                              },
                              child: ListView.builder(
                                itemCount: controller.articles.length,
                                itemBuilder: (context, index) {
                                  final article = controller.articles[index];
                                  return NewsCard(
                                    article: article,
                                    onTap: () {
                                      Get.toNamed(
                                        Routes.NEWS_DETAIL,
                                        arguments: article,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: context.theme.colorScheme.primary,
        unselectedItemColor: context.theme.disabledColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
