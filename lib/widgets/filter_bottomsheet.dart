import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final List<String> categories = [
    'Danh mục 1',
    'Danh mục 2',
    'Danh mục 3',
    'Danh mục 4',
  ];
  final List<String> ingredients = [
    'Thịt gà',
    'Thịt heo',
    'Danh mục',
    'Ức gà',
    'Chân gà',
  ];
  final List<String> areas = [
    'TP.HCM',
    'Bình Phước',
    'Đồng Nai',
    'An Giang',
    'Long An',
  ];

  final Set<String> selectedCategories = {};
  final Set<String> selectedIngredients = {};
  final Set<String> selectedAreas = {};

  void _resetFilters() {
    setState(() {
      selectedCategories.clear();
      selectedIngredients.clear();
      selectedAreas.clear();
    });
  }

  void _toggleSelection(Set<String> selectedSet, String item) {
    setState(() {
      if (selectedSet.contains(item)) {
        selectedSet.remove(item);
      } else {
        selectedSet.add(item);
      }
    });
  }

  Widget _buildSection(
    String icon,
    String title,
    List<String> items,
    Set<String> selectedSet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              items.map((item) {
                final isSelected = selectedSet.contains(item);
                return GestureDetector(
                  onTap: () => _toggleSelection(selectedSet, item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xFFFFC107)
                              : Colors.transparent,
                      border: Border.all(
                        color:
                            isSelected
                                ? Colors.transparent
                                : Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder:
          (_, controller) => Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thanh tiêu đề & nút Đặt lại
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'Lọc',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: _resetFilters,
                      child: const Text(
                        'Đặt lại',
                        style: TextStyle(color: Color(0xFFFFC107)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Các section
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          '📁',
                          'Danh mục',
                          categories,
                          selectedCategories,
                        ),
                        _buildSection(
                          '📁',
                          'Nguyên liệu',
                          ingredients,
                          selectedIngredients,
                        ),
                        _buildSection('📁', 'Khu vực', areas, selectedAreas),
                      ],
                    ),
                  ),
                ),

                // Nút Xác nhận
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Xử lý dữ liệu lọc
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
