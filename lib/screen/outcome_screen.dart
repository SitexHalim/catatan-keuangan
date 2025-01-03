import 'package:catatan_keuangan/controller/controller_profile.dart';
import 'package:catatan_keuangan/controller/controller_transaksi.dart';
import 'package:catatan_keuangan/model/model_transaksi.dart';
import 'package:catatan_keuangan/route/route_nama.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutcomeScreen extends StatefulWidget {
  const OutcomeScreen({super.key});

  @override
  State<OutcomeScreen> createState() => _OutcomescreenState();
}

class _OutcomescreenState extends State<OutcomeScreen> {
  final controller = Get.put(ControllerTransaksi());
  final controll = Get.put(ControllerProfile());
  String status = 'outcome';
  int selectedCategory = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Transaksi Pengeluaran'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
                  fillColor: Colors.white,
                  filled: true),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.valueController,
              decoration: InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
                  fillColor: Colors.white,
                  filled: true),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.descriptionController,
              decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0)),
                  fillColor: Colors.white,
                  filled: true),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton<int>(
                  value: selectedCategory,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(_getCategoryName(value)),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    var transaction = ModelTransaksi(
                      id: controller.transaksi.length + 1,
                      date: DateTime.now(),
                      title: controller.titleController.text,
                      value: double.parse(controller.valueController.text),
                      description: controller.descriptionController.text,
                      status: status,
                      categoryId: selectedCategory,
                    );
                    controller.addTransaction(transaction);
                    controller.clear();

                    double currentExpense = controller.totalOutcome;
                    controll.checkExpenses(currentExpense);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white),
                  child: const Text('Simpan Transaksi'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.offNamed(RouteNama.dashboard);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  child: const Text('Kembali'),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Obx(() {
                var outcomeTransactions = controller.transaksi
                    .where((tx) => tx.status == 'outcome')
                    .take(3)
                    .toList();

                int itemCount = outcomeTransactions.length;
                return ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      var transaksi = outcomeTransactions[index];
                      String formattedDate = controller
                          .formattedDate(outcomeTransactions[index].date);
                      String categoryName =
                          _getCategoryName(transaksi.categoryId);
                      return Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(transaksi.title),
                              Text(formattedDate)
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controll.formatCurrency(
                                  transaksi.value, controll.currency.value)),
                              Text(transaksi.description),
                              Text(categoryName)
                            ],
                          ),
                        ),
                      );
                    });
              }),
            )
          ],
        ),
      ),
    );
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
