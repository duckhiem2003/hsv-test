import 'package:json_annotation/json_annotation.dart';
import 'package:web_test/model/question/answer/model.dart';
part 'model.g.dart';

enum QuestionType {
  multipleChoice,
  singleChoice,
}
enum QuestionCategory { theory, practice }

enum QuestionLevel { easy, medium, hard }

@JsonSerializable(fieldRename: FieldRename.pascal)
class QuestionModel {
  final String question;
  final String? url;
  final String? scenario;
  final List<AnswerModel> answers;
  final bool? shuffle;

  QuestionType? type;
  final QuestionCategory category;
  final QuestionLevel level;

  QuestionModel({
    required this.question,
    required this.answers,
    this.scenario,
    this.url,
    this.type,
    required this.shuffle,
    required this.category,
    required this.level,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}
