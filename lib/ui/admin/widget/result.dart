import 'package:flutter/material.dart';
import 'package:web_test/common/extension/num_extension.dart';
import 'package:web_test/model/result/model.dart';
import 'package:web_test/service/excel.dart';
import 'package:web_test/ui/admin/test_result_page.dart';


enum DataColName {
  id,
  username,
  result,
  time,
  detail; 
}

class TestResultWidget extends StatefulWidget {
  final List<ResultModel> results;
  const TestResultWidget({super.key, required this.results});

  @override
  State<TestResultWidget> createState() => _TestResultWidgetState();
}

class _TestResultWidgetState extends State<TestResultWidget> {
  final excelService = ExcelService();

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    const cols = DataColName.values;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Test\'s result',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            16.wSpace,
            TextButton(
              onPressed: () async {
                await excelService.createExcel(widget.results);
              },
              child: const Text('Export Data'),
            ),
          ],
        ),
        Table(
          children: [
            TableRow(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.blue[50],
              ),
              children: List.generate(
                cols.length,
                (index) => TableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Text(
                      cols[index].name.toUpperCase(),
                    ),
                  ),
                ),
              ),
            ),
            ...widget.results.asMap().entries.map(
              (e) {
                return TableRow(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  children: List.generate(
                    cols.length,
                    (index) {
                      Widget content = const SizedBox.shrink(); 

                      switch (cols[index]) {
                        case DataColName.id:
                          content = Text(e.key.toString().padLeft(3, '0'));
                          break;
                        case DataColName.username:
                          content = Text(e.value.username);
                          break;
                        case DataColName.result:
                          content = Text(e.value.point.toString());
                          break;
                        case DataColName.time:
                          content = Text(
                            _printDuration(
                              Duration(
                                seconds: e.value.time.toInt(),
                              ),
                            ),
                          );
                          break;
                        case DataColName.detail:
                          content = GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TestResultPage(result: e.value),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              size: 16.0, // Smaller icon size
                            ),
                          );
                          break;
                      }

                      return TableCell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: content,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
