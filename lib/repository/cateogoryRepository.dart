import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/categoryModel.dart';
import '../utils/request.dart';

abstract class AbstractCategoryRepository {
  Future getCategory();
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

class CategoryRepository extends AbstractCategoryRepository {
  List? categoryList;

  @override
  Future getCategory() async {
    var res = await MyRequest.apiGetRequest("/api/category");
    categoryList = (res).map((e) => CategoryModel.fromJson(e)).toList();
    return categoryList;
  }
}
