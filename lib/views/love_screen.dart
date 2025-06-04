import 'package:flutter/material.dart';
import 'love.dart';
import '../models/meal_model.dart';

class LoveScreen extends StatelessWidget {
  const LoveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lovedRecipes = LoveData.lovedRecipes;

    return Scaffold(
      appBar: AppBar(title: const Text('Món yêu thích')),
      body:
          lovedRecipes.isEmpty
              ? const Center(child: Text('Chưa có món nào yêu thích!'))
              : ListView.builder(
                itemCount: lovedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = lovedRecipes[index];
                  return ListTile(
                    leading: Image.network(
                      recipe.thumbnail,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                    title: Text(recipe.name),
                  );
                },
              ),
    );
  }
}
