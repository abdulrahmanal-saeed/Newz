import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newz/models/news_resbones/article.dart';

class ProfileRepository {
  Future<void> saveArticle(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticlesData = prefs.getStringList('savedArticles') ?? [];
    final articleData = jsonEncode(article.toJson());

    if (!savedArticlesData.contains(articleData)) {
      savedArticlesData.add(articleData);
      await prefs.setStringList('savedArticles', savedArticlesData);
    }
  }

  Future<List<Article>> getSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticlesData = prefs.getStringList('savedArticles') ?? [];
    return savedArticlesData
        .map((articleJson) => Article.fromJson(jsonDecode(articleJson)))
        .toList();
  }
}
