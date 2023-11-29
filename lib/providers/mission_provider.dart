// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:meals/models/meal.dart';

// class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
//   FavoriteMealsNotifier() : super([]);

//   bool toggleMealFavoriteStatus(Meal meal) {
//     final mealIsFavorite = state.contains(meal);

//     if (mealIsFavorite) {
//       state = state.where((m) => m.id != meal.id).toList();
//       return false;
//     } else {
//       state = [...state, meal]; // משכפל רשימה קיימת ומוסיף לה את MEAL
//       return true;
//     }
//   } 
// }

// final favoriteMealsProvider =
//     StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
//   //מכיל מידע שיכול להשתנות
//   return FavoriteMealsNotifier();
// });
