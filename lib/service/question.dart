import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:logger/web.dart';
import 'package:web_test/model/question/model.dart';

// final logger = Logger();
// class QuestionService {
//   final database = FirebaseDatabase.instance.ref('Question');
//   // final database = FirebaseDatabase.instance.ref('Question/NewQuestion');
//   Future<List<QuestionModel>> getTechnicalQuestions() async {
//     final technicalDatabase = database.child('Technical');
//     final data = await technicalDatabase.get();
//     List<QuestionModel> res = [];
//     if (data.exists) {
//       for (var data in data.children) {
//         final value = jsonDecode(jsonEncode(data.value));
//         final question = QuestionModel.fromJson(value);
//         res.add(question);
//       }
//     }
//     return res;
//   }

//   Future<List<QuestionModel>> getNumericalQuestion() async {
//     final technicalDatabase = database.child('Numerical');
//     final data = await technicalDatabase.get();
//     List<QuestionModel> res = [];
//     if (data.exists) {
//       for (var data in data.children) {
//         try {
//           final value = jsonDecode(jsonEncode(data.value));
//           final question = QuestionModel.fromJson(value)..type = QuestionType.numerical;
//           res.add(question);
//         } catch (e) {
//           Logger().e(e);
//         }
//       }
//     }
//     return res;
//   }

//   Future<List<QuestionModel>> getScenarioQuestion() async {
//     final technicalDatabase = database.child('Scenario');
//     final data = await technicalDatabase.get();
//     List<QuestionModel> res = [];
//     if (data.exists) {
//       for (var data in data.children) {
//         final value = jsonDecode(jsonEncode(data.value));
//         final question = QuestionModel.fromJson(value)..type = QuestionType.scenario;
//         res.add(question);
//       }
//     }
//     return res;
//   }

//   Future<List<QuestionModel>> getVerbalQuestion() async {
//     final technicalDatabase = database.child('Verbal');
//     final data = await technicalDatabase.get();
//     List<QuestionModel> res = [];
//     if (data.exists) {
//       for (var data in data.children) {
//         final value = jsonDecode(jsonEncode(data.value));
//         final question = QuestionModel.fromJson(value)..type = QuestionType.verbal;
//         res.add(question);
//       }
//     }
//     return res;
//   }

//   Future<List<QuestionModel>> getLogicalQuestion() async {
//     final technicalDatabase = database.child('Logical');
//     final data = await technicalDatabase.get();
//     List<QuestionModel> res = [];
//     if (data.exists) {
//       for (var data in data.children) {
//         final value = jsonDecode(jsonEncode(data.value));
//         final question = QuestionModel.fromJson(value)..type = QuestionType.logical;
//         res.add(question);
//       }
//     }
//     return res;
//   }

//     Future<List<QuestionModel>> getCriticalQuestion() async {
//     final technicalDatabase = database.child('Critical');
//     final data = await technicalDatabase.get();
//     List<QuestionModel> res = [];
//     if (data.exists) {
      
//       for (var data in data.children) {
//         final value = jsonDecode(jsonEncode(data.value));
//         final question = QuestionModel.fromJson(value)..type = QuestionType.critical;
//         res.add(question);
//       }
//     }
//     return res;
//   }
// }
final logger = Logger();
class QuestionService{
  final database = FirebaseDatabase.instance.ref('NewQuestion');
  Future<List<QuestionModel>> getSingleChoiceQuestion() async {
    final technicalDatabase = database.child('SingleChoice');
    final data = await technicalDatabase.get();
    List<QuestionModel> res = [];
    if (data.exists) {
      for (var data in data.children) {
        final value = jsonDecode(jsonEncode(data.value));
        final question = QuestionModel.fromJson(value)
          ..type = QuestionType.singleChoice;
        res.add(question);
      }
    }
    return res;
  }
  Future<List<QuestionModel>> getMultipleChoiceQuestion() async {
    final technicalDatabase = database.child('MultipleChoice');
    final data = await technicalDatabase.get();
    List<QuestionModel> res = [];
    if (data.exists) {
      for (var data in data.children) {
        final value = jsonDecode(jsonEncode(data.value));
        final question = QuestionModel.fromJson(value)
          ..type = QuestionType.multipleChoice;
        res.add(question);
      }
    }
    return res;
  }
  // Future<List<QuestionModel>> getImageQuestion() async {
  //   final technicalDatabase = database.child('ImageAttached');
  //   final data = await technicalDatabase.get();
  //   List<QuestionModel> res = [];
  //   if (data.exists) {
  //     for (var data in data.children) {
  //       final value = jsonDecode(jsonEncode(data.value));
  //       final question = QuestionModel.fromJson(value)
  //         ..type = QuestionType.imageAttached;
  //       res.add(question);
  //     }
  //   }
  //   return res;
  // }

    Future<List<QuestionModel>> getAllQuestions() async {
    try {
      // Fetch all question types in parallel
      final singleChoiceQuestions = getSingleChoiceQuestion();
      final multipleChoiceQuestions = getMultipleChoiceQuestion();
      // final imageAttachedQuestions = getImageQuestion();

      final results = await Future.wait([
        singleChoiceQuestions,
        multipleChoiceQuestions,
        // imageAttachedQuestions,
      ]);

      List<QuestionModel> allQuestions = [];
      for (var questionList in results) {
        allQuestions.addAll(questionList);
      }

      return allQuestions;
    } catch (e) {
      logger.e('Error fetching all questions: $e');
      return [];
    }
  }

}