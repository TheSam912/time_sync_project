import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/categoryModel.dart';
import '../repository/cateogoryRepository.dart';

part 'categoryProvider.g.dart';

final categoryListProvider = FutureProvider.autoDispose((ref) async {
  return ref.watch(categoryRepositoryProvider).getCategory();
});

@riverpod
Future<CategoryModel> getCategories(ref) {
  return ref.watch(CategoryRepository().getCategory());
}
