import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final String title;
  final Map<String, double> dataMap;

  const PieChartWidget({
    required this.title,
    required this.dataMap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a list of purple shades
    final List<Color> purpleShades = [
      Colors.purple[200]!,
      Colors.purple[300]!,
      Colors.purple[400]!,
      Colors.purple[500]!,
      Colors.purple[600]!,
      Colors.purple[700]!,
    ];

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: dataMap.entries.map((entry) {
                    int index = dataMap.keys.toList().indexOf(entry.key);
                    return PieChartSectionData(
                      title: '${entry.key}\n${entry.value.toStringAsFixed(1)}%',
                      value: entry.value,
                      color: purpleShades[index % purpleShades.length],
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      radius: 100,
                    );
                  }).toList(),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
