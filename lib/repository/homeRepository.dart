import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/programRepository.dart';
import 'cateogoryRepository.dart';

final homePageRequests = FutureProvider<List<dynamic>>((ref) async {
  var categoryResponse =
      await ref.watch(categoryRepositoryProvider).getCategory();
  var programResponse = await ref.watch(programRepositoryProvider).getProgram();
  List<dynamic> responseList = [categoryResponse, programResponse];
  return responseList;
});

final categoryPageRequests = FutureProvider<List<dynamic>>((ref) async {
  var categoryResponse =
      await ref.watch(categoryRepositoryProvider).getCategory();
  List<dynamic> responseList = [categoryResponse];
  return responseList;
});
