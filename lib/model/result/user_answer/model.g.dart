// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAnswerModel _$UserAnswerModelFromJson(Map<String, dynamic> json) =>
    UserAnswerModel(
      point: (json['Point'] as num).toInt(),
      question:
          QuestionModel.fromJson(json['Question'] as Map<String, dynamic>),
      answers: (json['Answers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      time: (json['Time'] as num).toDouble(),
    );

Map<String, dynamic> _$UserAnswerModelToJson(UserAnswerModel instance) =>
    <String, dynamic>{
      'Point': instance.point,
      'Question': instance.question,
      'Answers': instance.answers,
      'Time': instance.time,
    };
