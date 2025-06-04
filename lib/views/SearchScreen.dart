import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/meal_model.dart';
import '../routes/app_routes.dart';
import '../widgets/filter_bottomsheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Meal> _searchResults = [];
  bool _isLoading = false;

  void _performSearch(String query) async {
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
      _searchResults = [];
    });

    try {
      final results = await ApiService.searchMealsByName(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Có lỗi xảy ra!')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Thanh tìm kiếm + filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm',
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        onSubmitted: (value) {
                          _performSearch(value.trim());
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.filter_alt, color: Colors.yellow),
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const FilterScreen(),
                      );
                      if (result != null) {
                        debugPrint('Đã chọn filter: $result');
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _searchResults.isEmpty
                      ? const Center(child: Text('Không tìm thấy món ăn nào!'))
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 3 / 3.5,
                              ),
                          itemCount: _searchResults.length,
                          itemBuilder: (_, index) {
                            final meal = _searchResults[index];
                            return _buildMealItem(meal);
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealItem(Meal meal) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.detail, arguments: meal);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.network(
                    meal.image,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Colors.red),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'By Little Pony',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('20m', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
