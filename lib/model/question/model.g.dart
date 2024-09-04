// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      question: json['Question'] as String,
      answers: (json['Answers'] as List<dynamic>)
          .map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      scenario: json['Scenario'] as String?,
      url: json['Url'] as String?,
      type: $enumDecodeNullable(_$QuestionTypeEnumMap, json['Type']),
      shuffle: json['Shuffle'] as bool?,
      category: $enumDecode(_$QuestionCategoryEnumMap, json['Category']),
      level: $enumDecode(_$QuestionLevelEnumMap, json['Level']),
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'Question': instance.question,
      'Url': instance.url,
      'Scenario': instance.scenario,
      'Answers': instance.answers,
      'Shuffle': instance.shuffle,
      'Type': _$QuestionTypeEnumMap[instance.type],
      'Category': _$QuestionCategoryEnumMap[instance.category]!,
      'Level': _$QuestionLevelEnumMap[instance.level]!,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'multipleChoice',
  QuestionType.singleChoice: 'singleChoice',
};

const _$QuestionCategoryEnumMap = {
  QuestionCategory.theory: 'theory',
  QuestionCategory.practice: 'practice',
};

const _$QuestionLevelEnumMap = {
  QuestionLevel.easy: 'easy',
  QuestionLevel.medium: 'medium',
  QuestionLevel.hard: 'hard',
};
