import 'package:flutter/material.dart';
import 'package:newz/api/api_service.dart';
import 'package:newz/models/news_resbones/article.dart';
import 'package:newz/models/sources_response/source.dart';
import 'package:newz/views/category/catagory_model.dart';

class CategoryViewModel extends ChangeNotifier {
  List<Article> articles = [];
  List<CatagoryModel> categories = [
    const CatagoryModel(
      id: "sports",
      categoryName: "Sports",
      gradientColors: [Color(0xFF43CBFF), Color(0xFF9708CC)],
      imageName: 'ball',
    ),
    const CatagoryModel(
      id: "technology",
      categoryName: "Technology",
      gradientColors: [Color(0xFFFBAB66), Color(0xFFF7418C)],
      imageName: 'Politics',
    ),
    const CatagoryModel(
      id: "health",
      categoryName: "Health",
      gradientColors: [Color(0xFF9B86F1), Color(0xFF4A3EA3)],
      imageName: 'health',
    ),
    const CatagoryModel(
      id: "business",
      categoryName: "Business",
      gradientColors: [Color(0xFFFFD34D), Color(0xFFE93C3C)],
      imageName: 'bussines',
    ),
    const CatagoryModel(
      id: "science",
      categoryName: "Science",
      gradientColors: [Color(0xFF6EE2F5), Color(0xFF6454F0)],
      imageName: 'science',
    ),
  ];
  bool isLoading = false;
  bool hasError = false;
  int selectedCategoryIndex = -1;
  List<Source> sources = [];
  int selectedTabIndex = 0;

  Future<void> fetchSources(String categoryId) async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final response = await APIService.getSources(categoryId);
      sources = response.sources ?? [];
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      notifyListeners();
    }
  }

  void setSelectedTabIndex(int index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  void setSelectedCategoryIndex(int index) {
    selectedCategoryIndex = index;
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
}
