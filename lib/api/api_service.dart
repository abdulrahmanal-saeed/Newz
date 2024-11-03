import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newz/api/api_constants.dart';
import 'package:newz/models/news_resbones/article.dart';
import 'package:newz/models/news_resbones/news_resbones.dart';
import 'package:newz/models/sources_response/sources_response.dart';

class APIService {
  static Future<SourcesResponse> getSources(String categoryId) async {
    final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.sourceEndpoint, {
      'apiKey': ApiConstants.apiKey,
      'category': categoryId,
    });
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    return SourcesResponse.fromJson(json);
  }

  static Future<NewsResbones> getNewsBySource(String sourceId,
      {int page = 1, int pageSize = 5}) async {
    final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.newsEndpoint, {
      'apiKey': ApiConstants.apiKey,
      'sources': sourceId,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return NewsResbones.fromJson(json);
    } else {
      throw Exception('Failed to load news');
    }
  }

  static Future<List<Article>> getArticle(String categoryId,
      {int page = 1, int pageSize = 5}) async {
    final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.newsEndpoint, {
      'apiKey': ApiConstants.apiKey,
      'category': categoryId,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final newsResbones = NewsResbones.fromJson(json);
      return newsResbones.articles ?? [];
    } else {
      throw Exception('Failed to load news');
    }
  }

  static Future<List<Article>> getSearchResults(String query,
      {int page = 1, int pageSize = 5}) async {
    final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.newsEndpoint, {
      'apiKey': ApiConstants.apiKey,
      'q': query,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final newsResbones = NewsResbones.fromJson(json);
      return newsResbones.articles ?? [];
    } else {
      throw Exception('Failed to fetch search results');
    }
  }
}
