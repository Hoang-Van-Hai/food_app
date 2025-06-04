import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';
import '../services/api_service.dart';

class CustomSearchController extends GetxController {
  var searchQuery = ''.obs;
  var searchResults = <Meal>[].obs;
  var isLoading = false.obs;
  var searchHistory = <String>[].obs;

  void search(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    try {
      final results = await ApiService.searchMealsByName(query);
      searchResults.value = results;

      if (!searchHistory.contains(query)) {
        searchHistory.insert(0, query);
      }
    } catch (e) {
      print('Lỗi tìm kiếm: $e');
      searchResults.clear();
    }
    isLoading.value = false;
  }
}

class MealController extends GetxController {
  var meals = <Meal>[].obs;
  var favorites = <String>{}.obs;
  var isLoading = false.obs;

  late Box favoritesBox;

  @override
  void onInit() {
    super.onInit();
    openHiveBox();
  }

  Future<void> openHiveBox() async {
    favoritesBox = await Hive.openBox('favorites');
    loadFavorites();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    try {
      isLoading.value = true;

      // Ưu tiên gọi ApiService nếu có
      final result = await ApiService.fetchMeals();
      meals.assignAll(result);

      // Hoặc trực tiếp dùng http để fetch
      final response = await http.get(
        Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> mealsJson = data['meals'];
        meals.value = mealsJson.map((json) => Meal.fromJson(json)).toList();
      } else {
        meals.clear();
      }
    } catch (e) {
      print("Error fetching meals: $e");
      meals.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void loadFavorites() {
    favorites.addAll(favoritesBox.keys.cast<String>());
  }

  void toggleFavorite(Meal meal) {
    if (favorites.contains(meal.id)) {
      favorites.remove(meal.id);
      favoritesBox.delete(meal.id);
    } else {
      favorites.add(meal.id);
      favoritesBox.put(meal.id, meal.toJson());
    }
  }

  List<Meal> get favoriteMeals {
    return favoritesBox.values
        .map((e) => Meal.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

class RecipeController extends GetxController {
  var isVideoTab = true.obs;
  var videoRecipes = <Recipe>[].obs;
  var normalRecipes = <Recipe>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  void toggleTab(bool isVideo) {
    isVideoTab.value = isVideo;
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    isLoading.value = true;
    final res = await http.get(
      Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s="),
    );
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List all = data['meals'] ?? [];

      final recipes = all.map((e) => Recipe.fromJson(e)).toList();

      videoRecipes.value = recipes.where((e) => e.name.contains("a")).toList();
      normalRecipes.value =
          recipes.where((e) => !e.name.contains("a")).toList();
    }

    isLoading.value = false;
  }
}

class FilterController extends GetxController {
  var categories = <String>[].obs;
  var ingredients = <String>[].obs;
  var areas = <String>[].obs;

  var selectedCategory = ''.obs;
  var selectedIngredient = ''.obs;
  var selectedArea = ''.obs;

  final Map<String, String> categoryMap = {
    'Beef': 'danh mục 1',
    'Chicken': 'danh mục 2',
    'Dessert': 'danh mục ',
    'Pasta': 'danh mục 3',
    'Breakfast': 'danh mục 4',
  };

  final Map<String, String> ingredientMap = {
    'Chicken': 'thịt gà',
    'Pork': 'thịt heo',
    'Chicken Breast': 'ức gà',
    'Chicken Leg': 'chân gà',
  };

  final Map<String, String> areaMap = {
    'Ho-Chi-Minh': 'TPHCM',
    'Binh Phuoc': 'Bình Phước',
    'Dong Nai': 'Đồng Nai',
    'An Giang': 'An Giang',
    'Long An': 'Long An',
  };

  @override
  void onInit() {
    fetchFilters();
    super.onInit();
  }

  void fetchFilters() async {
    try {
      final catRes = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?c=list'),
      );
      final ingRes = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?i=list'),
      );
      final areaRes = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?a=list'),
      );

      if (catRes.statusCode == 200 &&
          ingRes.statusCode == 200 &&
          areaRes.statusCode == 200) {
        final catData = (jsonDecode(catRes.body)['meals'] as List);
        final ingData = (jsonDecode(ingRes.body)['meals'] as List);
        final areaData = (jsonDecode(areaRes.body)['meals'] as List);

        categories.value =
            catData
                .where((e) => categoryMap.containsKey(e['strCategory']))
                .map<String>((e) => categoryMap[e['strCategory']]!)
                .toList();

        ingredients.value =
            ingData
                .where((e) => ingredientMap.containsKey(e['strIngredient']))
                .map<String>((e) => ingredientMap[e['strIngredient']]!)
                .toList();

        areas.value =
            areaData
                .where((e) => areaMap.containsKey(e['strArea']))
                .map<String>((e) => areaMap[e['strArea']]!)
                .toList();
      }
    } catch (e) {
      print("Error fetching filters: $e");
    }
  }

  void resetFilters() {
    selectedCategory.value = '';
    selectedIngredient.value = '';
    selectedArea.value = '';
  }
}
