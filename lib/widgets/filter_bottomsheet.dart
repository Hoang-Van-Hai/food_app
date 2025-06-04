import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final selectedCategories = <String>{};
  final selectedIngredients = <String>{};
  final selectedLocations = <String>{};

  final categories = ['Danh mục 1', 'Danh mục 2', 'Danh mục 3', 'Danh mục 4'];
  final ingredients = ['Thịt gà', 'Thịt heo', 'Danh mục', 'Ức gà', 'Chân gà'];
  final locations = ['TP.HCM', 'Bình Phước', 'Đồng Nai', 'An Giang', 'Long An'];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.75, // 3/4 màn hình từ dưới lên
        widthFactor: 1,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Thanh kéo trên cùng
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 0),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Lọc',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedCategories.clear();
                            selectedIngredients.clear();
                            selectedLocations.clear();
                          });
                        },
                        child: const Text(
                          'Đặt lại',
                          style: TextStyle(
                            color: Color(0xFFDBA600),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(Icons.category_outlined, 'Danh mục'),
                        const SizedBox(height: 8),
                        _buildChipList(categories, selectedCategories),
                        const SizedBox(height: 16),
                        _buildSectionTitle(
                          Icons.local_dining_outlined,
                          'Nguyên liệu',
                        ),
                        const SizedBox(height: 8),
                        _buildChipList(ingredients, selectedIngredients),
                        const SizedBox(height: 16),
                        _buildSectionTitle(
                          Icons.location_on_outlined,
                          'Khu vực',
                        ),
                        const SizedBox(height: 8),
                        _buildChipList(locations, selectedLocations),
                      ],
                    ),
                  ),
                ),
                // Xác nhận
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDBA600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.back(
                          result: {
                            'categories': selectedCategories,
                            'ingredients': selectedIngredients,
                            'locations': selectedLocations,
                          },
                        );
                      },
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4A4A4A)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildChipList(List<String> items, Set<String> selectedItems) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          items.map((item) {
            final isSelected = selectedItems.contains(item);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedItems.remove(item);
                  } else {
                    selectedItems.add(item);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? const Color(0xFFDBA600)
                          : const Color(0xFFF7F4E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
