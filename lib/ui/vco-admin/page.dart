// import 'package:flutter/material.dart';
// import 'package:web_test/ui/admin/widget/drawer.dart';

// class VCOAdminPage extends StatelessWidget {
//   const VCOAdminPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Title(
//       title: 'VCO Online\'s Test | Admin',
//       color: Theme.of(context).primaryColor,
//       child: Scaffold(
//         body: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const AdminDrawer(),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TestResultWidget(
//                         results: results,
//                       ),
//                       const Divider(
//                         color: Colors.black,
//                         height: 40,
//                       ),
//                       PointSpectrumWidget(results: results),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }