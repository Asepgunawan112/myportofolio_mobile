import 'package:json_annotation/json_annotation.dart';

part 'certificate.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Certificate {
  const Certificate({
    this.id,
    required this.title,
    this.organization = '',
    required this.date,
    this.thumbnail,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      _$CertificateFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  final String title;

  @JsonKey(defaultValue: '')
  final String organization;

  final String date;

  final String? thumbnail;

  Map<String, dynamic> toJson() => _$CertificateToJson(this);
}
