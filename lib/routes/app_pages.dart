import 'package:get/get.dart';

import '../modules/auth/views/login_view.dart';
import '../modules/news/views/news_detail_view.dart';
import '../modules/news/views/news_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(name: _Paths.LOGIN, page: () => const LoginView()),
    GetPage(name: _Paths.HOME, page: () => const NewsView()),
    GetPage(name: _Paths.NEWS_DETAIL, page: () => const NewsDetailView()),
  ];
}
