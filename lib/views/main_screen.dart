import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'package:food_app/models/meal_model.dart';
import 'searchScreen.dart';
import 'account.dart';
import '../views/recipe_screen.dart';
import 'package:food_app/widgets/meal_card.dart';
import '../routes/app_routes.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.grey, size: 20),
          hintText: 'Tìm kiếm sản phẩm',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Bạn vừa tìm kiếm: $value')));
          }
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  Future<List<Ingredient>>? _ingredientsFuture;

  @override
  void initState() {
    super.initState();
    _ingredientsFuture = ApiService.fetchIngredients();
  }

  Widget _homePage() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchInput(),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'TP. Hồ Chí Minh',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Xem tất cả',
                    style: TextStyle(color: Colors.amber, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder:
                      (_, index) => Container(
                        width: 260,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/Accont.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Danh mục',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Xem tất cả',
                    style: TextStyle(color: Colors.amber, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder:
                      (_, index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Danh mục ${index + 1}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Công thức gần đây',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    RecentMealCard(
                      imageUrl: 'assets/images/Salad.jpg',
                      title: 'Cách chiên trứng một cách cung phu',
                      duration: '1 tiếng 20 phút',
                      author: 'Hoàng Văn Hải',
                      authorImage: 'assets/images/avatar.png',
                      star: 5,
                    ),
                    RecentMealCard(
                      imageUrl: 'assets/images/Salad.jpg',
                      title: 'Món bún bò Huế chuẩn vị',
                      duration: '45 phút',
                      author: 'Hoàng Văn Hải',
                      authorImage: 'assets/images/avatar.png',
                      star: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Nguyên liệu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              FutureBuilder<List<Ingredient>>(
                future: _ingredientsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Lỗi: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Không có nguyên liệu');
                  }

                  final ingredients = snapshot.data!;
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        ingredients
                            .take(8)
                            .map(
                              (ingredient) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  ingredient.name,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            )
                            .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  final Widget _searchPage = SearchScreen();
  final Widget _bookmarkPage = RecipePage();
  final Widget _profilePage = ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final pages = [_homePage(), _searchPage, _bookmarkPage, _profilePage];

    return Scaffold(
      body: pages[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Xử lý khi nhấn dấu cộng
          Get.snackbar("Thêm", "Bạn đã nhấn nút dấu cộng");
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 10,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.search, 1),
              _buildHeartNavItem(), // Trái tim ở giữa, dưới dấu cộng
              _buildNavItem(Icons.bookmark, 2),
              _buildNavItem(Icons.person, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.amber : Colors.grey),
      onPressed: () {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  // Icon trái tim ở giữa, dưới dấu cộng
  Widget _buildHeartNavItem() {
    return IconButton(
      icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
      onPressed: () {
        Get.snackbar("Yêu thích", "Bạn đã nhấn nút yêu thích");
      },
    );
  }
}
