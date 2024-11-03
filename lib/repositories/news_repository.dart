import 'package:newz/api/api_service.dart';
import 'package:newz/models/news_resbones/article.dart';
import 'package:newz/models/sources_response/source.dart';

class NewsRepository {
  final APIService apiService;

  NewsRepository(this.apiService);

  Future<List<Source>> fetchSources(String categoryId) async {
    final response = await APIService.getSources(categoryId);
    return response.sources ?? [];
  }

  Future<List<Article>> fetchNewsByCategory(String category) async {
    final response = await APIService.getArticle(category);
    return response;
  }

  Future<List<Article>?> fetchNewsBySource(String sourceId) async {
    final response = await APIService.getNewsBySource(sourceId);
    return response.articles;
  }

  Future<List<Article>> fetchTrendingNews() async {
    return await APIService.getArticle("general");
  }

  Future<List<Article>> fetchMoreTrendingNews(int page) async {
    return await APIService.getArticle("general", page: page);
  }

  Future<List<Article>> searchNews(String query) async {
    final response = await APIService.getSearchResults(query);
    return response;
  }
}
