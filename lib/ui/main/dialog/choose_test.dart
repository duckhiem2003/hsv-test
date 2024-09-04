import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_test/model/question/model.dart';
import 'package:web_test/service/question.dart';

// enum TestType {
//   brandManager,
//   assistantBM,
//   brandExecutive,
//   customType;

//   Map<QuestionType, int> get testStructure {
//     switch (this) {
//       case TestType.brandManager:
//         return {
//           QuestionType.numerical: 7,
//           QuestionType.techVMT: 5,
//           QuestionType.techPortfolio: 5,
//           QuestionType.techConsumerNeed: 5,
//           QuestionType.techDigitalMarketing: 5,
//           QuestionType.techProductLaunching: 5,
//           QuestionType.techCrossWork: 5,
//           QuestionType.techFMCGUndestanding: 0,
//           QuestionType.techProblem: 5,
//           QuestionType.scenario: 4
//         };
//       case TestType.assistantBM:
//         return {
//           QuestionType.numerical: 6,
//           QuestionType.techVMT: 3,
//           QuestionType.techPortfolio: 4,
//           QuestionType.techConsumerNeed: 4,
//           QuestionType.techDigitalMarketing: 4,
//           QuestionType.techProductLaunching: 4,
//           QuestionType.techCrossWork: 0,
//           QuestionType.techFMCGUndestanding: 5,
//           QuestionType.techProblem: 4,
//           QuestionType.scenario: 4
//         };
//       case TestType.brandExecutive:
//         return {
//           QuestionType.numerical: 5,
//           QuestionType.techVMT: 0,
//           QuestionType.techPortfolio: 4,
//           QuestionType.techConsumerNeed: 4,
//           QuestionType.techDigitalMarketing: 4,
//           QuestionType.techProductLaunching: 0,
//           QuestionType.techCrossWork: 0,
//           QuestionType.techFMCGUndestanding: 5,
//           QuestionType.techProblem: 4,
//           QuestionType.scenario: 4
//         };
//       case TestType.customType:
//         return {
//           QuestionType.numerical: 10,
//           QuestionType.techVMT: 0,
//           QuestionType.techPortfolio: 0,
//           QuestionType.techConsumerNeed: 0,
//           QuestionType.techDigitalMarketing: 0,
//           QuestionType.techProductLaunching: 0,
//           QuestionType.techCrossWork: 0,
//           QuestionType.techFMCGUndestanding: 0,
//           QuestionType.techProblem: 0,
//           QuestionType.scenario: 5,
//           QuestionType.logical: 10,
//           QuestionType.verbal: 10,
//           QuestionType.critical: 10,
//         };
//     }
//   }

//   int get totalQuestions {
//     int count = 0;
//     for (var type in QuestionType.values) {
//       count += (testStructure[type] ?? 0);
//     }
//     return count;
//   }

//   int get timeToComplete {
//     switch (this) {
//       case TestType.brandManager:
//         return 60;
//       case TestType.assistantBM:
//         return 50;
//       case TestType.brandExecutive:
//         return 40;
//       case TestType.customType:
//         return 60;
//     }
//   }

//   @override
//   String toString() {
//     switch (this) {
//       case TestType.brandManager:
//         return 'Brand Manager Test';
//       case TestType.assistantBM:
//         return 'Assistant Brand Manager Test';
//       case TestType.brandExecutive:
//         return 'Brand Executive Test';
//       case TestType.customType:
//         return '';
//     }
//   }
// }

// class ChooseTestDialog extends StatefulWidget {
//   const ChooseTestDialog({super.key});

//   @override
//   State<ChooseTestDialog> createState() => _ChooseTestDialogState();
// }

