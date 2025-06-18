import 'package:quiz/model/question.dart';

class Quiz {
  final String id;
  final String title;
  final String categoryId;
  final int timeLImit;
  final List<Question> questions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isShuffled;

  Quiz({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.timeLImit,
    required this.questions,
    this.createdAt,
    this.updatedAt,
    this.isShuffled = false, // default
  });

  factory Quiz.fromMap(String id, Map<String, dynamic> map) {
    return Quiz(
      id: id,
      title: map['title'] ?? "",
      categoryId: map['categoryId'] ?? "",
      timeLImit: map['timeLimit'] ?? 0,
      questions: ((map['questions'] ?? []) as List)
          .map((e) => Question.fromMap(e))
          .toList(),
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      isShuffled: map['isShuffled'] ?? false,
    );
  }

  Map<String, dynamic> toMap({bool isUpdate = false}) {
    return {
      'title': title,
      'categoryId': categoryId,
      'timeLimit': timeLImit,
      'questions': questions.map((e) => e.toMap()).toList(),
      'isShuffled': isShuffled,
      if (isUpdate) 'updatedAt': DateTime.now(),
      'createdAt': createdAt,
    };
  }

  Quiz copyWith({
    String? title,
    String? categoryId,
    int? timeLimit,
    List<Question>? questions,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isShuffled,
  }) {
    return Quiz(
      id: id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      timeLImit: timeLimit ?? this.timeLImit,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isShuffled: isShuffled ?? this.isShuffled,
    );
  }
}


