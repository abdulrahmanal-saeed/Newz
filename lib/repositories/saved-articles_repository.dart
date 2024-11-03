import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SavedArticlesRepository {
  Future<List<Map<String, dynamic>>> loadSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticlesData = prefs.getStringList('savedArticles') ?? [];
    return savedArticlesData
        .map((articleJson) => jsonDecode(articleJson) as Map<String, dynamic>)
        .toList();
  }

  Future<void> saveArticles(List<Map<String, dynamic>> articles) async {
    final prefs = await SharedPreferences.getInstance();
    final articleStrings =
        articles.map((article) => jsonEncode(article)).toList();
    await prefs.setStringList('savedArticles', articleStrings);
  }
}
