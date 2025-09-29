class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime? time;
  final TaskPriority priority;
  final TaskCategory category;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.time,
    required this.priority,
    required this.category,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? time,
    TaskPriority? priority,
    TaskCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time?.toIso8601String(),
      'priority': priority.name,
      'category': category.name,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
      priority: TaskPriority.values.firstWhere((e) => e.name == json['priority']),
      category: TaskCategory.values.firstWhere((e) => e.name == json['category']),
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent
}

enum TaskCategory {
  work,
  personal,
  study,
  other
}

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Rendah';
      case TaskPriority.medium:
        return 'Sedang';
      case TaskPriority.high:
        return 'Tinggi';
      case TaskPriority.urgent:
        return 'Mendesak';
    }
  }

  int get colorValue {
    switch (this) {
      case TaskPriority.low:
        return 0xFF4CAF50; // Green
      case TaskPriority.medium:
        return 0xFFFF9800; // Orange
      case TaskPriority.high:
        return 0xFFF44336; // Red
      case TaskPriority.urgent:
        return 0xFF9C27B0; // Purple
    }
  }
}

extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.work:
        return 'Pekerjaan';
      case TaskCategory.personal:
        return 'Pribadi';
      case TaskCategory.study:
        return 'Belajar';
      case TaskCategory.other:
        return 'Lainnya';
    }
  }

  int get iconCode {
    switch (this) {
      case TaskCategory.work:
        return 0xe1a9; // work
      case TaskCategory.personal:
        return 0xe7fd; // person
      case TaskCategory.study:
        return 0xe80c; // school
      case TaskCategory.other:
        return 0xe5c3; // more_horiz
    }
  }
}
