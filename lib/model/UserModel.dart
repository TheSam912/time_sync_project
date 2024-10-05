class UserModel {
/*
{
  "_id": "66bf66868baedb9c78b851a0",
  "username": "sam@gmail.com",
  "program": "freelance",
  "createdAt": "2024-08-16T14:47:34.327Z",
  "updatedAt": "2024-08-16T14:53:03.304Z",
  "__v": 0
}
*/

  String? Id;
  String? username;
  String? program;

  UserModel({
    this.Id,
    this.username,
    this.program,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    username = json['username']?.toString();
    program = json['program']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['username'] = username;
    data['program'] = program;
    return data;
  }
}
