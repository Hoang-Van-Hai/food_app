class Meal {
  final String id;
  final String name;
  final String image;
  final String youtube;
  final String thumbnail;
  final String? instructions;
  final String? description;
  final double? rating;
  final int? reviews;
  final String? authorImage;
  final String? author;
  final String? ingredients; // Có thể là 1 string json / text tổng hợp
  final List<String> ingredientList; // Danh sách nguyên liệu thực tế

  Meal({
    required this.id,
    required this.name,
    required this.image,
    required this.youtube,
    required this.thumbnail,
    this.instructions,
    this.description,
    this.rating,
    this.reviews,
    this.authorImage,
    this.author,
    this.ingredients,
    required this.ingredientList,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    // Xử lý ingredients từ các trường strIngredient + strMeasure
    List<String> parsedIngredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        String ing = ingredient.toString().trim();
        String mes = (measure ?? '').toString().trim();
        parsedIngredients.add(mes.isNotEmpty ? '$mes $ing' : ing);
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      image: json['strMealThumb'] ?? '',
      youtube: json['strYoutube'] ?? '',
      thumbnail: json['strThumbnail'] ?? '',
      instructions: json['strInstructions'],
      description: json['description'],
      rating:
          (json['rating'] != null)
              ? double.tryParse(json['rating'].toString())
              : null,
      reviews:
          (json['reviews'] != null)
              ? int.tryParse(json['reviews'].toString())
              : null,
      authorImage: json['authorImage'],
      author: json['author'],
      ingredients: json['ingredients'], // Có thể không có, tuỳ API
      ingredientList: parsedIngredients,
    );
  }

  Map<String, dynamic> toJson() => {
    'idMeal': id,
    'strMeal': name,
    'strMealThumb': image,
    'strYoutube': youtube,
    'strThumbnail': thumbnail,
    'strInstructions': instructions,
    'description': description,
    'rating': rating,
    'reviews': reviews,
    'authorImage': authorImage,
    'author': author,
    'ingredients': ingredients,
  };
}

class Recipe {
  final String id;
  final String name;
  final String thumbnail;
  final String? imageUrl;
  final String? duration;
  final String? title;
  final String? author;
  final String? authorImage;
  final int? star;

  Recipe({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.imageUrl,
    this.duration,
    this.title,
    this.author,
    this.authorImage,
    this.star,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      imageUrl: json['imageUrl'] ?? json['strMealThumb'],
      duration: json['duration'],
      title: json['title'] ?? json['strMeal'],
      author: json['author'],
      authorImage: json['authorImage'],
      star: json['star'],
    );
  }
}

class Ingredient {
  final String name;

  Ingredient({required this.name});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(name: json['strIngredient']);
  }

  Map<String, dynamic> toJson() => {'strIngredient': name};
}
