import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/controller.dart';
import '../models/meal_model.dart';
import 'love.dart';

class RecipePage extends StatelessWidget {
  final controller = Get.put(RecipeController());

  @override
  Widget build(BuildContext context) {
    final String searchQuery = Get.arguments ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Công thức"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildTabs(controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final recipes =
                  controller.isVideoTab.value
                      ? controller.videoRecipes
                      : controller.normalRecipes;

              final filtered =
                  searchQuery.isNotEmpty
                      ? recipes
                          .where(
                            (recipe) => recipe.name.toLowerCase().contains(
                              searchQuery.toLowerCase(),
                            ),
                          )
                          .toList()
                      : recipes;

              final finalList = filtered.isNotEmpty ? filtered : recipes;

              return ListView.builder(
                itemCount: finalList.length,
                itemBuilder:
                    (_, index) => _buildRecipeCard(
                      finalList[index],
                      controller.isVideoTab.value,
                    ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(RecipeController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.isVideoTab.value
                          ? Colors.yellow
                          : Colors.grey.shade300,
                ),
                onPressed: () => controller.toggleTab(true),
                child: const Text("Video"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.isVideoTab.value
                          ? Colors.grey.shade300
                          : Colors.yellow,
                ),
                onPressed: () => controller.toggleTab(false),
                child: const Text("Công thức"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe, bool isVideo) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(recipe.thumbnail),
              if (isVideo)
                const Positioned(
                  top: 8,
                  left: 8,
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "1 tiếng 20 phút",
                  style: TextStyle(color: Colors.blue),
                ),
                Text(
                  recipe.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/images/Accont.jpg'),
                    ),
                    const SizedBox(width: 8),
                    const Text("Hoàng Văn Hải"),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        LoveData.isLoved(recipe)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            LoveData.isLoved(recipe)
                                ? Colors.red
                                : Colors.black,
                      ),
                      onPressed: () {
                        LoveData.toggleLove(recipe);
                        Get.forceAppUpdate(); // Cập nhật UI
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
