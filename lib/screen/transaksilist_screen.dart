import 'package:catatan_keuangan/controller/controller_profile.dart';
import 'package:catatan_keuangan/controller/controller_transaksi.dart';
import 'package:catatan_keuangan/model/model_transaksi.dart';
import 'package:catatan_keuangan/route/route_nama.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransaksilistScreen extends StatefulWidget {
  const TransaksilistScreen({super.key});

  @override
  State<TransaksilistScreen> createState() => _TransaksilistScreenState();
}

class _TransaksilistScreenState extends State<TransaksilistScreen> {
  final controller = Get.put(ControllerTransaksi());
  final controll = Get.put(ControllerProfile());
  String selectedFilter = 'D';
  int _selectedIndex = 1;

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

  DateTimeRange getDateRange(String filter) {
    DateTime now = DateTime.now();
    DateTime start;
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    if (filter == 'D') {
      start = DateTime(now.year, now.month, now.day);
      end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (filter == 'W') {
      start = now.subtract(const Duration(days: 7));
      end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (filter == 'M') {
      start = now.subtract(const Duration(days: 30));
      end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else {
      start = DateTime(now.year, now.month, now.day);
      end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    }

    return DateTimeRange(start: start, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Daftar Transaksi')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                  label: const Text("Harian"),
                  selected: selectedFilter == 'D',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = 'D';
                    });
                  },
                ),
                const SizedBox(width: 10),
                FilterChip(
                  label: const Text("Mingguan"),
                  selected: selectedFilter == 'W',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = 'W';
                    });
                  },
                ),
                const SizedBox(width: 10),
                FilterChip(
                  label: const Text("Bulanan"),
                  selected: selectedFilter == 'M',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = 'M';
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                DateTimeRange dateRange = getDateRange(selectedFilter);
                var filteredTransactions = controller
                    .getTransactionsByDateRange(dateRange.start, dateRange.end);

                double total = controller.getTotalByDateRange(
                    dateRange.start, dateRange.end);

                String formattedBalance =
                    controll.formatCurrency(total, controll.currency.value);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Total saldo ${_getfilterlabel(selectedFilter)} : $formattedBalance',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          var transaction = filteredTransactions[index];
                          String formattedDate =
                              controller.formattedDate(transaction.date);
                          String categoryName =
                              _getCategoryName(transaction.categoryId);

                          return Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(transaction.title),
                                  Text(formattedDate),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controll.formatCurrency(
                                      transaction.value,
                                      controll.currency.value)),
                                  Text(transaction.description),
                                  Text(categoryName)
                                ],
                              ),
                              onTap: () {
                                Get.to(TransactionDetailScreen(
                                    transaction: transaction));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            )
          ],
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

String _getfilterlabel(String filter) {
  switch (filter) {
    case 'D':
      return 'Harian';
    case 'W':
      return 'Mingguan';
    case 'M':
      return 'Bulanan';
    default:
      return '';
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
      return 'Unknown'; // Kategori yang tidak dikenali
  }
}

class TransactionDetailScreen extends StatelessWidget {
  final ModelTransaksi transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ControllerTransaksi>();
    final controll = Get.find<ControllerProfile>();
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Judul: ${transaction.title}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Kategori: ${_getCategoryName(transaction.categoryId)}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Deskripsi: ${transaction.description}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
                'Nilai: ${controll.formatCurrency(transaction.value, controll.currency.value)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Tanggal: ${controller.formattedDate(transaction.date)}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
