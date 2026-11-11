
class SkillModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String level;
  final int progress;

  SkillModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.level,
    required this.progress,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      level: json['level'] ?? 'Beginner',
      progress: json['progress'] ?? 0,
    );
  }
}
