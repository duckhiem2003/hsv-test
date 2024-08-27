import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_test/model/result/model.dart';

class TestResultPage extends StatelessWidget {
  final ResultModel result;

  TestResultPage({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Result'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {

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
              'Username: ${result.username}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Test Type: ${result.type.toString()}'),
            SizedBox(height: 10),
            Text('Points: ${result.point}'),
            SizedBox(height: 10),
            Text(
              'Time Taken: ${Duration(seconds: result.time.toInt()).toString().split('.').first}',
            ),
            SizedBox(height: 20),
            Text(
              'Questions and Answers:',
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

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${index + 1}: ${question.question}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (question.scenario != null && question.scenario!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text('Scenario: ${question.scenario}'),
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
                                    'Answer ${answerIndex + 1}: ${answerList[answerIndex].answer}',
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
                          if(answer.answer>=0)
                          Text(
                            'Selected Answer: ${answerList[answer.answer].answer}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: answerList[answer.answer].point == 1
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          if(answer.answer<0)
                          const Text(
                            'Selected Answer: None',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Time Spent: ${Duration(seconds: answer.time.toInt()).toString().split('.').first}',
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
