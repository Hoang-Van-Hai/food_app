import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Lấy tất cả món ăn (dùng search.php?s= để lấy hết)
  static Future<List<Meal>> fetchMeals() async {
    final url = Uri.parse('$baseUrl/search.php?s=');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'] ?? [];
      return meals.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  /// Lấy danh sách nguyên liệu
  static Future<List<Ingredient>> fetchIngredients() async {
    final url = Uri.parse('$baseUrl/list.php?i=list');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List ingredients = data['meals'] ?? [];
      return ingredients.map((e) => Ingredient.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load ingredients');
    }
  }

  /// Tìm kiếm món ăn theo tên (search by meal name)
  static Future<List<Meal>> searchMealsByName(String query) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return (data['meals'] as List)
            .map((json) => Meal.fromJson(json))
            .toList();
      } else {
        // Không tìm thấy món nào
        return [];
      }
    } else {
      throw Exception('Failed to load meals');
    }
  }

  /// Tìm kiếm món ăn theo nguyên liệu (search by ingredient)
  static Future<List<Meal>> searchMealsByIngredient(String ingredient) async {
    final url = Uri.parse('$baseUrl/filter.php?i=$ingredient');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'] ?? [];
      return meals.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }

  /// Lấy danh sách món ăn theo category
  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/filter.php?c=$category');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'] ?? [];
      return meals.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meals by category');
    }
  }

  /// Lấy chi tiết món ăn theo id
  static Future<Meal?> fetchMealDetail(String idMeal) async {
    final url = Uri.parse('$baseUrl/lookup.php?i=$idMeal');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'] ?? [];
      if (meals.isNotEmpty) {
        return Meal.fromJson(meals[0]);
      }
      return null;
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  /// Lấy toàn bộ tên món ăn để gợi ý (ví dụ lấy theo category hoặc lấy hết)
  static Future<List<String>> getAllMealTitles({
    String category = 'Seafood',
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=$category'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals =
          (data['meals'] as List)
              .map((meal) => meal['strMeal'] as String)
              .toList();
      return meals;
    } else {
      throw Exception('Lỗi khi lấy danh sách món ăn');
    }
  }
}
