import 'dart:convert';
import 'package:catatan_keuangan/model/model_transaksi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControllerTransaksi extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var transaksi = <ModelTransaksi>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  void clear() {
    titleController.clear();
    valueController.clear();
    descriptionController.clear();
  }

  Future<void> addTransaction(ModelTransaksi transaction) async {
    transaksi.insert(0, transaction);
    saveTransactions();
  }

  void loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionList = prefs.getString('transaksi');
    if (transactionList != null) {
      List<dynamic> jsonList = jsonDecode(transactionList);
      transaksi.value = jsonList.map((e) => ModelTransaksi.fromMap(e)).toList();
    }
  }

  void saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionList = transaksi.map((e) => e.toMap()).toList();
    prefs.setString('transaksi', jsonEncode(transactionList));
  }

  void resetdata() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('transaksi');
    transaksi.clear();
  }

  String formattedDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}";
  }

  double get totalIncome {
    double income = transaksi
        .where((tx) => tx.status == 'income')
        .fold(0, (sum, tx) => sum + tx.value);
    return income;
  }

  double get totalOutcome {
    double outcome = transaksi
        .where((tx) => tx.status == 'outcome')
        .fold(0, (sum, tx) => sum + tx.value);
    return outcome;
  }

  double get balance => totalIncome - totalOutcome;

  List<ModelTransaksi> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) {
    return transaksi.where((tx) {
      return tx.date.isAfter(startDate) && tx.date.isBefore(endDate) ||
          tx.date.isAtSameMomentAs(startDate) ||
          tx.date.isAtSameMomentAs(endDate);
    }).toList();
  }

  double getTotalByDateRange(DateTime startDate, DateTime endDate) {
    var filteredTransactions = transaksi.where((tx) {
      return tx.date.isAfter(startDate) && tx.date.isBefore(endDate) ||
          tx.date.isAtSameMomentAs(startDate) ||
          tx.date.isAtSameMomentAs(endDate);
    }).toList();

    double total = filteredTransactions.fold(0.0, (sum, tx) {
      if (tx.status == 'income') {
        return sum + tx.value;
      } else if (tx.status == 'outcome') {
        return sum - tx.value;
      }
      return sum;
    });

    return total;
  }

  double getIncomeByDateRange(DateTime startDate, DateTime endDate) {
    var filteredTransactions = transaksi.where((tx) {
      return tx.date.isAfter(startDate) && tx.date.isBefore(endDate) ||
          tx.date.isAtSameMomentAs(startDate) ||
          tx.date.isAtSameMomentAs(endDate);
    }).toList();

    return filteredTransactions
        .where((tx) => tx.status == 'income')
        .fold(0.0, (sum, tx) => sum + tx.value);
  }

  double getOutcomeByDateRange(DateTime startDate, DateTime endDate) {
    var filteredTransactions = transaksi.where((tx) {
      return tx.date.isAfter(startDate) && tx.date.isBefore(endDate) ||
          tx.date.isAtSameMomentAs(startDate) ||
          tx.date.isAtSameMomentAs(endDate);
    }).toList();

    return filteredTransactions
        .where((tx) => tx.status == 'outcome')
        .fold(0.0, (sum, tx) => sum + tx.value);
  }

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  List<double> getIncomeByMonth() {
    List<double> incomePerMonth = List.filled(12, 0.0);

    for (var tx in transaksi) {
      if (tx.status == 'income') {
        int month = tx.date.month - 1;
        incomePerMonth[month] += tx.value;
      }
    }

    return incomePerMonth;
  }

  List<double> getOutcomeByMonth() {
    List<double> outcomePerMonth = List.filled(12, 0.0);

    for (var tx in transaksi) {
      if (tx.status == 'outcome') {
        int month = tx.date.month - 1;
        outcomePerMonth[month] += tx.value;
      }
    }

    return outcomePerMonth;
  }

  RxList<Map<String, dynamic>> monthlySummary = <Map<String, dynamic>>[].obs;

  // Fungsi untuk mendapatkan jurnal keuangan bulanan
  List<Map<String, dynamic>> getMonthJurnal() {
    List<Map<String, dynamic>> summary = [];

    for (int month = 1; month <= 12; month++) {
      double totalIncome = getIncomeByMonth()[month - 1];
      double totalOutcome = getOutcomeByMonth()[month - 1];

      summary.add({
        'month': month,
        'totalIncome': totalIncome,
        'totalOutcome': totalOutcome,
        'balance': totalIncome - totalOutcome,
      });
    }

    return summary;
  }

  // Fungsi untuk memperbarui jurnal bulanan
  void updateMonthlyFinancialSummary() {
    List<Map<String, dynamic>> summary = getMonthJurnal();
    monthlySummary.assignAll(summary); // Update state
  }
}
