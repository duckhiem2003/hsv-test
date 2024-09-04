import 'dart:async';
import 'dart:html'as html;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/web.dart';
import 'package:web_test/generated/assets.gen.dart';
import 'package:web_test/model/question/model.dart';
import 'package:web_test/model/result/model.dart';
import 'package:web_test/model/result/user_answer/model.dart';
import 'package:web_test/service/local.dart';
import 'package:web_test/service/question.dart';
import 'package:web_test/service/result.dart';
import 'package:web_test/ui/main/dialog/choose_test.dart';
import 'package:web_test/utility/loading.dart';

class TestPage extends StatefulWidget {
  final TestType type;
  const TestPage({super.key, required this.type});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final QuestionService service = QuestionService();
  final ResultService resService = ResultService();
  final logger = Logger();
  List<QuestionModel> questions = [];
  late ResultModel res;
  // List<int> answers = [];
  List<List<int>> answers = [];
  late Timer _timer;
  late int time;
  int currentIndex = -1;
  late DateTime startTime;

  int SwitchedTabsTime = 0;
  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> getQuestions() async {
    List<QuestionModel> theoryQuestions = [];
    List<QuestionModel> practiceQuestions = [];
    List<QuestionModel> allQuestions= [];

    LoadingUtility.show();
    try {
      await Future.wait([
        ()async{
          allQuestions = await service.getAllQuestions();
        }.call(),
        
      ]);
    } catch (e) {
      logger.e(e);
    } finally {

    theoryQuestions = allQuestions.where((q) => q.category == QuestionCategory.theory).toList();
    practiceQuestions = allQuestions.where((q) => q.category == QuestionCategory.practice).toList();

    theoryQuestions.shuffle();
    practiceQuestions.shuffle();


    List<QuestionModel> easyTheory = theoryQuestions.where((q) => q.level == QuestionLevel.easy).take(15).toList();
    List<QuestionModel> mediumTheory = theoryQuestions.where((q) => q.level == QuestionLevel.medium).take(5).toList();
    // List<QuestionModel> hardTheory = theoryQuestions.where((q) => q.level == QuestionLevel.hard).take(1).toList();

    // List<QuestionModel> easyPractice = practiceQuestions.where((q) => q.level == QuestionLevel.easy).take(1).toList();
    List<QuestionModel> mediumPractice = practiceQuestions.where((q) => q.level == QuestionLevel.medium).take(10).toList();
    List<QuestionModel> hardPractice = practiceQuestions.where((q) => q.level == QuestionLevel.hard).take(15).toList();
      questions = [
      ...easyTheory,
      ...mediumTheory,
      // ...hardTheory,
      // ...easyPractice,
      ...mediumPractice,
      ...hardPractice,

      ];

          final typeCounts = {
      for (var type in QuestionType.values)
        type: questions.where((q) => q.type == type).length
    };

    final categoryCounts = {
      for (var category in QuestionCategory.values)
        category: questions.where((q) => q.category == category).length
    };

    final levelCounts = {
      for (var level in QuestionLevel.values)
        level: questions.where((q) => q.level == level).length
    };
    logger.i('Question Type Counts: $typeCounts');
    logger.i('Category Counts: $categoryCounts');
    logger.i('Level Counts: $levelCounts');
      questions.shuffle();
      var username = await LocalStorageUtility.getData('username');
      res = ResultModel(
        username: username ?? '',
        type: widget.type,
        time: 0,
        answers: List.generate(
          questions.length,
          (index) => UserAnswerModel(
            point: 0,
            question: questions[index],
            answers: [-1],
            time: 0,
          ),
        ),
        point: 0,
        tabSwitch:0,
      );
      for (var question in questions) {
        if(question.shuffle==true){
          question.answers.shuffle();
        }
        answers.add([-1]);
      }
      startTime = DateTime.now();
      currentIndex = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (time == 0) {
          _timer.cancel();
          onChangeQuestion(-1);
        }
        setState(() {
          time--;
        });
      });
      if (mounted) {
        setState(() {});
      }
      LoadingUtility.dismiss();
    }
  }

    void _enterFullscreen() {
    final element = html.document.documentElement;
    if (element != null) {
      element.requestFullscreen();
    }
  }

  void _exitFullscreen() {
    html.document.exitFullscreen();
  }

  @override
  void initState() {
    time = widget.type.timeToComplete * 50;
    questions = [];
    getQuestions();
    _enterFullscreen();
    html.document.onVisibilityChange.listen((event) {
      if (html.document.hidden!) {
        if (SwitchedTabsTime<3) {
          _showTabSwitchDialog();
          ++SwitchedTabsTime;
        } else {
          _autoSubmit();
        }
      }
    });
  //     html.document.onFullscreenChange.listen((event) {
  //       logger.i(html.document.fullscreenElement);
  //   if (html.document.fullscreenElement==null) {
      
  //     SwitchedTabsTime++;
  //     if (SwitchedTabsTime < 3) {
  //       _showTabSwitchDialog();
  //     } else {
  //       _autoSubmit();
  //     }
  //   }
  // });
    super.initState();
  }

