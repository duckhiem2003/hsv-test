import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_test/model/question/model.dart';
import 'package:web_test/model/result/model.dart';

class TestResultPage extends StatelessWidget {
  final ResultModel result;

  const TestResultPage({super.key, required this.result});

    int getQuestionScore(QuestionModel question) {
    if(question.category==QuestionCategory.practice){
      if(question.level==QuestionLevel.medium){
        return 2;
      }
      else{
        return 4;
      }
    }
    else{
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả chi tiết'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              // Add download functionality here if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nhóm: ${result.username}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Điểm số: ${result.point}'),
            SizedBox(height: 10),
            Text(
              'Thời gian làm bài: ${Duration(seconds: result.time.toInt()).toString().split('.').first}',
            ),
            SizedBox(height: 20),
            Text(
              'Câu hỏi và trả lời:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: result.answers.length,
                itemBuilder: (context, index) {
                  final answer = result.answers[index];
                  final question = answer.question;
                  final answerLength = question.answers.length;
                  final answerList = question.answers;
                  final questionLevel = question.level;
                  final questionCategory = question.category; // Assuming 'category' field exists
                  final answerScore = answer.point; // Score assigned based on question level and answers
                  final questionScore = getQuestionScore(question);

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Text(
                            'Loại câu hỏi: $questionCategory',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                          ),
                          Text(
                            'Mức độ: $questionLevel',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                          ),
                          Text(
                            'Điểm số câu hỏi: $questionScore',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                          ),
                          Text(
                            'Điểm số câu trả lời: $answerScore',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                          ),
                          Text(
                            'Câu hỏi ${index + 1}: ${question.question}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (question.scenario != null && question.scenario!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text('Chủ đề chi tiết: ${question.scenario}'),
                            ),
                          if (question.url != null && question.url!.isNotEmpty)
                            Center(
                              child: Builder(
                                builder: (context) {
                                  final url = question.url;
                                  RegExp regExp = RegExp(r"/d/([a-zA-Z0-9_-]+)");
                                  Match? match = regExp.firstMatch(url ?? '');
                                  String? fileId;
                                  if (match != null && match.groupCount >= 1) {
                                    fileId = match.group(1);
                                  }
                                  if (fileId != null) {
                                    return Container(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      width: 750.w,
                                      child: Image.network(
                                        'https://lh3.googleusercontent.com/d/$fileId',
                                        width: 750.w,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              itemCount: answerLength,
                              itemBuilder: (context, answerIndex) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Đáp án ${answerIndex + 1}: ${answerList[answerIndex].answer}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: answerList[answerIndex].point == 1 ? Colors.green : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (answer.answers.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: answer.answers.map((index) {
                                if (index >= 0 && index < answerList.length) {
                                  final selectedAnswer = answerList[index];
                                  return Text(
                                    'Câu đã chọn: ${selectedAnswer.answer}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedAnswer.point == 1 ? Colors.green : Colors.red,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }).toList(),
                            ),
                          if (answer.answers.length == 1 && answer.answers[0] == -1)
                            const Text(
                              'Chưa chọn câu trả lời',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          Text(
                            'Thời gian: ${Duration(seconds: answer.time.toInt()).toString().split('.').first}',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
