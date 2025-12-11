part of 'app_pages.dart';

abstract class Routes {
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
  static const CHAT = _Paths.CHAT;
}

abstract class _Paths {
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const NEWS_DETAIL = '/news-detail';
  static const CHAT = '/chat';
}
