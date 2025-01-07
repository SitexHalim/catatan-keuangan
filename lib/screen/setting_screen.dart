import 'package:catatan_keuangan/controller/controller_profile.dart';
import 'package:catatan_keuangan/controller/controller_transaksi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key});

  @override
  State<Settingscreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<Settingscreen> {
  final controller = Get.put(ControllerTransaksi());
  final controll = Get.put(ControllerProfile());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  String thematext = controll.themeMode.value == ThemeMode.dark
                      ? 'Tema Gelap'
                      : 'Tema Terang';
                  return Text(thematext);
                }),
                Obx(() {
                  return Switch(
                    value: controll.themeMode.value == ThemeMode.dark,
                    onChanged: (bool value) {
                      controll.saveTheme(value);
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Pilih Mata Uang
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mata Uang'),
                Obx(() {
                  return DropdownButton<String>(
                    value: controll.currency.value,
                    items: ['IDR', 'USD'].map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? newCurrency) {
                      if (newCurrency != null) {
                        controll.saveCurrency(newCurrency);
                        final formattedValue = controll.formatCurrency(
                            controll.maxExpense.value, newCurrency);
                        controll.expenseController.text = formattedValue;
                      }
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                TextField(
                  controller: controll.expenseController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Batas Pengeluaran',
                    hintText: 'Masukkan batas pengeluaran',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    String cleanedValue =
                        value.replaceAll(RegExp(r'[^\d.]'), '');
                    double parsedValue = double.tryParse(cleanedValue) ?? 0.0;
                    controll.maxExpense.value = parsedValue;
                  },
                  onEditingComplete: () {
                    final formattedValue = controll.formatCurrency(
                        controll.maxExpense.value, controll.currency.value);
                    controll.expenseController.text = formattedValue;

                    controll.expenseController.selection =
                        TextSelection.collapsed(offset: formattedValue.length);
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final maxExpense =
                          double.tryParse(controll.expenseController.text) ??
                              0.0;
                      controll.saveMaxExpense(maxExpense);
                      print('Berhasil menyimpan data ke sharedprefenced');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white),
                    child: const Text('Simpan Batas Pengeluaran'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
