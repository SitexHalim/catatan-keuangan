// import 'package:catatan_keuangan/controller/controller_profile.dart';
// import 'package:catatan_keuangan/controller/controller_transaksi.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class GrafikperbandinganScreen extends StatefulWidget {
//   const GrafikperbandinganScreen({super.key});

//   @override
//   State<GrafikperbandinganScreen> createState() =>
//       _GrafikperbandinganScreenState();
// }

// class _GrafikperbandinganScreenState extends State<GrafikperbandinganScreen> {
//   final ControllerTransaksi transaksiController =
//       Get.put(ControllerTransaksi());
//   final ControllerProfile profileController = Get.put(ControllerProfile());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Grafik Keuangan Bulanan")),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: Obx(() {
//                 return LineChart(
//                   LineChartData(
//                     gridData: const FlGridData(show: true),
//                     titlesData: _buildTitlesData(),
//                     borderData: FlBorderData(show: true),
//                     lineBarsData: [
//                       _buildIncomeLine(),
//                       _buildExpenseLine(),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   FlTitlesData _buildTitlesData() {
//     return const FlTitlesData(
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(showTitles: true),
//       ),
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(showTitles: true),
//       ),
//     );
//   }

//   LineChartBarData _buildIncomeLine() {
//     return LineChartBarData(
//       spots: _generateChartData(transaksiController.getIncomeByDateRange),
//       isCurved: true,
//       color: Colors.blue,
//       barWidth: 3,
//     );
//   }

//   LineChartBarData _buildExpenseLine() {
//     return LineChartBarData(
//       spots: _generateChartData(transaksiController.getOutcomeByDateRange),
//       isCurved: true,
//       color: Colors.red,
//       barWidth: 3,
//     );
//   }

//   List<FlSpot> _generateChartData(
//       double Function(DateTime, DateTime) dataFetcher) {
//     List<FlSpot> spots = [];
//     for (int i = 0; i < 12; i++) {
//       DateTime month = DateTime(DateTime.now().year, 1 + i, 1);
//       double amount = dataFetcher(
//         DateTime(month.year, month.month, 1),
//         DateTime(month.year, month.month + 1, 0),
//       );
//       spots.add(FlSpot(i.toDouble(), amount));
//     }
//     return spots;
//   }
// }
