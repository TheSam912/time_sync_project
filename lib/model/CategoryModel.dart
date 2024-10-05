class CategoryModel {
/*
{
  "_id": "66a3a0b5b02e5a043a564053",
  "title": "Loss Weight",
}
*/

  String? Id;
  String? title;

  CategoryModel({
    this.Id,
    this.title,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    title = json['title']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['title'] = title;
    return data;
  }
}
