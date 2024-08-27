import 'package:flutter/material.dart';
import 'package:web_test/model/result/model.dart';
import 'package:web_test/service/result.dart';
import 'package:web_test/ui/admin/widget/drawer.dart';
import 'package:web_test/ui/admin/widget/point_spectrum.dart';
import 'package:web_test/ui/admin/widget/result.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final resService = ResultService();
  List<ResultModel> results = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    resService.getAllResult().then((value) {
      results = value;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  

  void _nextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Online\'s Test | Admin',
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        body: Row(
          children: [
            const AdminDrawer(),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 20,
                              child: const Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Hello Admin',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     ElevatedButton.icon(
                        //       onPressed: () {},
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.white,
                        //       ),
                        //       icon: const Icon(Icons.file_download, color: Colors.black),
                        //       label: const Text('Export', style: TextStyle(color: Colors.black)),
                        //     ),
                        //     const SizedBox(width: 16),
                        //     ElevatedButton.icon(
                        //       onPressed: () {},
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.white,
                        //       ),
                        //       icon: const Icon(Icons.account_circle, color: Colors.black),
                        //       label: const Text('Account', style: TextStyle(color: Colors.black)),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: Row(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           const Text('Timeline:'),
                  //           const SizedBox(width: 8),
                  //           SizedBox(
                  //             width: 150, // Adjust width as needed
                  //             child: TextField(
                  //               readOnly: true,
                  //               decoration: InputDecoration(
                  //                 hintText: 'Jan 1, 2024',
                  //                 border: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.circular(8),
                  //                   borderSide: const BorderSide(),
                  //                 ),
                  //                 suffixIcon: const Icon(Icons.calendar_today),
                  //               ),
                  //               onTap: () async {
                  //                 DateTime? pickedDate = await showDatePicker(
                  //                   context: context,
                  //                   initialDate: DateTime.now(),
                  //                   firstDate: DateTime(2000),
                  //                   lastDate: DateTime(2101),
                  //                 );
                  //                 if (pickedDate != null) {
                  //                   setState(() {

                  //                   });
                  //                 }
                  //               },
                  //             ),
                  //           ),
                  //           const SizedBox(width: 8),
                  //           SizedBox(
                  //             width: 150, // Adjust width as needed
                  //             child: TextField(
                  //               readOnly: true,
                  //               decoration: InputDecoration(
                  //                 hintText: 'Dec 31, 2024',
                  //                 border: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.circular(8),
                  //                   borderSide: const BorderSide(),
                  //                 ),
                  //                 suffixIcon: const Icon(Icons.calendar_today),
                  //               ),
                  //               onTap: () async {
                  //                 DateTime? pickedDate = await showDatePicker(
                  //                   context: context,
                  //                   initialDate: DateTime.now(),
                  //                   firstDate: DateTime(2000),
                  //                   lastDate: DateTime(2101),
                  //                 );
                  //                 if (pickedDate != null) {
                  //                   setState(() {

                  //                   });
                  //                 }
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(width: 16),
                  //       Expanded(
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.end,
                  //           children: [
                  //             Expanded(
                  //               child: TextField(
                  //                 decoration: InputDecoration(
                  //                   prefixIcon: const Icon(Icons.search),
                  //                   hintText: 'Search...',
                  //                   border: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(8),
                  //                     borderSide: const BorderSide(),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             const SizedBox(width: 16),
                  //             ElevatedButton.icon(
                  //               onPressed: () {},
                  //               style: ElevatedButton.styleFrom(
                  //                 backgroundColor: Colors.white,
                  //               ),
                  //               icon: const Icon(Icons.filter_list, color: Colors.black),
                  //               label: const Text('Filter', style: TextStyle(color: Colors.black)),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: Row(
                      children: [
                        // const SizedBox(
                        //   width: 350,
                        //   child: Column(
                        //     children: [
                        //       Expanded(
                        //         child: PieChartWidget(
                        //           title: 'Candidates Distribution',
                        //           dataMap: {
                        //             "Completed": 63.8,
                        //             "Not Completed": 36.2,
                        //           },
                        //         ),
                        //       ),
                        //       Expanded(
                        //         child: PieChartWidget(
                        //           title: 'Score Distribution',
                        //           dataMap: {
                        //             "Passed 81%-100%": 13.1,
                        //             "Passed 61%-80%": 28.6,
                        //             "Passed 41%-60%": 28,
                        //             "Failed <41%": 30.3,
                        //           },
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Expanded(
                          // flex: 3,
                          child: Column(
                            children: [
                              // const Padding(
                              //   padding: EdgeInsets.all(16),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Row(
                              //         children: [
                              //           StatCard(
                              //             title: 'Total Participants',
                              //             value: '1000',
                              //             icon: Icons.people,
                              //           ),
                              //           StatCard(
                              //             title: 'Completed Tests',
                              //             value: '800',
                              //             icon: Icons.check_circle,
                              //           ),
                              //           StatCard(
                              //             title: 'Average Scores',
                              //             value: '36',
                              //             icon: Icons.trending_up,
                              //           ),
                              //           StatCard(
                              //             title: 'Next Round',
                              //             value: '29',
                              //             icon: Icons.arrow_forward,
                              //           ),
                              //         ],
                              //       ),
                              //       SizedBox(height: 16),
                              //       Divider(
                              //         color: Colors.black,
                              //         height: 40,
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: _previousPage,
                                    ),
                                    Expanded(
                                      child: PageView(
                                        controller: _pageController,
                                        children: [
                                          SingleChildScrollView(child: TestResultWidget(results: results)),
                                          SingleChildScrollView(child: PointSpectrumWidget(results: results)),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      onPressed: _nextPage,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
