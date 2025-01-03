import 'package:catatan_keuangan/controller/controller_profile.dart';
import 'package:catatan_keuangan/controller/controller_transaksi.dart';
import 'package:catatan_keuangan/route/route_nama.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = Get.put(ControllerTransaksi());
  final controll = Get.put(ControllerProfile());
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Dashboard Transaksi')),
        actions: [
          ElevatedButton(
              onPressed: () {
                controller.resetdata();
              },
              child: const Icon(Icons.refresh_outlined))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            String formattedIncome = controll.formatCurrency(
                controller.totalIncome, controll.currency.value);
            String formattedOutcome = controll.formatCurrency(
                controller.totalOutcome, controll.currency.value);
            String formattedBalance = controll.formatCurrency(
                controller.balance, controll.currency.value);

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text("Pemasukan"),
                          subtitle: Text(formattedIncome),
                          onTap: () {
                            Get.offNamed(RouteNama.income);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: const Text("Pengeluaran"),
                          subtitle: Text(formattedOutcome),
                          onTap: () {
                            Get.offNamed(RouteNama.outcome);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  child: ListTile(
                    title: const Text("Saldo Total"),
                    subtitle: Text(formattedBalance),
                  ),
                ),
              ],
            );
          })),
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
