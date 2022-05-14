import 'package:coco_task/Models/categories_model.dart';
import 'api_provider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<CategoriesModel> fetchCategoriesList() {
    return _provider.fetchCategoriesList();
  }

  Future<List<int>> fetchImageByCatsList(List<Category> catIds) async {
    List<int> realIds = await _provider.fetchImageByCatsList(catIds);

    return realIds;
  }
}

class NetworkError extends Error {}