// class _ChooseTestDialogState extends State<ChooseTestDialog> {
//   TestType? selectedType;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(
//         'Choose your test',
//         style: TextStyle(
//           fontSize: 24.sp,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       content: SizedBox(
//         width: 600.w,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: TestType.values
//               .map(
//                 (e) => TestTypeWidget(
//                   type: e,
//                   isSelected: selectedType == e,
//                   onSelect: () {
//                     setState(() {
//                       selectedType = e;
//                     });
//                   },
//                 ),
//               )
//               .toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text(
//             'Cancel',
//             style: TextStyle(
//               color: Colors.red,
//               fontWeight: FontWeight.w500,
//               fontSize: 18.sp,
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             if (selectedType != null) {
//               Navigator.pop(context, selectedType);
//             }
//           },
//           child: Text(
//             'Start',
//             style: TextStyle(
//               color: selectedType != null ? Theme.of(context).primaryColor : const Color(0xFF838282),
//               fontWeight: FontWeight.w500,
//               fontSize: 18.sp,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TestTypeWidget extends StatelessWidget {
//   final TestType type;
//   final bool isSelected;
//   final VoidCallback onSelect;
//   const TestTypeWidget({
//     super.key,
//     required this.type,
//     required this.isSelected,
//     required this.onSelect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onSelect,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 8.h),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Radio(
//               value: isSelected,
//               groupValue: true,
//               onChanged: (value) {
//                 onSelect.call();
//               },
//             ),
//             SizedBox(width: 16.w),
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     type.toString(),
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           'Questions: ${type.totalQuestions.toString()}',
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 16.w),
//             Text(
//               'Time: ${type.timeToComplete} mins',
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


enum TestType {
  brandManager,
  assistantBM,
  brandExecutive,
  customType;

  // Updated structure with counts for theory and practice questions based on difficulty levels.
  Map<QuestionCategory, Map<QuestionLevel, int>> get testStructure {
    switch (this) {
      case TestType.brandManager:
      case TestType.assistantBM:
      case TestType.brandExecutive:
      case TestType.customType:
        return {
          QuestionCategory.theory: {
            QuestionLevel.easy: 5,
            QuestionLevel.medium: 5,
            QuestionLevel.hard: 5,
          },
          QuestionCategory.practice: {
            QuestionLevel.easy: 5,
            QuestionLevel.medium: 15,
            QuestionLevel.hard: 5,
          },
        };
    }
  }

  int get totalQuestions {
    int count = 0;
    for (var difficultyCounts in testStructure.values) {
      count += difficultyCounts.values.reduce((sum, count) => sum + count);
    }
    return count;
  }

  // Example times can be adjusted as needed per test type
  int get timeToComplete {
    switch (this) {
      case TestType.brandManager:
        return 90;
      case TestType.assistantBM:
        return 80;
      case TestType.brandExecutive:
        return 70;
      case TestType.customType:
        return 60;
    }
  }

  @override
  String toString() {
    switch (this) {
      case TestType.brandManager:
        return 'Brand Manager Test';
      case TestType.assistantBM:
        return 'Assistant Brand Manager Test';
      case TestType.brandExecutive:
        return 'Brand Executive Test';
      case TestType.customType:
        return 'Custom Test';
    }
  }
}

class ChooseTestDialog extends StatefulWidget {
  const ChooseTestDialog({super.key});

  @override
  State<ChooseTestDialog> createState() => _ChooseTestDialogState();
}

class _ChooseTestDialogState extends State<ChooseTestDialog> {
  TestType? selectedType;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Choose your test',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 600.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: TestType.values
              .map(
                (e) => TestTypeWidget(
                  type: e,
                  isSelected: selectedType == e,
                  onSelect: () {
                    setState(() {
                      selectedType = e;
                    });
                  },
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (selectedType != null) {
              Navigator.pop(context, selectedType);
            }
          },
          child: Text(
            'Start',
            style: TextStyle(
              color: selectedType != null ? Theme.of(context).primaryColor : const Color(0xFF838282),
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class TestTypeWidget extends StatelessWidget {
  final TestType type;
  final bool isSelected;
  final VoidCallback onSelect;
  const TestTypeWidget({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio(
              value: isSelected,
              groupValue: true,
              onChanged: (value) {
                onSelect.call();
              },
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.toString(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Questions: ${type.totalQuestions.toString()}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              'Time: ${type.timeToComplete} mins',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}