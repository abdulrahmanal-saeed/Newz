import 'package:newz/api/api_service.dart';
import 'package:newz/models/sources_response/sources_response.dart';

class CategoryRepository {
  final APIService apiService;

  CategoryRepository(this.apiService);

  Future<SourcesResponse> fetchSources(String categoryId) async {
    return await APIService.getSources(categoryId);
  }
}
