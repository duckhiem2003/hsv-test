import 'package:json_annotation/json_annotation.dart';
import 'package:logger/web.dart';
import 'package:web_test/model/question/model.dart';
part 'model.g.dart';
final logger = Logger();

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserAnswerModel {
  int point;
  QuestionModel question;
  List<int> answers;
  double time;

  UserAnswerModel({
    required this.point,
    required this.question,
    required this.answers,
    required this.time,
  });
  //  factory UserAnswerModel.fromJson(Map<String, dynamic> json) => _$UserAnswerModelFromJson(json);
factory UserAnswerModel.fromJson(Map<String, dynamic> json) {
  final answersJson = json['Answers'];
  final List<int> answers;
  
  if (answersJson == null) {
    answers = [];
  } else if (answersJson is List) {
    answers = List<int>.from(answersJson.map((e) => (e as num).toInt()));
  } else if (answersJson is num) {
    answers = [answersJson.toInt()];
  } else {
    answers = [];
  }

  return _$UserAnswerModelFromJson(json).copyWith(answers: answers);
}


Map<String, dynamic> toJson() {
  return _$UserAnswerModelToJson(this)
    ..['Answers'] = answers.isNotEmpty ? answers : null;
}


UserAnswerModel copyWith({
  int? point,
  QuestionModel? question,
  List<int>? answers,
  double? time,
}) {
  return UserAnswerModel(
    point: point ?? this.point,
    question: question ?? this.question,
    answers: answers ?? this.answers,
    time: time ?? this.time,
  );
}

}