bool _dialogIsVisible = false;
bool _forceDialogIsVisible = false;

Future<void> _showTabSwitchDialog() async {
  if (!mounted) return;
  if (_dialogIsVisible) {
      Navigator.of(context).pop();
      _dialogIsVisible = false;
    }
  _dialogIsVisible = true;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Cảnh báo', style: TextStyle(color: Colors.red)),
      content: Text('Bạn đã đổi tab $SwitchedTabsTime lần.\nĐổi tab quá 3 lần sẽ tự động nộp bài kiểm tra.'),
      actions: [
        TextButton(
          onPressed: () {
            if (mounted) {
              Navigator.pop(context);
            }
            _dialogIsVisible = false;
          },
          child: const Text('OK', style: TextStyle(color: Colors.black, fontSize: 18)),
        ),
      ],
    ),
  );
}


Future<void> _autoSubmit() async {
  if (!mounted||_forceDialogIsVisible) return;
  if (SwitchedTabsTime == 3) {
    if (_dialogIsVisible) {
      Navigator.of(context).pop();
      _dialogIsVisible = false;
    }
    _forceDialogIsVisible = true;
    await onForceSubmit(context);
  }
}

void onChangeQuestion(int newIndex) {
  res.answers[currentIndex].answers = answers[currentIndex];

final correctAnswers = questions[currentIndex].answers
    .asMap()
    .entries
    .where((entry) => entry.value.point == 1)
    .map((entry) => entry.key)
    .toSet();

  final userAnswers = answers[currentIndex].toSet();
  if(const SetEquality().equals(userAnswers, correctAnswers)){
    if(questions[currentIndex].category == QuestionCategory.theory){
      res.answers[currentIndex].point=1;
    }
    else if(questions[currentIndex].level==QuestionLevel.medium){
      res.answers[currentIndex].point=2;
    }
    else{
      res.answers[currentIndex].point=4;
    }
  }


  logger.i('Correct Answers: $correctAnswers\nUser Answers: $userAnswers');

  res.answers[currentIndex].time += ((DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) / 1000);
  

  if (newIndex == -1) {
    onSubmit(context);
    return;
  }

  currentIndex = newIndex;
  startTime = DateTime.now();
  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              Assets.images.background.path,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 50.h,
          horizontal: 100.w,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (questions.isNotEmpty)
                          Builder(builder: (context) {
                            final question = questions[currentIndex];
                            final answer = answers[currentIndex];
                            final isMultipleChoice = question.type == QuestionType.multipleChoice;
                            return QuestionWidget(
                              question: question,
                              index: currentIndex,
                              answer: answer,
                              onSelect: (value) {
                                if (isMultipleChoice) {
                                  if(answer.contains(-1)){
                                    answer.remove(-1);
                                  }
                                  if (answer.contains(value)) {
                                    answer.remove(value);
                                  } else {
                                    answer.add(value);
                                  }
                                } else {
                                  answers[currentIndex] = [value];
                                }
                                setState(() {});
                              },
                            );
                          }),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // if (currentIndex > 0)
                            //   SizedBox(
                            //     width: 100.w,
                            //     height: 50.h,
                            //     child: FilledButton(
                            //       onPressed: () {
                            //         onChangeQuestion(currentIndex - 1);
                            //       },
                            //       style: ButtonStyle(
                            //         shape: MaterialStatePropertyAll(
                            //           RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(8),
                            //           ),
                            //         ),
                            //         backgroundColor: const MaterialStatePropertyAll(Colors.grey),
                            //       ),
                            //       child: Text(
                            //         'Back',
                            //         style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                            //       ),
                            //     ),
                            //   ),
                            // const SizedBox(width: 24),
                            if (currentIndex < (questions.length - 1))
                              SizedBox(
                                width: 100.w,
                                height: 50.h,
                                child: FilledButton(
                                  onPressed: () {
                                    onChangeQuestion(currentIndex + 1);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Tiếp',
                                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.alarm,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Thời gian còn lại: '.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _printDuration(
                                Duration(
                                  seconds: time,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          final answer = answers[index];

                          return InkWell(
                            onTap: () {
                              // onChangeQuestion(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? const Color(0xFFed732f)
                                    : const ListEquality().equals(answer, [-1])
                                        ? Colors.grey
                                        : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: answers.length,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: FilledButton(
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          onChangeQuestion(-1);
                        },
                        child: const Text('Nộp bài'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nộp bài?'),
        content: const Text('Bạn có chắc chắc là muốn nộp bài chưa?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Hủy',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              _exitFullscreen();
            },
            child: const Text(
              'Nộp bài',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ).then((value) async {
      if (value == true) {
        LoadingUtility.show();
        double time = 0;
        int point = 0;
        try {
          for (var i = 0; i < res.answers.length; i++) {
            time += res.answers[i].time;
            point += res.answers[i].point;
          }
          res.tabSwitch = SwitchedTabsTime;
          res.time = time;
          res.point = point;
          resService.submitResult(res);
        } catch (e) {
          logger.e(e);
        } finally {
          LoadingUtility.dismiss();
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xin cảm ơn'),
            content: const Text('Cảm ơn bạn đã dành thời gian và công sức để làm bài.\nKết quả sẽ được chúng mình gửi lại sớm nhất'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ).then(
          (value) => Navigator.pop(context),
        );
      }
    });
  }

  Future<void> onForceSubmit(BuildContext context) {

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Cảnh báo',style: TextStyle(color: Colors.red),),
        content: const Text('Bạn đã đổi tab quá nhiều lần \nBài thi của bạn sẽ được tự động nộp'),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              'Nộp bài',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ).then((value) async {
      if (true) {
        LoadingUtility.show();
        double time = 0;
        int point = 0;
        try {
          for (var i = 0; i < res.answers.length; i++) {
            time += res.answers[i].time;
            point += res.answers[i].point;
          }
          res.tabSwitch = SwitchedTabsTime;
          res.time = time;
          res.point = point;
          resService.submitResult(res);
        } catch (e) {
          logger.e(e);
        } finally {
          LoadingUtility.dismiss();
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xin cảm ơn',style: TextStyle(color: Colors.green),),
            content: const Text('Cảm ơn bạn đã dành thời gian và công sức để làm bài.\nKết quả sẽ được chúng mình gửi lại sớm nhất'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  _exitFullscreen();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ).then(
          (value) => Navigator.pop(context),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _dialogIsVisible = false;
     html.document.onVisibilityChange.listen((event) {}).cancel();
    super.dispose();
  }
}

class QuestionWidget extends StatefulWidget {
  final int index;
  final QuestionModel question;
  final List<int> answer;
  final void Function(int index) onSelect;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.index,
    required this.onSelect,
    required this.answer,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  List<int> selectedAnswers = [];
  int? selectedAnswer;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<int>.from(widget.answer);
    if (selectedAnswers.isNotEmpty) {
      selectedAnswer = selectedAnswers.first;
    }
  }

  @override
  void didUpdateWidget(covariant QuestionWidget oldWidget) {
    if (oldWidget.answer != widget.answer) {
      setState(() {
        selectedAnswers = List<int>.from(widget.answer);
        if (selectedAnswers.isNotEmpty) {
          selectedAnswer = selectedAnswers.first;
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void toggleAnswer(int answerIndex) {
    setState(() {
      if (selectedAnswers.contains(answerIndex)) {
        selectedAnswers.remove(answerIndex);
      } else {
        selectedAnswers.add(answerIndex);
      }
    });
  }

  Widget answer() {
    switch (widget.question.type) {
      case QuestionType.multipleChoice:
        return multipleChoiceAnswer();
      default:
        return singleChoiceAnswer();
    }
  }

  Widget singleChoiceAnswer() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final answer = widget.question.answers[index];
        final isSelected = index == selectedAnswer;
        return InkWell(
          onTap: () {
            setState(() {
              selectedAnswer = index;
            });
            widget.onSelect.call(index);
          },
          child: Row(
            children: [
              Radio<int>(
                value: index,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = index;
                  });
                  widget.onSelect.call(index);
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  answer.answer,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: widget.question.answers.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  Widget multipleChoiceAnswer() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final answer = widget.question.answers[index];
        final isSelected = selectedAnswers.contains(index);
        return InkWell(
          onTap: () {
            toggleAnswer(index);
            widget.onSelect.call(index);
          },
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  toggleAnswer(index);
                  widget.onSelect.call(index);
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  answer.answer,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: widget.question.answers.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

Widget imageWithQuestion() {
  final url = widget.question.url;
  // Adjust regex to match Google Drive file ID correctly.
  RegExp regExp = RegExp(r"(?:/d/|id=)([a-zA-Z0-9_-]+)");
  Match? match = regExp.firstMatch(url ?? '');
  String? fileId = match?.group(1);

  // If the file ID is extracted, construct the correct image URL.
  return fileId != null
      ? Image.network(
          'https://lh3.googleusercontent.com/d/$fileId',
          width: double.infinity,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            // Display a loading spinner while the image is loading.
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Text('Image failed to load');
          },
        )
      : Container(); // Return an empty container if no file ID is found.
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.question.scenario != null && widget.question.scenario!.isNotEmpty)
              Text(
                "Chủ đề:${widget.question.scenario}",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: const Color(0xFF838282),
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              
              SizedBox(height: 10.h),
              Text(
                'Câu hỏi #${widget.index + 1}:',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                widget.question.question,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 20.h),
              if (widget.question.url != null &&
                  widget.question.url!.isNotEmpty )
                Center(child: imageWithQuestion()),
              answer(),
            ],
          ),
        ),
      ],
    );
  }
}
