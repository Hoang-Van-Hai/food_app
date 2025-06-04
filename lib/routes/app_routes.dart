import 'package:get/get.dart';
import '../views/detail_screen.dart';
import '../views/main_screen.dart';
import '../views/account.dart';
import '../views/Love.dart';
import '../views/home_screen.dart';

class AppRoutes {
  static const home = '/';
  static const mainScreen = '/main';
  static const detail = '/detail';
  static const favorites = '/favorites';
  static const foodList = '/food-list';
  static const profile = '/profile';

  static final pages = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: mainScreen, page: () => const MainScreen()),
    GetPage(
      name: detail,
      page: () => const DetailScreen(),
    ), // KHÔNG dùng required meal ở đây
    GetPage(name: favorites, page: () => const LoveScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
  ];
}
