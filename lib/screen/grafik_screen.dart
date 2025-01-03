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
            '${_getCategoryName(entry.key)}\n${percentage.toStringAsFixed(1)}%', // Menambahkan persentase
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
            '${_getCategoryName(entry.key)}\n${percentage.toStringAsFixed(1)}%', // Menambahkan persentase
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Grafik')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Pemasukan dan Pengeluaran Berdasarkan Kategori',
                  style: TextStyle(fontSize: 15)),
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
          ),
        ),
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
