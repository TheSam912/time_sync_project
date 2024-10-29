class AiProgramModel {
  String? title;
  String? description;
  String? category;
  Map<String, int>? sliceItems; // Key: Focus area (e.g., Productivity), Value: Percentage
  List<String>? points; // Key points of the plan
  List<RoutineItem>? routineItems; // List of daily routine activities

  AiProgramModel({
    this.title,
    this.description,
    this.category,
    this.sliceItems,
    this.points,
    this.routineItems,
  });

  // Factory constructor to parse JSON into the RoutinePlan model
  factory AiProgramModel.fromJson(Map<String, dynamic> json) {
    return AiProgramModel(
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      category: json['category']?.toString(),
      sliceItems: json['sliceItems'] != null
          ? Map<String, int>.from(json['sliceItems'])
          : null,
      points: json['points'] != null
          ? List<String>.from(json['points'])
          : null,
      routineItems: json['routineItems'] != null
          ? (json['routineItems'] as List).map((item) => RoutineItem.fromJson(item)).toList()
          : null,
    );
  }

  // Converts the model instance back into JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'sliceItems': sliceItems,
      'points': points,
      'routineItems': routineItems?.map((item) => item.toJson()).toList(),
    };
  }
}

class RoutineItem {
  String? title;
  String? description;
  String? time;
  bool? isDone;
  String? id;

  RoutineItem({
    this.title,
    this.description,
    this.time,
    this.isDone,
    this.id,
  });

  // Factory constructor to parse JSON into a RoutineItem
  factory RoutineItem.fromJson(Map<String, dynamic> json) {
    return RoutineItem(
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      time: json['time']?.toString(),
      isDone: json['isDone'] ?? false,
      id: json['_id']?.toString(),
    );
  }

  // Converts the RoutineItem instance back into JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'time': time,
      'isDone': isDone,
      '_id': id,
    };
  }
}
