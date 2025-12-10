import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../widgets/container_gradient.dart';
import '../../news/views/widgets/news_card.dart';
import '../controllers/bookmark_controller.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookmarkController());

    return Scaffold(
      body: Stack(
        children: [
          ContainerGradient(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: kToolbarHeight + 20),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bookmarks",
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: "Search bookmark...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () => controller.searchBookmarks(
                            controller.searchController.text,
                          ),
                        ),
                      ),
                      onSubmitted: (val) => controller.searchBookmarks(val),
                    ),
                  ],
                ),
              ),

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
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.bookmarks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                size: 60,
                                color: context.theme.disabledColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "No saved articles yet",
                                style: context.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: controller.bookmarks.length,
                        itemBuilder: (context, index) {
                          final article = controller.bookmarks[index];
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
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
