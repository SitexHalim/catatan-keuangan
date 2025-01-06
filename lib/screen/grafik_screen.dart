import 'package:catatan_keuangan/controller/controller_profile.dart';
import 'package:catatan_keuangan/controller/controller_transaksi.dart';
import 'package:catatan_keuangan/route/route_nama.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GrafikScreen extends StatefulWidget {
  const GrafikScreen({super.key});

  @override
  State<GrafikScreen> createState() => _GrafikscreenState();
}

class _GrafikscreenState extends State<GrafikScreen> {
  final controller = Get.put(ControllerTransaksi());
  final controll = Get.put(ControllerProfile());
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.offAllNamed(RouteNama.dashboard);
        break;
      case 1:
        Get.offAllNamed(RouteNama.transaksilist);
        break;
      case 2:
        Get.offAllNamed(RouteNama.grafik);
        break;
      case 3:
        Get.offAllNamed(RouteNama.profile);
        break;
    }
  }

  List<PieChartSectionData> _getIncomeCategoryData() {
    var categoryIncome = <int, double>{};

    controller.transaksi.where((tx) => tx.status == 'income').forEach((tx) {
      categoryIncome[tx.categoryId] =
          (categoryIncome[tx.categoryId] ?? 0) + tx.value;
    });

    double totalIncome =
        categoryIncome.values.fold(0, (sum, value) => sum + value);

    return categoryIncome.entries.map((entry) {
      double percentage = (entry.value / totalIncome) * 100;
      return PieChartSectionData(
        value: entry.value,
        color: _getCategoryColor(entry.key),
        title:
            '${_getCategoryName(entry.key)}\n${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  List<PieChartSectionData> _getOutcomeCategoryData() {
    var categoryOutcome = <int, double>{};

    controller.transaksi.where((tx) => tx.status == 'outcome').forEach((tx) {
      categoryOutcome[tx.categoryId] =
          (categoryOutcome[tx.categoryId] ?? 0) + tx.value;
    });

    double totalOutcome =
        categoryOutcome.values.fold(0, (sum, value) => sum + value);

    return categoryOutcome.entries.map((entry) {
      double percentage = (entry.value / totalOutcome) * 100;
      return PieChartSectionData(
        value: entry.value,
        color: _getCategoryColor(entry.key),
        title:
            '${_getCategoryName(entry.key)}\n${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Color _getCategoryColor(int categoryId) {
    switch (categoryId) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryName(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'Belanja';
      case 2:
        return 'Hiburan';
      case 3:
        return 'Gajian';
      default:
        return 'Unknown';
    }
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Grafik')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          List<double> incomeByMonth = controller.getIncomeByMonth();
          List<double> outcomeByMonth = controller.getOutcomeByMonth();

          return Column(
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: BarChart(
                  BarChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, MetaData) {
                              if (value == 0) {
                                return const Text('0');
                              } else if (value % 50 == 0) {
                                return Text(
                                    '${(value / 1000).toStringAsFixed(1)}K');
                              }
                              return Container();
                            },
                            reservedSize: 32,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, MetaData) {
                              switch (value.toInt()) {
                                case 1:
                                  return const Text('Jan');
                                case 2:
                                  return const Text('Feb');
                                case 3:
                                  return const Text('Mar');
                                case 4:
                                  return const Text('Apr');
                                case 5:
                                  return const Text('May');
                                case 6:
                                  return const Text('Jun');
                                case 7:
                                  return const Text('Jul');
                                case 8:
                                  return const Text('Aug');
                                case 9:
                                  return const Text('Sep');
                                case 10:
                                  return const Text('Oct');
                                case 11:
                                  return const Text('Nov');
                                case 12:
                                  return const Text('Dec');
                                default:
                                  return Container();
                              }
                            },
                            reservedSize: 32,
                          ),
                        )),
                    borderData: FlBorderData(show: true),
                    barGroups: List.generate(12, (index) {
                      return BarChartGroupData(
                        x: index + 1,
                        barRods: [
                          BarChartRodData(
                            fromY: 0,
                            toY: incomeByMonth[index],
                            color: Colors.green,
                            width: 10,
                          ),
                          BarChartRodData(
                            fromY: 0,
                            toY: outcomeByMonth[index],
                            color: Colors.red,
                            width: 10,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegend(Colors.green, 'Pemasukan'),
                  _buildLegend(Colors.red, 'Pengeluaran'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: _getIncomeCategoryData(),
                              centerSpaceRadius: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text('Pemasukan', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: _getOutcomeCategoryData(),
                              centerSpaceRadius: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text('Pengeluaran',
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Grafik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
