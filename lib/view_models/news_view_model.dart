import 'package:flutter/material.dart';
import 'package:newz/api/api_service.dart';
import 'package:newz/models/news_resbones/article.dart';

class NewsViewModel extends ChangeNotifier {
  List<Article> articles = [];
  List<dynamic> trendingNews = [];
  bool isLoading = false;
  bool hasError = false;
  bool isMoreLoading = false;
  int currentPage = 1;
  final int pageSize = 5;

  Future<void> fetchTrendingNews({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isMoreLoading = true;
    } else {
      isLoading = true;
    }
    notifyListeners();

    try {
      final news = await APIService.getArticle(
        "general",
        page: currentPage,
        pageSize: pageSize,
      );
      trendingNews.addAll(news);
      currentPage++;
      isLoading = false;
      isMoreLoading = false;
      hasError = false;
    } catch (e) {
      isLoading = false;
      isMoreLoading = false;
      hasError = true;
    }
    notifyListeners();
  }

  Future<void> fetchNewsBySource(String sourceId) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final newsResponse = await APIService.getNewsBySource(sourceId);
      articles = newsResponse.articles ?? [];
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      notifyListeners();
    }
  }

  Future<void> fetchMoreNewsBySource(String sourceId) async {
    if (isMoreLoading) return;

    isMoreLoading = true;
    notifyListeners();

    try {
      final newsResponse = await APIService.getNewsBySource(
        sourceId,
        page: currentPage,
        pageSize: pageSize,
      );
      articles.addAll(newsResponse.articles ?? []);
      isMoreLoading = false;
      currentPage++; // زيادة الصفحة الحالية للتحميل التالي
    } catch (e) {
      isMoreLoading = false;
    }

    notifyListeners();
  }
}
