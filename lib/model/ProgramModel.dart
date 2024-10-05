class ProgramModelRoutineItems {
/*
{
  "title": "wake up early",
  "description": "routine description",
  "time": "5:00 AM to 7:00 AM",
  "isDone": true,
  "_id": "66a3cf93f539d31acebef1c3"
}
*/

  String? title;
  String? description;
  String? time;
  bool? isDone;
  String? Id;

  ProgramModelRoutineItems({
    this.title,
    this.description,
    this.time,
    this.isDone,
    this.Id,
  });

  ProgramModelRoutineItems.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    description = json['description']?.toString();
    time = json['time']?.toString();
    isDone = json['isDone'];
    Id = json['_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['time'] = time;
    data['isDone'] = isDone;
    data['_id'] = Id;
    return data;
  }
}

class ProgramModelSliceItems {
/*
{
  "sliceTitle": "slice title test1",
  "sliceValue": "60%",
  "_id": "66a3cf93f539d31acebef1c0"
}
*/

  String? sliceTitle;
  String? sliceValue;
  String? Id;

  ProgramModelSliceItems({
    this.sliceTitle,
    this.sliceValue,
    this.Id,
  });

  ProgramModelSliceItems.fromJson(Map<String, dynamic> json) {
    sliceTitle = json['sliceTitle']?.toString();
    sliceValue = json['sliceValue']?.toString();
    Id = json['_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sliceTitle'] = sliceTitle;
    data['sliceValue'] = sliceValue;
    data['_id'] = Id;
    return data;
  }
}

class ProgramModel {
/*
{
  "_id": "66a3cf93f539d31acebef1bf",
  "title": "title for the second program",
  "description": "test description for the second program",
  "category": "category one",
  "sliceItems": [
    {
      "sliceTitle": "slice title test1",
      "sliceValue": "60%",
      "_id": "66a3cf93f539d31acebef1c0"
    }
  ],
  "author": "abol",
  "points": [
    "a lot"
  ],
  "routineItems": [
    {
      "title": "wake up early",
      "description": "routine description",
      "time": "5:00 AM to 7:00 AM",
      "isDone": true,
      "_id": "66a3cf93f539d31acebef1c3"
    }
  ],
  "createdAt": "2024-07-26T16:32:19.249Z",
  "updatedAt": "2024-07-27T09:45:10.418Z",
  "__v": 0
}
*/

  String? Id;
  String? title;
  String? description;
  String? category;
  List<ProgramModelSliceItems>? sliceItems;
  String? author;
  List<String>? points;
  List<ProgramModelRoutineItems>? routineItems;

  ProgramModel({
    this.Id,
    this.title,
    this.description,
    this.category,
    this.sliceItems,
    this.author,
    this.points,
    this.routineItems,
  });

  ProgramModel.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    category = json['category']?.toString();
    if (json['sliceItems'] != null) {
      final v = json['sliceItems'];
      final arr0 = <ProgramModelSliceItems>[];
      v.forEach((v) {
        arr0.add(ProgramModelSliceItems.fromJson(v));
      });
      sliceItems = arr0;
    }
    author = json['author']?.toString();
    if (json['points'] != null) {
      final v = json['points'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      points = arr0;
    }
    if (json['routineItems'] != null) {
      final v = json['routineItems'];
      final arr0 = <ProgramModelRoutineItems>[];
      v.forEach((v) {
        arr0.add(ProgramModelRoutineItems.fromJson(v));
      });
      routineItems = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['title'] = title;
    data['description'] = description;
    data['category'] = category;
    if (sliceItems != null) {
      final v = sliceItems;
      final arr0 = [];
      v?.forEach((v) {
        arr0.add(v.toJson());
      });
      data['sliceItems'] = arr0;
    }
    data['author'] = author;
    if (points != null) {
      final v = points;
      final arr0 = [];
      v?.forEach((v) {
        arr0.add(v);
      });
      data['points'] = arr0;
    }
    if (routineItems != null) {
      final v = routineItems;
      final arr0 = [];
      v?.forEach((v) {
        arr0.add(v.toJson());
      });
      data['routineItems'] = arr0;
    }
    return data;
  }
}
