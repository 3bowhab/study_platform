class CourseModel {
  final int id;
  final String title;
  final String description;
  final String teacherName;
  final String? thumbnail;
  final String status;
  final String difficulty;
  final String price;
  final int durationHours;
  final int totalSections;
  final int totalQuizzes;
  final int totalEnrollments;
  final double averageRating;
  final String createdAt;
  final String updatedAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.teacherName,
    this.thumbnail,
    required this.status,
    required this.difficulty,
    required this.price,
    required this.durationHours,
    required this.totalSections,
    required this.totalQuizzes,
    required this.totalEnrollments,
    required this.averageRating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      thumbnail: json['thumbnail'],
      status: json['status'] ?? '',
      difficulty: json['difficulty'] ?? '',
      price: json['price'] ?? '0',
      durationHours: json['duration_hours'] ?? 0,
      totalSections: json['total_sections'] ?? 0,
      totalQuizzes: json['total_quizzes'] ?? 0,
      totalEnrollments: json['total_enrollments'] ?? 0,
      averageRating:
          (json['average_rating'] is int)
              ? (json['average_rating'] as int).toDouble()
              : double.tryParse(json['average_rating'].toString()) ?? 0.0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
