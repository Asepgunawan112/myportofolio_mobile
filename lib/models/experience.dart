import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

/// Portfolio project synchronized with the Django REST Framework API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    required this.title,
    required this.description,
    required this.techStack,
    required this.projectUrl,
    this.id,
    this.category,
    this.experienceLink,
    this.projectImageUrl = '',
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  @JsonKey(name: 'title', defaultValue: '')
  final String title;

  @JsonKey(name: 'description', defaultValue: '')
  final String description;

  @JsonKey(name: 'category', defaultValue: 'Part-time')
  final String? category;

  @JsonKey(name: 'experience_link', defaultValue: '')
  final String? experienceLink;

  @JsonKey(name: 'tech_stack', defaultValue: '')
  final String techStack;

  @JsonKey(name: 'project_url', defaultValue: '')
  final String projectUrl;

  @JsonKey(name: 'project_image_url', defaultValue: '')
  final String projectImageUrl;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
