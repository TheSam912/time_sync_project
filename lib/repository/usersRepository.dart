import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/request.dart';

abstract class AbstractUsersRepository {
  Future createUser(map);

  Future getUser(username);

  Future addProgram(userId, reqMap);
}

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepository();
});

class UsersRepository extends AbstractUsersRepository {
  @override
  Future createUser(map) async {
    var res = await MyRequest.apiPostRequest("/api/user/", map);
    return res;
  }

  @override
  Future getUser(username) async {
    var mapReq = {"username": username};
    var res = await MyRequest.apiPostRequest("/api/user/username", mapReq);
    return res;
  }

  @override
  Future addProgram(userId, reqMap) async {
    var res = await MyRequest.apiPutRequest("/api/user/$userId", reqMap);
    return res;
  }
}
