import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/ProgramModel.dart';

import '../utils/request.dart';

abstract class AbstractProgramRepository {
  Future getProgram();

  Future getOneProgram(id);

  Future getProgramByCategory(category);
}

final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  return ProgramRepository();
});

class ProgramRepository extends AbstractProgramRepository {
  List? programList;
  List? programSlices;
  ProgramModel? program;

  @override
  Future getProgram() async {
    var res = await MyRequest.apiGetRequest("/api/program");
    programList = (res).map((e) => ProgramModel.fromJson(e)).toList();
    return programList;
  }

  @override
  Future getOneProgram(id) async {
    var res = await MyRequest.apiGetRequest("/api/program/$id");
    program = ProgramModel.fromJson(res);
    return program;
  }

  @override
  Future getProgramByCategory(category) async {
    var mapReq = {"category": category};
    var res = await MyRequest.apiPostRequest("/api/program/category", mapReq);
    programList = (res).map((e) => ProgramModel.fromJson(e)).toList();
    return programList;
  }
}
